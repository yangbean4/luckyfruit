
var http = require("http");

http.createServer(function (req, res) {
  var fileName = "." + req.url;
  console.log(fileName);
  if (fileName === "./") {
    console.log("Responding to request with events")
    res.writeHead(200, {
      "Content-Type": "text/event-stream",
      "Connection": "keep-alive",
      "Access-Control-Allow-Origin": '*',
      "Access-Control-Allow-Headers": '*'
    });
    res.write("retry: 10000\n");
    res.write("event: connecttime\n");
    res.write("data: " + (new Date()) + "\n\n");
    res.write("data: " + (new Date()) + "\n\n");

    interval = setInterval(function () {
      console.log("Sending event..")
      res.write("data: " + (new Date()) + "\n\n");
    }, 1000);

    req.connection.addListener("close", function () {
      clearInterval(interval);
    }, false);
  }
}).listen(8080);