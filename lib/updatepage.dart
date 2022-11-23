import 'dart:convert';
import 'dart:io';
import 'package:camera/viewpage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class updatepage extends StatefulWidget {
  Map<dynamic, dynamic> map;

  updatepage(this.map);

  @override
  State<updatepage> createState() => _updatepageState();
}

class _updatepageState extends State<updatepage> {
  final ImagePicker _picker = ImagePicker();
  String path = "";

  TextEditingController tname = TextEditingController();
  TextEditingController temail = TextEditingController();
  TextEditingController tcontact = TextEditingController();

  String imageurl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tname.text = widget.map['name'];
    temail.text = widget.map['email'];
    tcontact.text = widget.map['contact'];
    imageurl =
        "https://dhruvrakholiya.000webhostapp.com/contact/${widget.map['image']}";
  }

  Future<bool> goBack() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return viewpage();
      },
    ));

    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("DHRUV"),
            centerTitle: true,
          ),
          body: ListView(
            children: [
              Column(
                children: [
                  InkWell(
                      onTap: () {
                        showDialog(
                            builder: (context) {
                              return SimpleDialog(
                                title: Text("Select Picture"),
                                children: [
                                  ListTile(
                                    onTap: () async {
                                      final XFile? photo = await _picker.pickImage(
                                          source: ImageSource.camera);
                                      if (photo != null) {
                                        path = photo.path;
                                        setState(() {});
                                      }
                                    },
                                    title: Text("Camera"),
                                    leading: Icon(Icons.camera_alt),
                                  ),
                                  ListTile(
                                    onTap: () async {
                                      final XFile? photo = await _picker.pickImage(
                                          source: ImageSource.gallery);

                                      if (photo != null) {
                                        path = photo.path;
                                        setState(() {});
                                      }
                                    },
                                    title: Text("Gallery"),
                                    leading: Icon(Icons.camera_alt),
                                  ),
                                ],
                              );
                            },
                            context: context);
                      },
                      child: path.isEmpty
                          ? Image.network(
                        imageurl,
                        height: 150,
                        width: 150,
                        fit: BoxFit.fill,
                      )
                          : Image.file(
                        File(path),
                        height: 100,
                        width: 100,
                        fit: BoxFit.fill,
                      )),
                  TextField(
                    controller: tname,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    maxLength: 35,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // errorText: null,
                      hintText: "Username",
                      helperText: "Enter your name",
                      fillColor: Colors.white54,
                      filled: true,

                      prefixIcon: IconButton(
                          onPressed: () {}, icon: Icon(Icons.account_circle)),
                    ),
                  ),
                  TextField(
                    controller: temail,
                    textCapitalization: TextCapitalization.words,
                    maxLength: 35,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // errorText: null,
                      hintText: "email",
                      helperText: "Enter your email address",
                      fillColor: Colors.white54,
                      filled: true,
                      prefixIcon:
                      IconButton(onPressed: () {}, icon: Icon(Icons.email)),
                    ),
                  ),
                  TextField(
                    controller: tcontact,
                    keyboardType: TextInputType.phone,
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 10,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // errorText: null,
                      hintText: "Number",
                      helperText: "Enter your phone number",
                      fillColor: Colors.white54,
                      filled: true,
                      prefixIcon:
                      IconButton(onPressed: () {}, icon: Icon(Icons.phone)),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        String name = tname.text;
                        String email = temail.text;
                        String contact = tcontact.text;

                        String id = widget.map['id'];
                        String serverlocation = widget.map['image'];

                        var formData = FormData.fromMap({});

                        if (path.isEmpty) {
                          formData = FormData.fromMap({
                            'id': id,
                            'name': name,
                            'email': email,
                            'contact': contact,
                            'imageupdate': "0"
                          });
                        } else {
                          DateTime dt = DateTime.now();

                          String imagename =
                              "$name${dt.year}${dt.month}${dt.day}${dt.hour}${dt.minute}${dt.second}.jpg";

                          // GET / POST
                          formData = FormData.fromMap({
                            'id': id,
                            'name': name,
                            'email': email,
                            'contact': contact,
                            'imageupdate': "1",
                            'serverlocation': serverlocation,
                            'file': await MultipartFile.fromFile(path,
                                filename: imagename),
                          });
                        }

                        var response = await Dio().post(
                            'https://dhruvrakholiya.000webhostapp.com/contact/update.php',
                            data: formData);

                        print(response.data);
                        Map m = jsonDecode(response.data);

                        int connection = m['connection'];

                        if (connection == 1) {
                          int result = m['result'];

                          if (result == 1) {
                            print("Data Updated...");

                            Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) {
                                return viewpage();
                              },
                            ));
                          } else {
                            print("Data Not Update");
                          }
                        }
                      },
                      child: Text("Save",style: TextStyle(fontSize: 40),))
                ],
              ),
            ],
          ),
        ),
        onWillPop: goBack);
  }
}
