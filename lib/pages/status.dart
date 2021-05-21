import 'package:bands_name/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class StatuPage extends StatelessWidget {
  const StatuPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Container(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Estados'),
        centerTitle: true,
      ),
    ));
  }
}
