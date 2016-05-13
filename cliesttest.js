var deepstream = require('deepstream.io-client-js');

ds = deepstream('localhost:6021');

// ds.getConnectionState() will now return 'AWAITING_AUTHENTICATION'

ds.login({ username: 'PeterAs', password: 'sesame' }, function( success, errorEvent, data ){
    if( success ) {
      console.log("YES FODASSE");
    } else {
        // extra data can be optionaly sent from deepstream for
        // both successful and unsuccesful logins
    console.log(data);
     // ds.getConnectionState() will now return 'AWAITING_AUTHENTICATION' or 'CLOSED' if the maximum number
        // of authentication attempts has been exceeded.
    }
});
