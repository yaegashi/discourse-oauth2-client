# discourse-private

## Introduction

Enable Discourse Onebox access to private web sites protected by Azure App Service (Easy Auth).

## Development

1. Launch a codespace from https://github.com/discourse/discourse
2. Clone this repository in the plugins folder:

        git -C plugins clone https://github.com/yaegashi/discourse-private

3. Copy [env.sh](env.sh) and modify it:

        cp plugins/discourse-private/env.sh .
        vi env.sh

4. Run the following in the first terminal:

        ./bin/ember-cli -u

5. Run the following in the second terminal:

        . env.sh
        bundle exec rails s

6. Run the following in the third terminal:

        . env.sh
        bundle exec sidekiq

7. Open https://localhost:4200 with the web browser
