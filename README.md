# gratibot

gratibot is a chat bot built on the [Hubot][hubot] framework. This is rewrite of
the old [Gratibot](https://github.com/liatrio/gratibot) with the focus of
providing support for the Mattermost platform. 

## Local Development

### Using node

1. Clone this repository
2. Run `npm install`
3. Set several critcal environment variables
  - MATTERMOST_USE_TLS=false
  - MATTERMOST_HOST
  - MATTERMOST_GROUP
  - MATTERMOST_ACCESS_TOKEN
4. Stand up a local Mattermost instance
  - `docker run -d --publish 8065:8065 --add-host dockerhost:127.0.0.1 mattermost/matterm
ost-preview`
  - Login and create a user for your bot
  - Navigate to **System Console** -> **Integration Management**
    - Select _Enable Personal Access Tokens_ 
  - **System Console** -> **Users** -> <botuser> -> **Manage Roles**
    - Select _Allow this account to generate personal access tokens._
  - Logout and login as your bot account
	  - **Account Settings** -> **Security** -> Create new token
			- Make sure to save this!!!!
5. Run `./bin/hubot --adapter matteruser`
  - Assuming all the steps were followed correctly you should be able to interact with Gratibot. Try using `@gratibot help`
