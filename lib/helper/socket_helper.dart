import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';


///<------------------------- Lesion Response Convert StreamCallBack ---------------->
class StreamSocket {
  final _socketResponse = StreamController<dynamic>();

  void Function(dynamic) get addResponse => _socketResponse.sink.add;

  Stream<dynamic> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}


///<------------------------- Socket Class ---------------->
class SocketApi {

  // Factory constructor to return the same static instance every time you create an object.
  factory SocketApi() {
    return _socketApi;
  }

  // An internal private constructor to access it only once for the static instance of the class.
  SocketApi._internal();

  ///<------------------------- Socket Initialization ---------------->
  static void init() {
    debugPrint(
        '=============> Socket initialization, connected: ${socket.connected}');
    if (!socket.connected) {
      // socket.connect();
      socket.onConnect((_) {
        debugPrint('===============> Socket Connected');
      });
      // socket.on('APP::CHAT::THREAD::LIST::LATEST::UNREAD', (dynamic data) {
      //   print('Socket instance created and connected');
      //  // socket.emit('user:connected', <dynamic, dynamic>{'user': Environment.user});
      // });
      // socket.on('unauthorized', (dynamic data) {
      //   print('Unauthorized');
      // });
      // socket.onError((dynamic error) {
      //   print('Socket error: $error');
      // });
      // socket.onDisconnect((dynamic data) {
      //   print('Socket instance disconnected');
      // });
    } else {
      debugPrint('Socket instance already connected');
    }
  }

  static final SocketApi _socketApi = SocketApi._internal();

  ///<------------------------- Socket Client ---------------->

  static IO.Socket socket = IO.io(
    "ws://192.168.10.18:3000",
    IO.OptionBuilder().setTransports(['websocket'])
    //   .disableAutoConnect()
    //    .enableForceNewConnection()
    //    .setTimeout(5000)
    //    .setReconnectionDelay(10000)
    //    .enableReconnection()
    // .setQuery(<dynamic, dynamic>{'token': Environment.token})
        .build(),
  );

  ///<------------------------- Send Message and Response ---------------->

  static Future<dynamic> emitWithAck(String event, dynamic body) async {
    Completer<dynamic> completer = Completer<dynamic>();

    socket.emitWithAck(event, body, ack: (data) {
      if (data != null) {
        debugPrint('===========> Emit With Ack $data');
        completer.complete(data);
      } else {
        debugPrint('===========> Null');
        completer.complete(1); // You can specify the default value when null
      }
    });
    return completer.future;
  }


  ///<------------------------- Send Message ---------------->

  static sendMessage(String event, dynamic body) {
    if (body != null) {
      socket.emit(event, body);
      debugPrint('===========> Emit');
    }
  }







}