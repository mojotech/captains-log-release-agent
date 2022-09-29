# Getting a dev instance running

1. Copy `.env.sample` to a `.env`

2. Install [docker](https://www.docker.com/get-started/) onto your machine, if you do not have it.

3. Build dependencies `docker compose run app mix deps.get`

4. Create and migrate your database with the command: `docker compose run app mix ecto.migrate `.

5. Execute `docker-compose up` in the root of the repo. This starts the database and phoenix servers.

6. Download and install [ngrok](https://ngrok.com/download) onto your machine if you do not have it. Execute ngrok with the `PORT` that is configured as an enviornment variable: `ngrok http <PORT>`. This starts the ngrok reverse proxy so that way we can get the slack bot working over the web. Depending on how you've installed ngrok, you may have to navigate to the directory on your machine where `ngrok` resides and execute it with a prepended `./`.

7. Open up your [Slack app dev dashboard](https://api.slack.com). For `Captains Log Dev`, [this is the current one](https://api.slack.com/apps/A03L6Q2B6G1). If you do not know what this is, you should ask a teammate to add you to it or create a new slack app yourself. NOTE: reach out to the `#mojotime-release-notes` Slack channel to coordinate development since only one ngrok connection can be live at a time.

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

**NOTE**: Before deploying, you need to
1. change the name of the `.toml` file based on what env you are deploying to.
  ex. `cp fly.toml.staging fly.toml`
1. Choose the right app to deploy to. See all apps with: `flyctl apps list`
1. use the -a flag to specify the target app name

Input enviornment variables into `config/runtime.exs` to use on fly.io

Update enviornment variable values with: `flyctl secrets set ENV_NAME=value`

Remove enviornment variable values with: `flyctl secrets unset ENV_NAME=value`
