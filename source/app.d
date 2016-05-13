import std.stdio;
// import socketio.socketio;
import client;
// import vibe.d;
import std.stdio;
import std.socket;
import builder;
import std.json;
import logincallback;
import message.constants;

void main()
{

	  JSONValue authData = parseJSON("{ \"username\": \"faianca\", \"password\": \"test\" }");
		DeepStreamClient client = new DeepStreamClient("localhost");
		auto app = new Application;
	  client.addConnectionChangeListener(app);
		client.login(authData, app);

		// client.getEventHandler.emit("bob");
		// client.getEventHandler.emit("asddasda");
}

 interface ConnectionChangeListener {
    void connectionStateChanged(ConnectionState connectionState);
}

import std.conv;

class Application : ConnectionChangeListener, LoginCallback {

    public void connectionStateChanged( ConnectionState connectionState )
		{
        writeln( "Connection state changed: " ~  to!string(connectionState) );
    }

    public void loginSuccess( string loginData )
		{
			  writeln(loginData);
        writeln( "Login Success" );
    }

    public void loginFailed( string errorEvent ) {
        writeln( "Login failed " ~ errorEvent );
    }
}
