# README


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
