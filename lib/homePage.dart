import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:script_it/database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadPage extends StatelessWidget {
  const UploadPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Upload file')), body: FileUpload());
  }
}

class FileUpload extends StatefulWidget {
  @override
  _FileUploadState createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  final Storage storage = Storage();
  final colorPalate = [
    const Color(0xff38b6ff),
    const Color(0xffffde59),
    const Color(0xffff1616),
  ];
  void uploadFile() async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: false);
    final filePath = result?.files.single.path;
    final fileName = result?.files.single.name;
    await storage.uploadFile(filePath, fileName);
    setState(() {});
  }

  void deleteFile(fileName) async {
    await storage.deleteFile(fileName);
    setState(() {});
  }

  Future<firebase_storage.ListResult> listFiles() async {
    return storage.listFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 400,
              height: 200,
              child: GestureDetector(
                onTap: () => uploadFile(),
                child: Card(
                  shadowColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(0),
                          child: Text('Upload image',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey))),
                      Icon(
                        Icons.upload,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
            ),
            FutureBuilder(
                future: listFiles(),
                builder: (BuildContext context,
                    AsyncSnapshot<firebase_storage.ListResult> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Container(
                      child: ListView.builder(
                        itemCount: snapshot.data!.items.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: 400,
                            height: 100,
                            child: Card(
                              margin: EdgeInsets.all(10),
                              color: this.colorPalate[(index % 3).abs()],
                              shadowColor: Colors.blueGrey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 10,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    flex: 7,
                                    child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                            snapshot.data!.items[index].name,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white70))),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.file_download),
                                            color: Colors.white,
                                            padding: EdgeInsets.only(right: 0),
                                            onPressed: () =>
                                                storage.downloadUrl(snapshot
                                                    .data!.items[index].name),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            color: Colors.white,
                                            padding: EdgeInsets.all(0),
                                            alignment: Alignment.centerRight,
                                            onPressed: () => {
                                              deleteFile(snapshot
                                                  .data!.items[index].name)
                                            },
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return Container();
                })
          ],
        )));
  }
}
