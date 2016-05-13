private import std.socket;

void main()
{
   auto request = new TcpSocket();
   request.connect(new InternetAddress(6021));
   request.send("A" ~ "\u001f" ~ "REQ" ~ "\u001f");
}
