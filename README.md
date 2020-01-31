# gratibot

gratibot is a chat bot built on the [Hubot][hubot] framework. This is rewrite of
the old [Gratibot](https://github.com/liatrio/gratibot) with the focus of
providing support for the Mattermost platform. 

## Local Development

### Setup Mattermost
1. `docker run -d --publish 8065:8065 --add-host dockerhost:127.0.0.1 mattermost/mattermost-preview`
2. Login and create a user for your bot
3. Navigate to **System Console** -> **Integration Management**
  - Select _Enable Personal Access Tokens_ 
4. **System Console** -> **Users** -> BOTUSER -> **Manage Roles**
  - Select _Allow this account to generate personal access tokens._
5. Logout and login as your bot account
  - **Account Settings** -> **Security** -> Create new token
    - Make sure to save this!!!!
6. I'd reccommend using ngrok to proxy your local instance
  - `ngrok http 8065`
  - The URL would become your new MATTERMOST_HOST value

### Bot setup
- Set several critcal environment variables on your system
  - MATTERMOST_USE_TLS=false
  - MATTERMOST_HOST
  - MATTERMOST_GROUP
  - MATTERMOST_ACCESS_TOKEN

#### Using node

1. Run `npm install`
3. Run `./bin/hubot --adapter matteruser`
  - Assuming all the steps were followed correctly you should be able to interact with Gratibot. Try using `@gratibot help`

### Using Docker

1. Run `docker-compose up`
2. Reap benefits
