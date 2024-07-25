import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? _socket;

  IO.Socket? get socket => _socket; // Public getter

  void initializeSocket() {
    _socket = IO.io(
        'http://localhost:4000',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());

    _socket?.connect();

    _socket?.onConnect((_) {
      print('Connected to socket server');
    });

    _socket?.onDisconnect((_) {
      print('Disconnected from socket server');
    });

    // _socket?.on('visitorLogsUpdated', (data) {
    //   // print('Visitor logs updated: $data');
    //   // Handle the incoming visitor logs update here
    // });
  }

  void dispose() {
    _socket?.disconnect();
  }
}
