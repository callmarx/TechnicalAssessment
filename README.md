# Quake 3 Arena Log Parser

This project is a technical assessment for a Senior Software Engineer position on
[CloudWalk](https://cloudwalk.io/). The test statement can be found [here](./technical-test.mb).

## Technical Info

This projet use this tools:
- Docker
- Ruby 3.2.2
- Rails 7.0.8
- PostgreSQL 16
- Redis 7
- MinIO server
- MinIO mc client

## A little explaining
Creating a CRUD API that receives a file via POST initially seemed boring to me.
Instead, I opted for a more realistic approach by setting up a Bucket with a
webhook event trigger, which notifies my Ruby on Rails app whenever a new file
is uploaded. I'm assuming a scenario where this bucket belongs to Quake 3 Arena
environment and isn't "anyone" that can send this file via POST, only tools
that usually are available on bucket systems like this event trigger.

The Rails application processes the information received from the webhook to
generate the URL from which the file can be downloaded. It then proceeds to parse
the file and store the data accordingly.

## Executing on your machine

All project is dockerized, so you only need docker compose installed. 
After setting up with `docker compose up` you can access the application
on [localhost:3000](http://localhost:3000)

#### Docker Compose commands

Prepare docker images and containers:
```sh
docker compose build
```

Run all services:
```sh
docker compose up
```

with that you should also have a MinIO server up with a preconfigured
bucket named `minio/quake3logs` with `public` access policy and a
webhook trigger event for any upload event on this bucket that calls
[/uploaded-event](http://localhost:3000/uploaded-event) endpoint


##### Other commands
Rails console (it needs the `postgres` and `redis` services running):
```sh
docker compose exec api bin/rails c
```

Run tests (it needs the `api` service running):
```sh
docker compose exec api bin/rspec
```

Watch jobs queue (with sidekiq) log:
```sh
tail -f log/sidekiq.log
```

## Testing

This project has 100% test coverage. You can check this by
running `docker compose exec api bin/rspec` and then accessing
[coverage/index.html](./coverage/index.html)

The endpoints for *"grouped information for each match"* and *"deaths grouped
by death cause for each match"* required by the <./technical-test.mb> are
respectively `/games/grouped_information` and `/games/deaths_grouped_by_cause`
rendered as json. You can test them with tools like Postman or Insomnia. A simple
curl for these is:
```sh
curl -X GET http://localhost:3000/games/grouped_information
curl -X GET http://localhost:3000/games/deaths_grouped_by_cause
```
### Testing the upload on the bucket

##### Testing with MinIOWeb
With everything up, you can manually enter on the bucket with MinIOWeb. Access
[localhost:9090](http://localhost:9090) with credentials `admin` and `12345678`
and go to [localhost:9090/browser/quake3logs](http://localhost:9090/browser/quake3logs)
and upload some example log available on [spec/fixtures/](./spec/fixtures/). You can do
a `tail -f log/sidekiq.log` before to see some logging of [LogProcessJob](./app/sidekiq/log_process_job.rb). 

##### Testing with minio/mc 
You can generate an upload url with the following:
```sh
mc share upload --recursive minio/quake3logs
````

With this command you should get something like:
```
URL: http://localhost:9000/quake3logs
Expire: 7 days 0 hours 0 minutes 0 seconds
Share: curl http://localhost:9000/quake3logs/ \ 
-F policy=eyJleHBpcmF0aW9uIjoiMjAyNC0wNC0yM1QwMTo0NzoyNy4wMDVaIiwiY29uZGl0aW9ucyI6W1siZXEiLCIkYnVja2V0IiwicXVha2UzbG9ncyJdLFsic3RhcnRzLXdpdGgiLCIka2V5IiwiIl0sWyJlcSIsIiR4LWFtei1kYXRlIiwiMjAyNDA0MTZUMDE0NzI3WiJdLFsiZXEiLCIkeC1hbXotYWxnb3JpdGhtIiwiQVdTNC1ITUFDLVNIQTI1NiJdLFsiZXEiLCIkeC1hbXotY3JlZGVudGlhbCIsImFkbWluLzIwMjQwNDE2L3VzLWVhc3QtMS9zMy9hd3M0X3JlcXVlc3QiXV19 \
-F x-amz-algorithm=AWS4-HMAC-SHA256 \
-F x-amz-credential=admin/20240416/us-east-1/s3/aws4_request \
-F x-amz-date=20240416T014727Z \
-F x-amz-signature=d2e0f0a546e1d238150dd01bbf65f08fe3eacbf5d96907a419b17da5c5bdec41 \
-F bucket=quake3logs \
-F key=<NAME> \
-F file=@<FILE>
```
Just replace the `<NAME>` and `<FILE>` with the name that it'll be saved
on the bucket and the filepath in your machine that you want to upload.
On [spec/fixtures/](./spec/fixtures/) you can find some log examples.

With the example before and using `./spec/fixtures/double-clean-games.log` it should be:
```sh
curl http://localhost:9000/quake3logs/ \ 
-F policy=eyJleHBpcmF0aW9uIjoiMjAyNC0wNC0yM1QwMTo0NzoyNy4wMDVaIiwiY29uZGl0aW9ucyI6W1siZXEiLCIkYnVja2V0IiwicXVha2UzbG9ncyJdLFsic3RhcnRzLXdpdGgiLCIka2V5IiwiIl0sWyJlcSIsIiR4LWFtei1kYXRlIiwiMjAyNDA0MTZUMDE0NzI3WiJdLFsiZXEiLCIkeC1hbXotYWxnb3JpdGhtIiwiQVdTNC1ITUFDLVNIQTI1NiJdLFsiZXEiLCIkeC1hbXotY3JlZGVudGlhbCIsImFkbWluLzIwMjQwNDE2L3VzLWVhc3QtMS9zMy9hd3M0X3JlcXVlc3QiXV19 \
-F x-amz-algorithm=AWS4-HMAC-SHA256 \
-F x-amz-credential=admin/20240416/us-east-1/s3/aws4_request \
-F x-amz-date=20240416T014727Z \
-F x-amz-signature=d2e0f0a546e1d238150dd01bbf65f08fe3eacbf5d96907a419b17da5c5bdec41 \
-F bucket=quake3logs \
-F key=double-clean-games.log \
-F file=@./spec/fixtures/double-clean-games.log
```
