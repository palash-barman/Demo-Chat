import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:test_project/helper/socket_helper.dart';

class ChatController extends GetxController{
  TextEditingController textController = TextEditingController();
  ScrollController scrollController=ScrollController();
  RxList chatList=[].obs;
  var senderId="65276e62eea22843f3acc4ea";



  emitJoinChat(){
    SocketApi.sendMessage("join-chat", {'uid':'6538f971c995834a47cfd3fa'});
  }

  listenChatList(){
    SocketApi.socket.on("all-messages", (data){
      print("=======> listen data : $data");
      chatList.value=data;
      print("=======> last message : ${chatList[chatList.length-1]}");

      chatList.refresh();
      jumpToMessage();
    });
  }


  sentMessage(String message)async{
  await  SocketApi.sendMessage("add-new-message", {
      'message':message,
      'sender': senderId,
      'chat': "6538f971c995834a47cfd3fa"
    });
  textController.clear();

  }

jumpToMessage(){
    scrollController.jumpTo(scrollController.position.maxScrollExtent+50);
}

}