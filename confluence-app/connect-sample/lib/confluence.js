var Q = require("q");

function Pages(http) {
  this.http = http;
}

var proto = Pages.prototype;

proto.getContent = function (pageId) {
  return invoke(this.http, "get", {
    uri: "/confluence/rest/api/content/" + pageId
  });
};

proto.updateContent = function (pageId, content) {
  return invoke(this.http, "put", {
    uri: "/rest/prototype/1/content/" + pageId + ".json",
    body: content
  });
};

proto.createContent = function (content) {
  return invoke(this.http, "post", {
    uri: "/wiki/rest/api/content/",
    body: content
  });
};

proto.deleteContent = function (pageId) {
  return invoke(this.http, "del", {
    uri: "/rest/prototype/1/content/" + pageId + ".json"
  });
};

function invoke(http, method, options) {
  options.json = true;
  var dfd = Q.defer();
  http[method](options, function (err, response) {
    var code = response && response.statusCode;
    console.log(`res code: ${code}`)
    console.log(response)
    if (err) {
      console.log("We have an error")
      dfd.reject(err);
    }
    else if (code < 200 || code >= 300) {
      var msg = "Unexpected response: " + response.statusCode;
      var ex = new Error(msg);
      ex.detail = response.body;
      dfd.reject(ex);
    }
    else {
      dfd.resolve(response.body, response);
    }
  });
  return dfd.promise;
}

module.exports = function (http) {
  return new Pages(http);
};
