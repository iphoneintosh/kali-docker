#!/bin/bash

# Set password for VNC

mkdir -p /root/.vnc/
echo $VNCPWD | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

# Start VNC server

if [ $VNCEXPOSE = 1 ]
then
  # Expose VNC
  vncserver :0 -rfbport $VNCPORT -geometry $VNCDISPLAY -depth $VNCDEPTH \
    > /var/log/vncserver.log 2>&1
else
  # Localhost only
  vncserver :0 -rfbport $VNCPORT -geometry $VNCDISPLAY -depth $VNCDEPTH -localhost \
    > /var/log/vncserver.log 2>&1
fi

# Start noVNC server

if [ ! -f /etc/ssl/certs/novnc_cert.pem -o ! -f /etc/ssl/private/novnc_key.pem ]
then
  openssl req -new -x509 -days 365 -nodes \
    -subj "/C=US/ST=IL/L=Springfield/O=OpenSource/CN=localhost" \
    -out /etc/ssl/certs/novnc_cert.pem -keyout /etc/ssl/private/novnc_key.pem \
    > /dev/null 2>&1
fi

cat /etc/ssl/certs/novnc_cert.pem /etc/ssl/private/novnc_key.pem > /etc/ssl/private/novnc_combined.pem
chmod 600 /etc/ssl/private/novnc_combined.pem

/usr/share/novnc/utils/launch.sh --listen $NOVNCPORT --vnc localhost:$VNCPORT \
  --cert /etc/ssl/private/novnc_combined.pem --ssl-only \
  > /var/log/novnc.log 2>&1 &

# Start shell

/bin/bash
