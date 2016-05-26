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
import std.regex;
import vibe.vibe;

void main()
{

    JSONValue authData = parseJSON("{ \"username\": \"faianca\", \"password\": \"test\" }");
    DeepStreamClient client = new DeepStreamClient("localhost");
    auto app = new Application;
    client.addConnectionChangeListener(app);
    client.login(authData, app);
    writeln(client.getState());

    while(client.isConnected()) {
         
    }

    client.getEventHandler.emit("bob");
    // client.getEventHandler.emit("asddasda");
}

interface ConnectionChangeListener {
    void connectionStateChanged(ConnectionState connectionState);
}

import std.conv;

enum MessageType
{
    disconnect = 0,
    connect,
    heartbeat,
    message,
    json,
    event,
    ack,
    error,
    noop
}

struct Message
{
    MessageType type;
    string name;
    Json[] args;
    string message;
}

import std.process;
auto decodePacket(string packet)
{
    auto re = regex("([^:]+):([0-9]+)?(\\+)?:([^:]+)?:?([\\s\\S]*)?");
    auto m = match(packet, re);
    writeln("DECODING");
    writeln(packet);
    writeln(m);
    auto type = m.captures[1];
    auto data = m.captures[5];
    auto msg = Message(cast(MessageType)to!int(type));
    writeln(msg.type);
    return msg;

    switch(msg.type)
    {
        case MessageType.message:
            msg.message = data;
            break;
        case MessageType.json:
            msg.args ~= parseJson(data);
            break;
        case MessageType.event:
            auto json = parseJson(data);
            msg.name = json.name.get!string;
            msg.args = json.args.get!(Json[]);
            break;
        default:
    }
    return msg;
}

class Application : ConnectionChangeListener, LoginCallback {

    public void connectionStateChanged( ConnectionState connectionState )
    {
        writeln( "Connection state changed: " ~  to!string(connectionState) );
    }

    public void loginSuccess( string loginData )
    {
        //writeln(decodePacket(loginData));
        MessageBuilder.parse(loginData);

        writeln( "Login Success" );
        writeln("Doing Something after Loggin");
    }

    public void loginFailed( string errorEvent ) {
        writeln( "Login failed " ~ errorEvent );
    }
}
