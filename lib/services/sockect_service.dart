import 'package:flutter/material.dart';
// import 'package:socket_io/socket_io.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { Online, Offline, Connecting }

class SockectService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

  IO.Socket _socket;

  //Gettes $ Setters
  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;
  Function get emit => this.socket.emit;

  SockectService() {
    this._initConfig();
  }

  void _initConfig() {
    //Dart client
    _socket = IO.io('http://192.168.100.15:3000/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    // socket.on('event', (data) => print(data));
    _socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // _socket.on('mensaje', (payload) {
    //    (payload);
    //   // notifyListeners();
    // });

    // _socket.on('nuevo-mensaje', (payload) {
    //   print(payload);
    //   // notifyListeners();
    // });

    // socket.on('fromServer', (_) => print(_));

    // _socket.connect();
  }
}
