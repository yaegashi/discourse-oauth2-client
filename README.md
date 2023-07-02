# discourse-oauth2-client

## Introduction

This plugin enables the OAuth2 client capability for Discourse.
It allows Onebox to fetch content from private websites like ones hosted by Azure App Service with authentication (Easy Auth).

## Development in Discourse devcontainer

1. Launch a devcontainer of https://github.com/discourse/discourse

2. Clone in the plugins folder:

        git -C plugins clone https://github.com/yaegashi/discourse-oauth2-client

3. Run the following in the first terminal:

        ./bin/ember-cli -u

4. Run the following in the second terminal:

        EXCON_DEBUG=1 bundle exec rails s

5. Run the following in the third terminal:

        EXCON_DEBUG=1 bundle exec sidekiq

6. Create an admin account in the fourth terminal ([doc](https://meta.discourse.org/t/create-an-admin-account-from-the-console/17274)):

        bundle exec rake admin:create

7. Open https://localhost:4200 and log in as the admin account.

8. Find discourse-oauth2-client settings in http://localhost:4200/admin/plugins.