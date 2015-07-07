var express      = require('express'),
    app          = express(),
    http         = require('http').Server(app),
    io           = require('socket.io')(http),
    bodyParser   = require('body-parser')

app.use(bodyParser.json());

// Setting application port number
app.set('port', '4000');

app.use('/public', express.static(__dirname + '/public'))

// GET /
app.get('/',function(req, res, next) {
    res.sendFile(__dirname + '/public/index.html')
});

io.on('connection', function(socket){
    console.log('a user connected')

    socket.on('disconnect', function(){
        console.log('user disconnected')
    })

    socket.on('ios-like-photo', function(msg) {
        console.log('Event: ios-like-photo')
        io.emit('web-like-photo-notification', msg)
    })

    socket.on('web-like-photo', function(msg) {
        console.log('Event: web-like-photo')
        io.emit('ios-like-photo-notification', msg)
    })

    socket.on('canvas-began-location', function(location) {
        console.log("Began: " + JSON.stringify(location))
        io.emit('canvas-began-location', location)
    })

    socket.on('canvas-changed-location', function(location) {
        console.log("Changed: " + JSON.stringify(location))
        io.emit('canvas-changed-location', location)
    })

    socket.on('canvas-ended-location', function(location) {
        console.log("Ended: " + JSON.stringify(location))
        io.emit('canvas-ended-location', location)
    })
})

http.listen(app.get('port'), function() {
    var status = 'Trace API is listening on port ' + app.get('port') +
                 ' in ' + app.settings.env + ' mode.'
    console.log(status)
})