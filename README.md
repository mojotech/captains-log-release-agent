# ReleaseNotesBot

## Usage
These are the unofficially official docs of the ***Captain's Log***

This project is currently under development.
 - Bug reports and feature inquiries are in Slack channel: `#mojotime-release-notes`
 - If you are not in that Slack channel, you may direct message `@zachbob` or `@Sara Davila`

The Captain's log can only be used inside of its home Mojotech organization where it is installed.
You are more than welcome to attempt to use it outside of the Mojotech organization. If you require it's use outside of the Mojo Organization, you may request it from `@zachbob`.

You may use any of the Captain's Log commands anywhere inside of the Mojotech Organization. If you are using a private channel, you must go into the `channel integrations` and `add an app` called: `Captains Log`.

### Quick Start
NOTE: If you are a visual learner, then [this video tutorial](https://drive.google.com/file/d/1MbDeYRkuqv6KYRNZczgikMwOvgryeeLP/view?usp=sharing) is for you! Please beware: when installing the app, please do not install the dev version. Also, when using the commands, be sure to use `/captainslog` and not `/captainslogdev`.

1. Okay, make sure that if you're in a private channel, `Captains Log` is installed as an app.
2. Now, we need to make sure that you are in the chat of the channel where you want `Captains Log` to be configured in. Lets check to see if anyone on your team has already configured `/captainslog` for your current client and channel.
- Upon entering `/captainslog`, you should see a modal that says `Select Client for channel: <Your Channel name>`.
  - If the modal that pops up does not say this, then that means you already have a client configured for your channel. You should probably checkin with others on your team to see how far they have made it through this setup process.
  - If you do not see your client in this list, then click `x` on the top right of the modal. It is very important that you do not select anything that is not your client.
- If you see your client, go ahead and select it and click on the green `Submit` button.
- Else, lets create your client right now:
  - Execute the command: `/captainslog new client`.
  - Enter in the name of your client and click `Submit`.
  - Now, go ahead and re-execute `/captainslog`, select your client, and click `Submit`.
3. Lets create a new project:
- First, we need the URL for your github or gitlab repository.
  - This can be found from copying the URL from the root of your repository's main/master branch.
- Go back to your slack channel from the previous step and execute the command: `/captainslog new project`.
  - This should prompt you with a modal with 3 input fields.
    - For the first field, select your client.
    - For the second field, enter the name of your project.
    - For the last field, paste in that URL that you have copied in the previous step. It is very important that the url starts with https and do not contain any query parameters.
    - Go ahead and submit that.
  - You should receive a message in your channel saying that new project has been added!
  - You may repeat this step for however many projects need to be added.
  - All releases will be handled the same for all projects under a client.
4. Lets go ahead and configure webhooks for your repository:
- In github, you're going to need to be a repository admin. If you are not an admin, have an admin complete this step.
- From your repository, navigate to `Settings > Webhooks > Add webhook`.
  - From here, enter in this endpoint for `Payload URL`: `https://captains-log-dev.fly.dev/webhook`.
  - For Content type, leave the default selection of `application/x-www-form-urlencoded`.
  - There is no need to enter in any value for `Secret`.
  - Then, click `Let me select individual events.`
  - Scroll down, unselect `Pushes` and select `Releases`.
  - Then. scroll down and click the `Add webhook` button.
- If there are multiple projects with different repositories, then this step (the entirety of step 4) will need to be applied to each repository.
5. That's it! Your Slack channel should get release notifications as soon as they are released in github. If this is not the case, you may reach out to `@zachbob` on Slack for some assistance.
6. Once your repository is configured, all release notes and release events are posted in this [Confluence Directory](https://mojotech.atlassian.net/wiki/spaces/PM/pages/29458448/The+Captain).
7. If you wish to manually create release notes, this can be done by entering this `/captainslog` command and filling out the modal form.
  - You will be prompted to select a project.
  - Enter the name of the update in `Release Name`.
  - Enter notes about the `Release Name`.
  - If you would like to notify the message you've entered to Slack Channel, select the checkbox.
  - Everything captured in the modal will persist to the same directory in this same [Confluence Directory](https://mojotech.atlassian.net/wiki/spaces/PM/pages/29458448/The+Captain).

All commands:
 - `/captainslog` - First used to bind a slack channel to a client. On next uses, is used for manually entering release notes.
 - `/captainslog new client` - Command to create a new client.
 - `/captainslog new project` - Select a client and create a new project.

## Getting a dev instance running:

1. Configure [direv](https://direnv.net/). Then copy `.sample.envrc` to a new `.envrc`. Don't forget to run `direnv allow` after any changes to `.envrc`.

2. Install [docker](https://www.docker.com/get-started/) onto your machine, if you do not have it. Execute `docker-compose up -d` in the root of the repo. This starts the database. NOTE: If you've never run this command before, this will build a new image of the postgres database.

3. Install the tool versions necessary for this repo. If you are using [asdf](https://asdf-vm.com/), run these commands to install everything in the `.tool-versions` file:
  * `asdf plugin add elixir`
  * `asdf install`

4. Start the Phoenix server:

  * Install elixir dependencies then create and migrate your database with the command: `mix setup`. NOTE: You may be prompted to install `rebar3`. If so, install it.
  * Start Phoenix endpoint with `mix phx.server`.

5. Download and install [ngrok](https://ngrok.com/download) onto your machine if you do not have it. Execute ngrok with the `PORT` that is configured as an enviornment variable: `ngrok http <PORT>`. This starts the ngrok reverse proxy so that way we can get the slack bot working over the web. Depending on how you've installed ngrok, you may have to navigate to the directory on your machine where `ngrok` resides and execute it with a prepended `./`.

6. Open up your [Slack app dev dashboard](https://api.slack.com). For `Captains Log Dev`, [this is the current one](https://api.slack.com/apps/A03L6Q2B6G1). If you do not know what this is, you should ask a teammate to add you to it or create a new slack app yourself. NOTE: reach out to the `#mojotime-release-notes` Slack channel to coordinate development since only one ngrok connection can be live at a time.

  * Under `Features` on the left, Navigate to `Slash Commands`.
  * Edit the command the command `/captainslogdev`.
  * Inside the box for `Request URL`, paste your ngrok URL and append `/captainslog/modal`.
  * Click save. You should get redirected back to the home page for the app.
  * Under `Features` on the left, Navigate to `Interactivity & Shortcuts`.
  * Inside the box for `Request URL`, paste your ngrok URL and append `/captainslog/interaction`.
  * Click `Save Changes`.

7. Test to see if everything worked - go into slack and enter the command: `/captainslogdev`

8. Checkout the database! Run these commands in the root of the repo:
  * `docker-compose exec db psql -U postgres -d release_notes`
  * `\dt`
  * `select * from projects;`


## Troubleshooting

Some common errors:

1. Failure to execute `/captainslogdev`
  This usually means one or two things of the following:
  a. mix phx.server is not running or had an error
    - Make sure `mix phx.server` runs successfully
  b. ngrok is not properly configured with the dashboards
    - Make sure ngrok is running on the same port as the phoenix server.
    - Make sure your alack app dashboards are configured to your ngrok urls.

2. Anything asdf related can be a headache so just reach out to `#mojotime-release-notes`


## fly.io

This app is deployed on [fly.io](https://fly.io/)

Ask a teammate about getting access to the Mojotech fly.io account.

Install flyctl [here](https://fly.io/docs/getting-started/installing-flyctl/)

Follow this guide to [sign into flyctl](https://fly.io/docs/getting-started/log-in-to-fly/)

See this guide on [how to deploy to fly.io](https://fly.io/docs/getting-started/elixir/#deploying-again)

Input enviornment variables into `config/runtime.exs` to use on fly.io

Update enviornment variable values with: `flyctl secrets set ENV_NAME=value`

## [System Architecture](https://github.com/mojotech/captains-log-release-agent/tree/main/docs)

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
