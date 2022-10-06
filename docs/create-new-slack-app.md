# Creating a new Captain's Log Slack App

As new 'apps' of the Captain's Log are deployed, there may be a need to create a new Slack App to go along with it. It is also handy to have a slack app if you are developing for the Captain's Log. The following docs outline the process for setting up a new Captain's Log Slack App.

1. Head on over [the Slack app dashboard](https://api.slack.com/apps?new_app=1) to start creating a new Slack app.
1. Select `From an app manifest`.
1. Sign into your desired workspace and select where you would like this Slack app to be installed. For development purposes, it is probably best to create a new workspace.
1. Paste in the manifest configuration in from our [version-controlled manifest](/assets/slack-app-manifest.json).
1. Glance over the configuration and change each appropriate field. Some fields that need a rename for your new app are: `display_information.name`, `features.bot_user.display_name`, `features.slash_commands`, and `settings.interactivity`. If you do not know the target url at this point in time, it is okay becuase they can easily be changed later. Please be verbose with the app name, bot display name, and command name, as the generic `Captains Log` and variants are reserved for our production deployment.
1. Verify everything is correct and create the app.
1. Next, install your new app onto the workspace. There should be an on-screen prompt to guide you through this.
1. After you have installed your app, on the left sidebar click on `OAuth & Permissions`.
1. Copy the `Bot User OAuth Token`. In your `.env` file, you can set the value of `SLACK_BOT_TOKEN` to this. The allows your instance of Captain's Log to send messages as this app's Slack Bot.
1. Once you know your instance of the Captains Log's url, you can configure that in the slack app by clicking on the left sidebar: `Interactivity & Shortcuts`. Then configure the `Request URL` appropriately. You must also configure the `Slash Commands` on the left sidebar. Edit your existing command appropriately as well.
