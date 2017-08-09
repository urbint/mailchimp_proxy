# MailchimpProxy

A proxy for adding members to a MailChimp list.

## TLDR

Exposes a `/subscribers` endpoint that you can `POST` to with a body like `{"email": "newsubscriber@yourwebsite.io"}`.

## Exposed Env Vars

MailChimp data can be set via environmental varables:

| Key                   | Description                                     |
| --------------------- | ----------------------------------------------- |
| ALLOWED_ORIGINS       | Origins allowed to make requests of the proxy.  |
| MAILCHIMP_API_TOKEN   | Your MailChimp API Token.                       |
| MAILCHIMP_DATA_CENTER | Your MailChimp Data Center.                     |
| MAILCHIMP_LIST_ID     | The MailChimp list to subscribe new emails to.  |


