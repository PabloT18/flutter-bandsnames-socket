import 'dart:io';

import 'package:band_app/models/band_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    new Band(id: '1', name: 'Metalica', votes: 5),
    new Band(id: '2', name: 'Olita', votes: 3),
    new Band(id: '3', name: 'Metalica3', votes: 4),
    new Band(id: '4', name: 'Cuatro', votes: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Band Names",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) => _bandTile(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addNewBand,
        elevation: 1,
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('$direction');
      },
      background: Container(
        padding: EdgeInsets.only(left: 10.0),
        color: Colors.red,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Delete Band",
              style: TextStyle(color: Colors.white),
            )),
      ),
      child: ListTile(
          leading: CircleAvatar(
            child: Text(band.name.substring(0, 2)),
            backgroundColor: Colors.blue[100],
          ),
          title: Text(band.name),
          trailing: Text(
            '${band.votes}',
            style: TextStyle(fontSize: 20),
          )),
    );
  }

  _addNewBand() {
    final textController = new TextEditingController();

    if (!Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('new band name'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                onPressed: () => addBandToList(textController.text),
                child: Text("Add"),
                elevation: 5,
                textColor: Colors.blue,
              ),
            ],
          );
        },
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text('new band name'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              child: Text("Add"),
              isDefaultAction: true,
              onPressed: () => addBandToList(textController.text),
            ),
            CupertinoDialogAction(
              child: Text("Dismiss"),
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      this
          .bands
          .add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
