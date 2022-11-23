import 'dart:convert';
import 'package:camera/insertpage.dart';
import 'package:camera/updatepage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class viewpage extends StatefulWidget {
  const viewpage({Key? key}) : super(key: key);

  @override
  State<viewpage> createState() => _viewpageState();
}

class _viewpageState extends State<viewpage> {

  List l= [];

  bool status = false;
  int result = 0;


  @override
  void initState() {
    super.initState();

    getAllData();
  }
  getAllData()
  async {

    Response response = await Dio().get('https://dhruvrakholiya.000webhostapp.com/contact/view.php');
    print(response.data.toString());

    Map m =jsonDecode(response.data);
    int connection = m['connection'];

    if (connection == 1)
    {
      result = m['result'];

      if(result == 1)
      {
        l =m['data'];
      }
    }
    status = true;
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact"),centerTitle: true,),

      body: status
          ? (result == 1
          ? ListView.builder(
        itemCount: l.length,
        itemBuilder: (context, index) {
          Map map = l[index];

          String imageurt =
              "https://dhruvrakholiya.000webhostapp.com/contact/${map['image']}";
          return ListTile(

            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return updatepage(map);
              },)) ;
            },

            leading: Image.network(imageurt),
            title: Text("${map['name']}"),
            subtitle: Text("${map['contact']}"),
          );
        },
      )
          :Center(child: Text("No data found",style: TextStyle(fontSize: 30),)))
          :Center(child: CircularProgressIndicator()),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return insertpage();
            },
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
