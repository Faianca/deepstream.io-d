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

    this ( string raw ) {
        this.raw = raw;
    }

   override public string toString() {
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
        //return topic ~ MESSAGE.MPS ~ action ~ MESSAGE.MPS ~ data ~ MESSAGE.MS;
        return topic ~ "\u001f" ~ action ~ "\u001f" ~ data ~ "\u001e";
    }

    static Message[] parse( string message ) {
        Message[] messages;
        auto rawMessages = message.split("\u001e");
        foreach(string rawMessage; rawMessages) {
         
            if (rawMessage.length > 2 && rawMessage != "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
                    && rawMessage != "\0\0\0\0\0\0\0\0\0"
                    ) {
                messages ~= parseMessage(rawMessage) ;
            }
        }
        return messages;
    }

    static private Message parseMessage( string message )
    {
        auto parts = message.split("\u001f");
        writeln("SINGLE MESSAGE");
        writeln("\u001f");
        writeln(message);
        writeln(parts);
        writeln(parts.length);

        if( parts.length < 2 ) {
            throw new Error( " Insufficient Parts" );
        }

        return new Message( message );

        // return new Message( message, Topic.getTopic( parts[0] ), Actions.getAction(parts[1]));
    }

}
