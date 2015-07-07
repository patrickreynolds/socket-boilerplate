socket-boilerplate
==================

Socket boilerplate, as the name implies, is a boilerplate setup of a full stack web and iOS application with bi-directional event set up via WebSockets using Socket.io

![Gif Demo](https://github.com/patrickreynolds/socket-boilerplate/raw/master/screenshots/socket-boilerplate-gif.gif)

## To Run
1. Download the whole repo (web and iOS app)
2. Navigate to the /web folder and run `npm restart` to start the node server
3. Run the iOS app in a simulator (The simulator is required because the application is running on localhost)
4. You may or may not have to wait a few seconds for the iOS application to connect
5. Click the like buttons or draw to send notifications back and fourth

## Dependencies
### iOS
- [socket.io-client-swift](https://github.com/socketio/socket.io-client-swift)


### web
- [body-parser](https://www.npmjs.com/package/body-parser)
- [express](https://www.npmjs.com/package/express)
- [nodemon](https://www.npmjs.com/package/nodemon)
- [socket.io](https://www.npmjs.com/package/socket.io)