module client;

import connection;
import std.stdio;
import std.json;
import event;
import app;
import logincallback;

class DeepStreamClient {

  private {
    Connection connection;
    EventHandler event;
  }

  this (const string url) {
     this.connection = new Connection( url, this );
     this.event = new EventHandler( this.connection );
  }

  void addConnectionChangeListener( ConnectionChangeListener connectionChangeListener ) {
      this.connection.addConnectionChangeListener( connectionChangeListener );
  }

  EventHandler getEventHandler()
  {
      return this.event;
  }

  void login(JSONValue data, LoginCallback callback) {
      this.connection.authenticate(data, callback);
  }

}
