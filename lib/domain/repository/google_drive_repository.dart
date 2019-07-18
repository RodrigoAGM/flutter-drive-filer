import 'package:flutter_drive_filer/domain/model/google_http_client.dart';
import 'package:flutter_drive_filer/ui/res/folder_colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/tagmanager/v1.dart';

class GoogleDriveRepository{

  GoogleSignInAccount _account;
  final mime = "application/vnd.google-apps.folder";

  GoogleDriveRepository(this._account);

  Future<File> createFolder(String name) async{
    File folder = new File();
    folder.name = name;
    folder.mimeType = this.mime;
    folder.folderColorRgb = FolderColors.Blue_velvet;

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
            q: "mimeType='application/vnd.google-apps.folder' and name='"+name+"' and trashed = false",
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
            q: "mimeType='application/vnd.google-apps.folder' and name contains '"+name+"' and trashed = false",
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
            q: "mimeType='application/vnd.google-apps.folder' and name='DriveFilerApp' and trashed = false",
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

  Future<Set<File>> findFilesInFolder(String folderId) async{
    final headers = await _account.authHeaders;
    final httpClient = GoogleHttpClient(headers);
    Set<File> files = new Set();
    String pageToken;

    try{
      do{
        FileList result = await new DriveApi(httpClient).files.list(
            q: "mimeType='application/vnd.google-apps.folder' and '"+folderId+"' in parents and trashed = false",
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