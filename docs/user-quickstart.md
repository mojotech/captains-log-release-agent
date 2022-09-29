# Quick Start
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
  - This should prompt you with a modal with 4 input fields.
    - For the first field, select your client.
    - For the second field, enter the name of your project.
    - For the third field, paste in that URL that you have copied in the previous step. It is very important that the url starts with https and do not contain any query parameters.
    - The last field is optional, it is requesting where you would like the release note to be persisted to. Right now only Mojotech's Confluence works, but the release note can be persisted to anywhere in there. To specify a place, you need to paste in the full url of direct parent folder/note that you would like all release notes to be persisted under. If you do not specify a persistence url, all notes will be persisted [to this Confluence page](https://mojotech.atlassian.net/wiki/spaces/PM/pages/29458448/The+Captain) by default.
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
