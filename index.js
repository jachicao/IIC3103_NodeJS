var http = require('http');
var createHandler = require('github-webhook-handler');
var handler = createHandler({ path: '/webhook', secret: process.env.WEBHOOK_SECRET });
var exec = require('child_process').exec;

var runSh = function(str){
  exec(str, function(error, stdout, stderr) {
    console.log(`stdout: ${stdout}`);
    console.log(`stderr: ${stderr}`);
  });
}

var runStartup = function() {
  runSh('sh startup.sh');
}

var runMasterDeploy = function() {
  runSh('sh /home/administrator/master/master-deploy.sh');
}

var runDevelopDeploy = function() {
  runSh('sh /home/administrator/develop/develop-deploy.sh')
}

runStartup();
runMasterDeploy();
runDevelopDeploy();

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
    runMasterDeploy();
  }
  else if (event.payload.ref == 'refs/heads/develop') {
    runDevelopDeploy();
  }
});
