# README

# Docker Compose commands

Run all services:
```sh
docker compose up
```

Rails console (it needs at least the `db` service running):
```sh
docker compose exec api bin/rails c
```

Run tests (it needs at least the `db` service running):
```sh
docker compose exec api bin/rspec c
```

```
mcli share upload --recursive minio/quake3logs
URL: http://localhost:9000/quake3logs
Expire: 7 days 0 hours 0 minutes 0 seconds
Share: curl http://localhost:9000/quake3logs/ -F policy=eyJleHBpcmF0aW9uIjoiMjAyNC0wNC0yM1QwMTo0NzoyNy4wMDVaIiwiY29uZGl0aW9ucyI6W1siZXEiLCIkYnVja2V0IiwicXVha2UzbG9ncyJdLFsic3RhcnRzLXdpdGgiLCIka2V5IiwiIl0sWyJlcSIsIiR4LWFtei1kYXRlIiwiMjAyNDA0MTZUMDE0NzI3WiJdLFsiZXEiLCIkeC1hbXotYWxnb3JpdGhtIiwiQVdTNC1ITUFDLVNIQTI1NiJdLFsiZXEiLCIkeC1hbXotY3JlZGVudGlhbCIsImFkbWluLzIwMjQwNDE2L3VzLWVhc3QtMS9zMy9hd3M0X3JlcXVlc3QiXV19 -F x-amz-algorithm=AWS4-HMAC-SHA256 -F x-amz-credential=admin/20240416/us-east-1/s3/aws4_request -F x-amz-date=20240416T014727Z -F x-amz-signature=d2e0f0a546e1d238150dd01bbf65f08fe3eacbf5d96907a419b17da5c5bdec41 -F bucket=quake3logs -F key=<NAME> -F file=@<FILE>
```

## Things to think:
 - use mongodb as database
     ⇒ It will be only a one model with a lot of write considering big logs file
     ⇒ recreate rails with:
        --api
        --skip-bundle
        --skip-active-record
        --skip-action-mailer
        --skip-action-mailbox
        --skip-active-storage
        --skip-active-job
        --skip-action-cable
        --skip-test
        --skip-system-test  
 - sidekiq for async job for read file and save parsed data
 - S3 aws has a callback that I can setup to trigger a endpoint to my app to notify a new object created
     ⇒  this callback can send the url of the new file
 - size of log file in the bucket storage
 - keep the last point read to prevent lose of data parsed (retry condition)
