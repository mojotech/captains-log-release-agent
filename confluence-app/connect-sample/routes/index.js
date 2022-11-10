export default function routes(app, addon) {
    // Redirect root path to /atlassian-connect.json,
    // which will be served by atlassian-connect-express.
    app.get('/', (req, res) => {
        res.redirect('/atlassian-connect.json');
    });

    // This is an example route used by "generalPages" module (see atlassian-connect.json).
    // Verify that the incoming request is authenticated with Atlassian Connect.
    // app.get('/hello-world', addon.authenticate(), (req, res) => {
    //     // Rendering a template is easy; the render method takes two params: the name of the component or template file, and its props.
    //     // Handlebars and jsx are both supported, but please note that jsx changes require `npm run watch-jsx` in order to be picked up by the server.
    //     res.render(
    //       'hello-world.hbs', // change this to 'hello-world.jsx' to use the Atlaskit & React version
    //       {
    //         title: 'Atlassian Connect'
    //         //, issueId: req.query['issueId']
    //         //, browserOnly: true // you can set this to disable server-side rendering for react views
    //       }
    //     );
    // });

  app.post('/create-page',  (req, res) => {
    // const confluence = require("./../lib/confluence")();
    const clientKey = req.context.clientKey;
    const httpClient = addon.httpClient({
      clientKey: clientKey
    })
    console.log(addon.app.post)
    // console.log(addon.httpClient())
    // console.log(confluence)
    // console.log(addon.hostClient(req))
    const { type, title, space, body } = req.body;
    const page = {
      type,
      title,
      space,
      body
    };
    console.log(page)
    // addon.reqOrOpts('POST', '/wiki/rest/api/content', page)
    console.log(client)
    httpClient.post(
      "/confluence/rest/api/content/",
      function (err, response, contents) {
        if (err || (response.statusCode < 200 || response.statusCode > 299)) {
          console.log(err);
        }
        contents = JSON.parse(contents);
        console.log(contents);
      }

    );
  });
  app.post('/edit-page', addon.authenticate(), (req, res) => {
    const { title, spaceKey, body, id } = req.body;
    const page = {
      type: 'page',
      title,
      space: {
        key: spaceKey
      },
      body: {
        storage: {
          value: body,
          representation: 'storage'
        }
      }
    };
    addon.post('POST', `/wiki/rest/api/content/${id}`, page)
      .then((response) => {
        res.json(response);
      })
      .catch((error) => {
        res.status(500).json(error);
      });
  });
}
