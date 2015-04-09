var sys = require("sys"),
   http = require("http");
http.createServer(function (request, response) {
  response.writeHead(200, {"Content-Type": "text/plain"});
  response.end("Hello Worldn");
}).listen(8000);
sys.puts("Server running at Port 8000");