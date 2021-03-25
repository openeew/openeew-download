const http = require('http');
const express = require('express');

const app = express();
app.use(express.static('firmware'));
app.get('/', function(req, res) {
  return res.end('<p>Download OpenEEW firmware binaries</p>');
});

const server = http.createServer(app);

server.listen(process.env.SERVER_PORT);
