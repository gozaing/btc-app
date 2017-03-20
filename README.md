# Trade BitCoin on Bitflyer

* BitCoin トレード Ver 0.1.0

## Require
* BitFlyer API key / password
* Heroku Account
* SendGrid Account

## Set Environment
* Local
```
export BITFLYER_API_KEY="xxxx"
export BITFLYER_API_TOKEN="xxxx"
export BITFLYER_API_URI="xxxx"
export DATABASE_NAME="xxxx"
export DATABASE_USER_NAME="xxxx'"
export DATABASE_USER_PASSWORD="xxxx'"
export SENDGRID_USERNAME="xxxx"
export SENDGRID_PASSWORD="xxxx"
export MAIL_FROM="xxxx"
export MAIL_TO="xxxx";
```

* Heroku
```
heroku config:set BITFLYER_API_KEY="xxxx"
heroku config:set BITFLYER_API_TOKEN="xxxx"
heroku config:set BITFLYER_API_URI="xxxx"
heroku config:set DATABASE_NAME="xxxx"
heroku config:set DATABASE_USER_NAME="xxxx"
heroku config:set DATABASE_USER_PASSWORD="xxxx"
heroku config:set SENDGRID_USERNAME="xxxx"
heroku config:set SENDGRID_PASSWORD="xxxx"
heroku config:set MAIL_FROM="xxxx"
heroku config:set MAIL_TO="xxxx"
```
