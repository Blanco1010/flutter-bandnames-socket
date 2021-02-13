import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bands_name/models/band.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Python', votes: 1),
    Band(id: '2', name: 'C++', votes: 6),
    Band(id: '3', name: 'Java', votes: 7),
    Band(id: '4', name: 'C#', votes: 3),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("BandNames", style: TextStyle(color: Colors.black87)),
          centerTitle: true,
          backgroundColor: Colors.white),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, i) => _bandTile(bands[i])),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: addNewBand, elevation: 1),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        print('${band.id}');
      },
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
        onTap: () {
          print('${band.name}');
        },
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      //ANDROID
      return showDialog(
        context: context,
        builder: (contetx) {
          return AlertDialog(
            title: Text('New band name:'),
            content: TextField(controller: textController),
            actions: <Widget>[
              MaterialButton(
                  child: Text('Add'),
                  elevation: 1,
                  color: Colors.lightBlue,
                  onPressed: () => addBandToList(textController.text))
            ],
          );
        },
      );
    }

    if (Platform.isMacOS) {
      return showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
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
            );
          });
    }
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      //agregar
      this
          .bands
          .add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
