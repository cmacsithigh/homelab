# Setup speaker

To initialise your speaker there are 3 steps to doing so. I am basing this on the [adafruit speaker bonnet](https://learn.adafruit.com/adafruit-speaker-bonnet-for-raspberry-pi) and following their guide for setup.

## Initialise speaker

To initialise a speaker just run this command. This will run through the script available from the link above. The script will execute 2 times with the speaker being rebooted twice

```bash
ansible-playbook ./ansible/playbooks/initalise_speakers.yaml
```

## Setup snapcast

After you've setup the raspberry pi with the bonnet and hooked it up to one of your speakers all that is left is to install snapclient. As our snapserver is managed by music assistant all we need to do is add the snapclients which this playbook does.

```bash
ansible-playbook ./ansible/playbooks/snapcast.yaml
```
