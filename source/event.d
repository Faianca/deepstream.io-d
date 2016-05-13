import connection;
import message.constants;
import builder;
import std.signals;
import std.stdio;

class Emitter {
  mixin Signal!(string);
}

class Observer {
    // our slot
    void watch(string msg)
    {
        writeln("Received event " ~ msg);
    }
}

class EventHandler {

    private Emitter emitter;
    private Connection connection;

    this( Connection connection ) {
        Observer o = new Observer;
        this.emitter = new Emitter;
        this.emitter.connect(&o.watch);
        this.connection = connection;
    }

    void emit( string eventName ) {
        this.connection.send( MessageBuilder.getMsg( Topic.EVENT, Actions.EVENT, eventName ) );
        this.emitter.emit( eventName );
    }

}
