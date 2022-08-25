import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:http/http.dart" as http;

final FirebaseAuth _auth = FirebaseAuth.instance;
final User currentUser = _auth.currentUser!;
String? username = currentUser.email;
final newMetadata = SettableMetadata(
  contentType: "image/jpeg",
);

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(String? filepath, String? fileName) async {
    if (filepath != null) {
      File file = File(filepath);
      try {
        await storage.ref('$username/images/$fileName').putFile(file);

        Uri httpUrl =
            Uri(scheme: 'http', path: '/api', host: '192.168.1.15', port: 5000);

        final request = await http.post(httpUrl,
            body: jsonEncode({'user': username, 'fileN': fileName}));
        final decoded = json.decode(request.body);
        final final_response = decoded['fileN'];
        final directory = await getExternalStorageDirectory();
        final directoryPath = directory?.path;
        final fileNameNoExt = basenameWithoutExtension(fileName!);
        await File('$directoryPath/$fileNameNoExt.txt').create(recursive: true);
        File textFile = File('$directoryPath/$fileNameNoExt.txt');
        textFile.writeAsString(final_response);

        await storage.ref('$username/$fileNameNoExt.txt').putFile(textFile);
      } on firebase_core.FirebaseException catch (e) {
        print(e);
      }
    }
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results =
        await storage.ref('$username').listAll();

    return results;
  }

  void downloadUrl(String imageName) async {
    String downloadUrl =
        await storage.ref('$username/$imageName').getDownloadURL();
    var dir = await DownloadsPathProvider.downloadsDirectory;
    if (dir != null) {
      String savename = "$imageName";
      String savePath = dir.path + "/$savename";
      print(savePath);
      //output:  /storage/emulated/0/Download/banner.png

      try {
        await Dio().download(downloadUrl, savePath,
            onReceiveProgress: (received, total) {
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + "%");
            //you can build progressbar feature too
          }
        });
        print("File is saved to download folder.");
      } on DioError catch (e) {
        print(e.message);
      }
    }
  }

  void deleteFile(String imageName) {
    final fileRef = storage.ref("$username/$imageName");
    fileRef.delete();
  }
}
