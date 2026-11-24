# Migrate a PostgreSQL cluster to SSD storage

This procedure migrates one CloudNativePG cluster from `nfs-storage` to
`nfs-internal-ssd`. PVC storage classes cannot be changed in place. It uses
Dispatcharr as the example; complete that migration independently, then repeat
the procedure for Keycloak with its own cluster and application names.

The Dispatcharr source cluster is `dispatcharr-postgres` and its SSD target is
`dispatcharr-pg`, in namespace `media-system`. Keep the application pointed at
the source until the target is promoted.

## Prepare and synchronize

1. Reconcile Flux to create the SSD target Cluster document in
   `gitops/apps/media-system/dispatcharr/postgresql.yaml`. It bootstraps from
   the source and remains a streaming replica. The target uses the source
   cluster's replication TLS secrets and application-user secret.
2. Wait until the target is ready and its instance pod exists:

```sh
kubectl get cluster dispatcharr-pg -n media-system
kubectl get pods -n media-system -l cnpg.io/cluster=dispatcharr-pg
```

   During bootstrap, CNPG creates temporary `*-pgbasebackup-*` pods. They run
   the backup process, not PostgreSQL; run SQL checks only in the target
   instance pod, `dispatcharr-pg-1`.
3. Check that the target is streaming and has replayed all WAL it has received:

```sh
kubectl exec -n media-system dispatcharr-pg-1 -- \
   psql -U postgres -d postgres -tAc \
   "SELECT status, pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() FROM pg_stat_wal_receiver;"
```

   Continue when the result is `streaming|t`.

## Cut over Dispatcharr

1. Stop Dispatcharr writes by setting `spec.replicas` to `0` in
   `gitops/apps/media-system/dispatcharr/dispatcharr.yaml`; wait for Flux to
   apply the change.
2. Rerun the replication query above. Continue only when it reports
   `streaming|t`.
3. In the `dispatcharr-pg` Cluster document in
   `gitops/apps/media-system/dispatcharr/postgresql.yaml`, set
   `spec.replica.enabled` to `false`. Reconcile Flux and wait for the target to
   become primary:

```sh
kubectl exec -n media-system dispatcharr-pg-1 -- psql -U postgres -d postgres -tAc "SELECT NOT pg_is_in_recovery();"
```

   Continue when the result is `t`.
4. Set `POSTGRES_HOST` to `dispatcharr-pg-rw` in
   `gitops/apps/media-system/dispatcharr/config.yaml` and restore
   `spec.replicas` to `1`. Reconcile Flux.
5. Verify Dispatcharr is healthy and can read and write its data. In the
   `dispatcharr-pg` Cluster document in
   `gitops/apps/media-system/dispatcharr/postgresql.yaml`, remove:
   - The entire `spec.replica` section, including `enabled` and `source`.
   - The entire `spec.externalClusters` section, including the source
     connection parameters and replication TLS secret references.

   `spec.bootstrap.pg_basebackup` is only used to initialize an empty target;
   it does not maintain replication or provide a backup. It can remain as
   initialization history, but after removing `externalClusters` and the
   source cluster it cannot bootstrap a fresh target. Recreating the Cluster
   resource is only safe if its existing data PVCs are retained and reused, or
   if you have a separate tested backup/restore procedure. The old source is
   not a valid recovery copy after cutover because it stops receiving writes.
   Reconcile this change and wait for Flux to report it healthy.
6. Remove the old `dispatcharr-postgres` Cluster resource only in a subsequent
   change.

For another cluster, substitute its namespace, source and target cluster names,
application scale setting, and database endpoint. Repeat the synchronization
and cutover checks for that cluster; do not promote it as part of this
Dispatcharr procedure.

Do not delete the source cluster or switch the application endpoint before
promotion. After the application writes to the target, switching back to the
source would lose those writes.
