import 'package:bands_name/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class StatuPage extends StatelessWidget {
  const StatuPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    // socketService.socket.emit(event);

    return Container(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('ServerStatus: ${socketService.serverStatus}')
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message),
          onPressed: () {
            socketService.emit('emitir-mensaje',
                {'nombre': 'Flutter', 'mensaje': 'Mensaje para flutter'});
          },
        ),
      ),
    );
  }
}
