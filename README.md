# ReleaseNotesBot

## Usage
These are the unofficially official docs of the ***Captain's Log***

This project is currently under heavy development.
 - Bug reports and feature inquiries are in Slack channel: `#mojotime-release-notes`
 - If you are not in that Slack channel, you may direct message `@zachbob` or `@Sara Davila`

The Captain's log can only be used inside of its home Mojotech organization where it is installed.
You are more than welcome to attempt to use it outside of the Mojotech organization.

You may use any of the Captain's Log commands anywhere inside of the Mojotech Organization.
The main command is `/captainslog`. Upon entering this:
  1. You will be prompted with a modal to select a client. Click Submit.
  - NOTE: If nothing happens after you enter the command, this is a known bug. Just keep trying.
  2. You will be prompted to select a project.
  - Enter the name of the update in `Release Name`.
  - Enter notes about the `Release Name`.
  - If you would like to notify the message you've entered to Slack Channel, select the checkbox.
  - NOTE: This currently only works for one Slack Channel - can be swapped easily upon inquiry.

Other Commands:
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
  * Inside the box for `Request URL`, paste your ngrok URL and append `/captainslog/modal`.
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

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
