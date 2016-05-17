var DeepstreamServer = require( 'deepstream.io' ),
    server = new DeepstreamServer();

// Optionally you can specify some settings, a full list of which
// can be found here //deepstream.io/docs/deepstream.html
server.set( 'host', 'localhost' );
server.set( 'port', 6020 );
server.set( 'permissionHandler', {
    isValidUser: function( connectionData, authData, callback ) {
        callback( null, authData.username || 'open' );
    },

    canPerformAction: function( username, message, callback ) {
        callback( null, true );
    }
});
// start the server
server.start();
