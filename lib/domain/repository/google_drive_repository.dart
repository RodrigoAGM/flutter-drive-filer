import 'package:flutter_drive_filer/domain/model/google_http_client.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

class GoogleDriveRepository{

  GoogleSignInAccount _account;
  final mime = "application/vnd.google-apps.folder";

  GoogleDriveRepository(this._account);

  Future<File> createFolder(String name) async{
    File folder = new File();
    folder.name = name;
    folder.mimeType = this.mime;

    try{
      final headers = await _account.authHeaders;
      final httpClient = GoogleHttpClient(headers);

      File file = await new DriveApi(httpClient).files.create(folder);
      return file;
    }catch(e){
      print(e);
      return null;
    }

  }

  Future<Set<File>> findFoldersWithName(String name) async{
    final headers = await _account.authHeaders;
    final httpClient = GoogleHttpClient(headers);
    Set<File> fileList = new Set();

    String pageToken;

    try{
      do{
        FileList result = await new DriveApi(httpClient).files.list(
            q: "mimeType='application/vnd.google-apps.folder' and name='"+name+"'",
            spaces: "drive",
            pageToken: pageToken);
        for(File file in result.files){
          print(file.name.toString());
          fileList.add(file);
        }
        pageToken = result.nextPageToken;

      }while(pageToken != null);
      return fileList;
    }catch(e){
      print(e);
      return null;
    }
  }

  Future<Set<File>> findFoldersThatContainName(String name) async{
    final headers = await _account.authHeaders;
    final httpClient = GoogleHttpClient(headers);
    Set<File> files = new Set();

    String pageToken;

    try{
      do{
        FileList result = await new DriveApi(httpClient).files.list(
            q: "mimeType='application/vnd.google-apps.folder' and name contains '"+name+"'",
            spaces: "drive",
            pageToken: pageToken);
        for(File file in result.files){
          files.add(file);
        }
        pageToken = result.nextPageToken;

      }while(pageToken != null);
      return files;
    }catch(e){
      print(e);
      return null;
    }
  }

  Future<Set<File>> findAllFolders() async{
    final headers = await _account.authHeaders;
    final httpClient = GoogleHttpClient(headers);
    Set<File> files = new Set();

    String pageToken;

    try{
      do{
        FileList result = await new DriveApi(httpClient).files.list(
            q: "mimeType='application/vnd.google-apps.folder' and name='DriveFilerApp'",
            spaces: "drive",
            pageToken: pageToken);
        for(File file in result.files){
          files.add(file);
        }
        pageToken = result.nextPageToken;

      }while(pageToken != null);
      return files;
    }catch(e){
      print(e);
      return null;
    }
  }
}