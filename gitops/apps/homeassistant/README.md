# Configure via the Web UI

- Open your Home Assistant frontend / port-forward
- Navigate to Settings > System > Network
- Scroll down to the HTTP server section
- Turn Trust X-Forwarded-For to ON.
- Under Trusted proxies, add your network blocks (press enter/add after each one):
    - 127.0.0.1
    - ::
    - 110.42.0.0/16
    - 10.43.0.0/16
    - 192.168.0.0/16
    - 172.16.0.0/12
- Click Save.