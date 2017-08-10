# MailchimpProxy

A proxy for adding members to a MailChimp list.

## TLDR

Exposes a `/subscribers` endpoint that you can `POST` to with a body like `{"email": "newsubscriber@yourwebsite.io"}`.

This proxy is available as a [standalone docker image](https://hub.docker.com/r/urbint/mailchimp_proxy/).

## Exposed Env Vars

MailChimp data can be set via environmental varables:

| Key                   | Description                                     |
| --------------------- | ----------------------------------------------- |
| ALLOWED_ORIGINS       | Comma-separated origins allowed.  |
| MAILCHIMP_API_TOKEN   | Your MailChimp API Token.                       |
| MAILCHIMP_DATA_CENTER | Your MailChimp Data Center.                     |
| MAILCHIMP_LIST_ID     | The MailChimp list to subscribe new emails to.  |
