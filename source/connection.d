module connection;

import std.stdio;
import client;
import std.socket;
import logincallback;
import builder;
import std.json;

import vibe.http.websockets;
import message.constants;
import app;
import vibe.data.json;

// class EventObject
// {
//     alias void delegate(Json[] data) Handler;
//     alias void delegate(Json data) HandlerSingle;
//     alias void delegate() HandlerEmpty;
//
//     void on(string name, Handler dg)
//     {
//         m_handlers[name] ~= dg;
//     }
//
//     void on(string name, HandlerSingle dg)
//     {
//         m_singleHandlers[name] ~= dg;
//     }
//
//     void on(string name, HandlerEmpty dg)
//     {
//         m_emptyHandlers[name] ~= dg;
//     }
//
//     void emitEvent(string name, Json[] args)
//     {
//         foreach(dg; m_handlers.get(name, []))
//             dg(args);
//         foreach(dg; m_emptyHandlers.get(name, []))
//             dg();
//         if(args.length >= 1)
//             foreach(dg; m_singleHandlers.get(name, []))
//                 dg(args[0]);
//     }
//
//
// private:
//     Handler[][string] m_handlers;
//     HandlerSingle[][string] m_singleHandlers;
//     HandlerEmpty[][string] m_emptyHandlers;
// }
//
// class IoSocket : EventObject
// {
//     alias void delegate(string data) HandlerString;
//
//     string m_id;
//
//     @property string id()
//     {
//         return m_id;
//     }
//
//     void emit(string name, Json[] args...)
//     {
//         // send(Message(MessageType.event, name, args));
//     }
//
//     void onOpen()
//     {
//         emitEvent("open", []);
//     }
//
//     void onClose()
//     {
//         emitEvent("disconnect", []);
//     }
// }
// import socket;

class Connection {

    private{
        DeepStreamClient client;
        string originalUrl;
        LoginCallback loginCallback;
        ConnectionState connectionState;
        TcpSocket socket;
        string messageBuffer;
        string buffer;
        JSONValue authParameters;
        WebSocket testSocket;
    }

    private ConnectionChangeListener[] connectStateListeners;

    // private StringBuilder messageBuffer;

    // private LoginCallback loginCallback;
    // private JSONObject authParameters;

    this(const string url, DeepStreamClient client) {
        writeln( "Connecting to " ~ url );
        this.client = client;
        this.originalUrl = url;
        this.connectionState = ConnectionState.AWAITING_AUTHENTICATION;
        this.socket = new TcpSocket();
        this.socket.connect(new InternetAddress("localhost", 6021));
        this.addConnectionListeners();
    }

    void authenticate(JSONValue authParameters, LoginCallback loginCallback) {
        this.loginCallback = loginCallback;
        this.authParameters = authParameters;

        if( this.connectionState == ConnectionState.AWAITING_AUTHENTICATION ) {
            this.setState( ConnectionState.AUTHENTICATING );
            this.sendAuthMessage();
        }

    }

    void send( string message ) {
        if( this.connectionState != ConnectionState.OPEN ) {
            this.messageBuffer ~= message;
            writeln( "Buffering " ~ message );
        } else {
            writeln( "Sending " ~ message );
            this.socket.send( message );
        }
    }

    private void sendAuthMessage() {
        string authMessage = MessageBuilder.getMsg(Topic.AUTH, Actions.REQUEST, this.authParameters.toString());
        writeln(authMessage);
        this.socket.send(authMessage);
        char[1024] buffer;
        auto buf = new ubyte[authMessage.length];
        this.socket.receive(buf);
        string test = cast(string)buf;
        this.connectionState = ConnectionState.OPEN;
        loginCallback.loginSuccess(test);
    }

    void setState( ConnectionState connectionState ) {
        this.connectionState = connectionState;

        if( connectionState == ConnectionState.AWAITING_CONNECTION ) {
            this.sendAuthMessage();
        }

        foreach (ConnectionChangeListener listener; this.connectStateListeners) {
            listener.connectionStateChanged( connectionState );
        }
    }

    //
    void addConnectionChangeListener( ConnectionChangeListener connectionChangeListener ) {
        this.connectStateListeners ~= connectionChangeListener;
    }
    //
    // public void removeConnectionChangeListener( ConnectionChangeListener connectionChangeListener ) {
    //     this.connectStateListeners.remove( connectionChangeListener );
    // }
    //

    ConnectionState getConnectionState() {
        return this.connectionState;
    }

    private void addConnectionListeners() {

    }


}
