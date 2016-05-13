import std.conv;
import message.constants;
import connection;
import std.array;

class Message {
    public string raw;
    public Actions action;
    public Topic topic;
    public string[] data;

    this( string raw, Topic topic, Actions action, string[] data ) {
        this.raw = raw;
        this.topic = topic;
        this.action = action;
        this.data = data;
    }

    public string toString() {
        return this.raw;
    }
}

import std.stdio;
class MessageBuilder {

    private {
      enum MESSAGE : string {
        MPS = "\u001f",
        MS = "\u001e"
      }
    }

    static string getMsg()
    {
        return "A" ~ MESSAGE.MPS ~ "REQ" ~ MESSAGE.MPS ~ "{\"username\": \"faianca\"}" ~ MESSAGE.MS;
    }

    static string getMsg( Topic topic, Actions action, string data ) {
        return topic ~ MESSAGE.MPS ~ action ~ MESSAGE.MPS ~ data ~ MESSAGE.MS;
    }

    static Message[] parse( string message, Connection connection ) {
        Message[] messages;
        string[] rawMessages = message.split(MESSAGE.MS);
        for( short i=0; i < rawMessages.length; i++ ) {
            messages ~= parseMessage(rawMessages[ i ]) ;
        }
        return messages;
    }

    static private Message parseMessage( string message )
    {
        string[] parts = message.split( MESSAGE.MPS );

        // if( parts.length < 2 ) {
        //     throw new Error( " Insufficient Parts" );
        // }
        //
        // if( Topic.getTopic( parts[ 0 ] ) == null ) {
        //     throw new Error( " Incorrect Type " ~ parts[ 0 ]  );
        // }
        //
        // if( Actions.getAction( parts[ 1 ] ) == null ) {
        //     throw new Error(" Incorrect Action " ~ parts[ 1 ] );
        // }
        writeln(parts);
        return new Message( message );

        // return new Message( message, Topic.getTopic( parts[0] ), Actions.getAction(parts[1]));
    }

}
