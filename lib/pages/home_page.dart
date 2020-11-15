import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:band_app/models/band_model.dart';
import 'package:band_app/services/sockect_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    // new Band(id: '1', name: 'Metalica', votes: 5),
    // new Band(id: '2', name: 'Olita', votes: 3),
    // new Band(id: '3', name: 'Metalica3', votes: 4),
    // new Band(id: '4', name: 'Cuatro', votes: 1),
  ];

  @override
  void initState() {
    final sockerServer = Provider.of<SockectService>(context, listen: false);

    sockerServer.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    //Mapear el payload
    this.bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final sockerServer = Provider.of<SockectService>(context, listen: false);
    sockerServer.socket.off('active-bands');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketServer = Provider.of<SockectService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Band Names",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketServer.serverStatus == ServerStatus.Online)
                ? Icon(
                    Icons.check_circle_sharp,
                    color: Colors.blue[300],
                  )
                : Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          _showGraphic(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, index) => _bandTile(bands[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addNewBand,
        elevation: 1,
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SockectService>(context);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.emit('del-band', {'id': band.id}),
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
        ),
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  _addNewBand() {
    final textController = new TextEditingController();

    if (!Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
        ),
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
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
      ),
    );
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      final sockectService =
          Provider.of<SockectService>(context, listen: false);
      sockectService.emit("add-band", {'name': name});
    }
    Navigator.pop(context);
  }

  Widget _showGraphic() {
    Map<String, double> dataMap = new Map();

    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes * 1.0);
    });

    final List<Color> colorList = [
      Colors.blue[50],
      Colors.yellow[100],
      Colors.black12,
      Colors.orange,
    ];
    return Container(
        padding: EdgeInsets.only(top: 10),
        width: double.infinity,
        height: 200,
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 2000),
          // chartLegendSpacing: 32,
          chartRadius: MediaQuery.of(context).size.width / 3.2,
          colorList: colorList,
          initialAngleInDegree: 0,
          chartType: ChartType.ring,
          ringStrokeWidth: 40,
          centerText: "HYBRID",
          legendOptions: LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendShape: BoxShape.rectangle,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: false,
            showChartValues: true,
            showChartValuesInPercentage: true,
            showChartValuesOutside: false,
          ),
        ));
  }
}
