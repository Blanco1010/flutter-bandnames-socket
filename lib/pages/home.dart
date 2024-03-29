import 'package:flutter/material.dart';
import 'package:bands_name/services/socket_service.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:bands_name/models/band.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBand);
    super.initState();
  }

  _handleActiveBand(dynamic payload) {
    this.bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands', (data) => null);
    super.dispose();
  }

  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "BandNames",
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
          elevation: 1,
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: socketService.serverStatus == ServerStatus.Online
                  ? Icon(Icons.check_circle, color: Colors.blue[300])
                  : Icon(Icons.offline_bolt, color: Colors.red[300]),
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.white),
      body: Column(
        children: <Widget>[
          Expanded(child: _showGraph()),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) => _bandTile(bands[i]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: addNewBand, elevation: 1),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) =>
          socketService.socket.emit('remove-band', {'id': band.id}),
      background: Container(
        padding: EdgeInsets.only(left: 15),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Delete Band',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: ListTile(
          leading: CircleAvatar(
            child: Text(band.name.substring(0, 2)),
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.black,
          ),
          title: Text(band.name),
          trailing: Text('${band.votes}', style: TextStyle(fontSize: 22.5)),
          onTap: () => socketService.socket.emit('vote-band', {'id': band.id})),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      //ANDROID
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('New band name:'),
          content: TextField(controller: textController),
          actions: <Widget>[
            MaterialButton(
                child: Text('Add'),
                elevation: 1,
                color: Colors.lightBlue,
                onPressed: () => addBandToList(textController.text))
          ],
        ),
      );
    }

    if (Platform.isMacOS) {
      return showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text('New band name'),
          content: CupertinoTextField(controller: textController),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Add'),
              onPressed: () => addBandToList(textController.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Dismiss'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    }
  }

  void addBandToList(String name) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (name.length > 1) {
      socketService.socket.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  // Mostrar grafica
  _showGraph() {
    Map<String, double> dataMap = new Map();
    bands.forEach((element) {
      dataMap.putIfAbsent(element.name, () => element.votes.toDouble());
    });

    return PieChart(dataMap: dataMap);
  }
}
