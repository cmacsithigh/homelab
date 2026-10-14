#!/usr/bin/env python3
### NZBGET POST-PROCESSING SCRIPT
#
# Send a notification when NZBGet finishes processing a download.
#
# NTFY_URL=http://ntfy.ntfy-system.svc.cluster.local
#     Base URL of the ntfy server.
#
# NTFY_TOPIC=homelab
#     ntfy topic to publish to.

import os
import sys
import urllib.error
import urllib.parse
import urllib.request


def main():
    base_url = os.environ.get(
        "NZBPO_NTFY_URL", "http://ntfy.ntfy-system.svc.cluster.local"
    ).rstrip("/")
    topic = os.environ.get("NZBPO_NTFY_TOPIC", "homelab").strip()

    if not base_url or not topic:
        print("ERROR: NTFY_URL and NTFY_TOPIC must not be empty.")
        return 1

    name = os.environ.get("NZBPP_NZBNAME", "Unknown download")
    status = os.environ.get("NZBPP_STATUS", "UNKNOWN").upper()
    message = f"{name} finished with status {status}."
    priorities = {"SUCCESS": "3", "WARNING": "4", "FAILURE": "5"}
    tags = {"SUCCESS": "white_check_mark", "WARNING": "warning", "FAILURE": "x"}

    url = f"{base_url}/{urllib.parse.quote(topic, safe='')}"
    request = urllib.request.Request(
        url,
        data=message.encode("utf-8"),
        headers={
            "Content-Type": "text/plain; charset=utf-8",
            "Title": "NZBGet download",
            "Priority": priorities.get(status, "3"),
            "Tags": tags.get(status, "package"),
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(request, timeout=10) as response:
            if response.status < 200 or response.status >= 300:
                print(f"ERROR: ntfy returned HTTP {response.status}.")
                return 1
    except (urllib.error.URLError, TimeoutError, OSError, ValueError) as error:
        print(f"ERROR: Could not send ntfy notification: {error}")
        return 1

    print(f"ntfy notification sent for {name} ({status}).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
