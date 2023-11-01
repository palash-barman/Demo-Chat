import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_project/helper/socket_helper.dart';

import 'Controller/chat_controller.dart';

class ChatDetails extends StatefulWidget {
  const ChatDetails({super.key});

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {

  final _chatController = Get.put(ChatController());


  @override
  void initState() {
    _chatController.emitJoinChat();
    _chatController.listenChatList();
    super.initState();
  }
  @override
  void dispose() {
    SocketApi.socket.off("all-messages");
    // TODO: implement dispose
    super.dispose();
  }

  static const styleSender = BubbleStyle(
    margin: BubbleEdges.only(bottom: 10,right: 10),
    alignment: Alignment.topRight,
    radius: Radius.circular(10),
    nip: BubbleNip.rightTop,
    color: Color.fromRGBO(236, 180, 186, 1.0),
  );

  static const styleRecever = BubbleStyle(
    margin: BubbleEdges.only(bottom: 10,left: 10),
    radius: Radius.circular(10),
    alignment: Alignment.topLeft,
    nip: BubbleNip.leftTop,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Screen"),
      ),
      body:Column(
        children: [
          Expanded(
            child: Obx(()=>
               ListView.builder(
                 controller: _chatController.scrollController,
                  itemCount:_chatController.chatList.length,
                  itemBuilder: (context,index){
                    var data = _chatController.chatList[index];
                return Row(
                  mainAxisAlignment:_chatController.senderId ==data['sender']['_id']?MainAxisAlignment.end:MainAxisAlignment.start,
                //  crossAxisAlignment:"65276e62eea22843f3acc4ea"==data['sender']['_id']?CrossAxisAlignment.end:CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width/3,
                      child: Bubble(
                        style: _chatController.senderId==data['sender']['_id']?styleSender:styleRecever,
                        child: Text(data['message']),
                      ),
                    )

                  ],
                );
              }),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: 
              [
                BoxShadow(
                  spreadRadius: 0,
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.25)
                )
              ]
            ),
            child:Row(
              children: [
                 Expanded(
                  child: TextField(
                    controller: _chatController.textController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      hintText: "Text message....",

                    ),

                  ),
                ),

                IconButton(onPressed: (){
                  _chatController.sentMessage(_chatController.textController.text);
                }, icon: Icon(Icons.send))

              ],
            ),
          )
        ],
      ),
    );
  }
}
