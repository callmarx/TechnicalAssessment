#!/bin/bash
set -e

echo "Setup for MinIO..."

mc config host add minio http://minio:9000 admin 12345678;

if ! mc ls minio/quake3logs; then
  mc mb minio/quake3logs || true;
fi;

if ! mc policy list minio/quake3logs | grep -q public; then
  mc anonymous set public minio/quake3logs;
fi;

if ! mc admin webhook list minio/quake3logs | grep -q uploaded-event; then
  mc admin webhook add minio/quake3logs uploaded-event http://api:3000/uploaded-event NzBvhwtjrWOPd1intx2pV4x4O%w7V!SDS%xHtJK8xwVEEYOivg 100;
fi;

exit 0;
