import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_project/ChatScreen/chat_screen.dart';
import 'package:test_project/helper/socket_helper.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  List userList=[
    {
      'name':"Palash Barman",
      'last_message':"hi",
    },
    {
      'name':"Rohim",
      'last_message':"hlo",
    }
  ];
  @override
  void initState() {
    SocketApi.init();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inbox Screen"),
      ),
      body:ListView.builder(
          itemCount: userList.length,
          itemBuilder:(context,index){
            return ListTile(
              onTap: (){
                Get.to(ChatDetails());
              },
              title: Text(userList[index]['name']),
              subtitle: Row(
                children: [
                  Icon(Icons.message),
                  SizedBox(width: 10,),
                  Expanded(child: Text(userList[index]['last_message'],maxLines: 1,overflow: TextOverflow.ellipsis,)),
                ],
              ),
              leading:const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blueAccent,
              ),
            );

      }),
    );
  }
}
