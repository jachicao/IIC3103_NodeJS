var http = require('http');
var createHandler = require('github-webhook-handler');
var handler = createHandler({ path: '/webhook', secret: process.env.WEBHOOK_SECRET });
var exec = require('child_process').exec;

exec('sh startup.sh', function(error, stdout, stderr) {
  console.log(`stdout: ${stdout}`);
  console.log(`stderr: ${stderr}`);
});

http.createServer(function (req, res) {
  handler(req, res, function (err) {
    res.statusCode = 404;
    res.end('no such location');
  })
}).listen(6783);

handler.on('*', function (event) {
  console.log(event);
});

handler.on('push', function (event) {
  console.log('Received a push event for %s to %s',
    event.payload.repository.name,
    event.payload.ref);
  if (event.payload.ref == 'refs/heads/master') {
    exec('sh /home/administrator/master/master-deploy.sh', function(error, stdout, stderr) {
      console.log(`stdout: ${stdout}`);
      console.log(`stderr: ${stderr}`);
    });
  }
  else if (event.payload.ref == 'refs/heads/develop') {
    exec('sh /home/administrator/develop/develop-deploy.sh', function(error, stdout, stderr) {
      console.log(`stdout: ${stdout}`);
      console.log(`stderr: ${stderr}`);
    });
  }
});
