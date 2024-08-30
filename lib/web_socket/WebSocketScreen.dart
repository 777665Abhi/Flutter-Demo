import 'package:flutter/material.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketScreen extends StatelessWidget {
  WebSocketScreen({super.key});

    WebSocketChannel? channel;

   connectSocket() async {
    final wsUrl = Uri.parse('wss://echo.websocket.org');
     channel = WebSocketChannel.connect(wsUrl);

    await channel!.ready;

    channel!.stream.listen((message) {
      print(message);
      channel!.sink.add('Massage 1 received!');
      channel!.sink.add('Massage 2 received!');
    });
  }

   disconnectSocket()
   {
     channel!.sink.close(status.normalClosure,"Exit");
     print("Socket closed");
   }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Web Socket"), ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {connectSocket();},
              child: const Text(
                'Connect Socket',
                style: TextStyle(color: Colors.black, fontSize: 13.0),
              ),
            ),

            ElevatedButton(
              onPressed: () {disconnectSocket();},
              child: const Text(
                'Disconnect Socket',
                style: TextStyle(color: Colors.black, fontSize: 13.0),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
