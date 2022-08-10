import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqlote_camera/connection.dart';
import 'package:sqlote_camera/dataconnect.dart';
import 'package:sqlote_camera/main.dart';

import 'connection.dart';
import 'dataconnect.dart';

class updatePerson extends StatefulWidget {
  int idd;
  String named;
  String aged;
  String imagd;
  updatePerson(
      {Key? key,
      required this.idd,
      required this.named,
      required this.aged,
      required this.imagd})
      : super(key: key);

  @override
  State<updatePerson> createState() => _updatePersonState();
}

class _updatePersonState extends State<updatePerson> {
  TextEditingController controllername = TextEditingController();
  TextEditingController controllerage = TextEditingController();
  File? _imag;
  late ConnectionDB db;
  Future<List<Person>>? _list;
  Future<List<Person>> getList() async {
    return await db.getPerson();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllername.text = widget.named;
    controllerage.text = widget.aged;
    _imag = File(widget.imagd);
    db = ConnectionDB();
    db.initalizeDB().whenComplete(() {
      setState(() {
        _list = db.getPerson();
        print(_list!.then((value) => value.first.name.toString()));
      });
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _list = db.getPerson();
      Future.delayed(const Duration(seconds: 5));
    });
  }

  Future getImageFormCamera() async {
    final image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 100);
    setState(() {
      _imag = File(image!.path);
    });
  }

  Future getImageFormGallary() async {
    final image = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      _imag = File(image!.path);
    });
  }

  Future<void> _showDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Builder(builder: (context) {
                    return const Divider(
                      color: Colors.blue,
                      height: 2,
                    );
                  }),
                  ListTile(
                    onTap: () {
                      getImageFormGallary();
                      Navigator.pop(context);
                    },
                    subtitle: const Text('Gallary'),
                  ),
                  const Divider(
                    color: Colors.pinkAccent,
                    height: 2,
                  ),
                  ListTile(
                    onTap: (() {
                      getImageFormCamera();
                      Navigator.pop(context);
                    }),
                    subtitle: const Text('Camera'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(1),
                          child: _imag == null
                              ? Image.asset(
                                  'assets/images/person.png',
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(_imag!.path),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          left: 25,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showDialog(context);
                                });
                              },
                              icon: const Icon(Icons.camera_alt_outlined))),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controllername,
                            decoration: InputDecoration(
                              hintText: 'Person Name',
                              contentPadding: const EdgeInsets.only(left: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: controllerage,
                            decoration: InputDecoration(
                              hintText: 'Person Age',
                              contentPadding: const EdgeInsets.only(left: 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await ConnectionDB()
                      .updatePerson(Person(
                          id: widget.idd,
                          name: controllername.text,
                          age: controllerage.text,
                          img: _imag!.path))
                      .whenComplete(() {
                    setState(() {
                      print('update sucess');
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyHomePage(
                                  title: 'Flutter Demo Home Page')),
                          (route) => false);
                    });
                  });
                },
                child: Text('Update'))
            // Container(
            //   margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            //   height: 600,
            //   //color: Colors.blue,
            //   child: FutureBuilder<List<Person>>(
            //     future: _list,
            //     builder: (context, AsyncSnapshot<List<Person>> snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return const Center(
            //           child: CircularProgressIndicator(),
            //         );
            //       } else if (snapshot.hasError) {
            //         return const Center(
            //           child: Icon(Icons.info),
            //         );
            //       } else {
            //         var items = snapshot.data ?? <Person>[];
            //         return ListView.builder(
            //             itemCount: items.length,
            //             itemBuilder: (context, index) {
            //               //  var item = snapshot.data![index];
            //               _imag = File(items[index].img);
            //               return Dismissible(
            //                 direction: DismissDirection.endToStart,
            //                 //background: Container(color: Colors.red),
            //                 key: ValueKey<int>(items[index].id),
            //                 onDismissed: (DismissDirection direc) async {
            //                   await ConnectionDB()
            //                       .deletePerson(items[index].id);
            //                 },
            //                 child: InkWell(
            //                   onTap: () {
            //                     setState(() {});
            //                   },
            //                   child: Card(
            //                     child: ListTile(
            //                       leading: CircleAvatar(
            //                         backgroundImage: FileImage(_imag!),
            //                       ),
            //                       title: Text(
            //                         items[index].name,
            //                         style: const TextStyle(fontSize: 20),
            //                       ),
            //                       subtitle: Text(items[index].age),
            //                     ),
            //                   ),
            //                 ),
            //               );
            //             });
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
