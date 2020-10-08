#!/bin/sh
day=`date +%Y%m%d`

HOST=10.138.21.76
USR=root
PASSWORD=Adm1Cmv4$
echo "Starting to sftp..."
lftp -u ${USR},${PASSWORD} sftp://${HOST}:22 <<EOF
cd /usr/cti/apps/compas/homedir/compas
mput Batch_D_OperationWithFailed_${day}.txt
bye
EOF

echo "Done"
