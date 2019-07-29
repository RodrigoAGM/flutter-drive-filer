import 'dart:io' as prefix0;
import 'package:flutter_drive_filer/domain/model/google_http_client.dart';
import 'package:flutter_drive_filer/ui/res/folder_colors.dart';
import 'package:flutter_drive_filer/ui/res/strings.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

class GoogleDriveRepository{

  GoogleSignInAccount _account;
  final mime = "application/vnd.google-apps.folder";
  final mimePicture = "application/vnd.google-apps.photo";

  GoogleDriveRepository(this._account);

  Future<File> createFolder(String name, String parent, String description) async{
    File folder = new File();
    folder.name = name;
    folder.mimeType = this.mime;
    if(parent == ""){
      folder.folderColorRgb = FolderColors.Vern_fern;
      folder.description = "This is the folder for " + Strings.app_name;
    }
    else{
      List<String> parents = [parent];
      folder.parents = parents;
      folder.folderColorRgb = FolderColors.Rainy_sky;
      folder.description = description;
    }

    try{
      final headers = await _account.authHeaders;
      final httpClient = GoogleHttpClient(headers);

      File file = await new DriveApi(httpClient).files.create(folder);
      return file;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<File> updateFolder(String name, String parent, String description, String folderColor, String folderId) async{

    try{
      final headers = await _account.authHeaders;
      final httpClient = GoogleHttpClient(headers);

      File folder = new File();
      folder.mimeType = this.mime;
      folder.name = name;
      folder.folderColorRgb = folderColor;
      folder.description = description;
      File file = await new DriveApi(httpClient).files.update(folder, folderId);
      return file;
    }catch(e){
      print(e.toString());
      return null;
    }

  }

   Future<File> deleteFolder(String folderId) async{

    try{
      final headers = await _account.authHeaders;
      final httpClient = GoogleHttpClient(headers);

      File file = await new DriveApi(httpClient).files.delete(folderId);
      return file;
    }catch(e){
      print(e.toString());
      return null;
    }

  }

  Future<List<File>> findFoldersWithName(String name, String parent) async{
    final headers = await _account.authHeaders;
    final httpClient = GoogleHttpClient(headers);
    List<File> fileList = [];

    String pageToken;
    var query;

    if(parent == ""){
      query = "mimeType='application/vnd.google-apps.folder' and name='"+name+"' and trashed = false";
    }else{
      query = "mimeType='application/vnd.google-apps.folder' and name='"+name+"' and trashed = false and '"+parent+"' in parents";
    }
    print(query);

    try{
      do{
        FileList result = await new DriveApi(httpClient).files.list(
            q: query,
            $fields: "nextPageToken, files(id, name, description, folderColorRgb, parents)",
            spaces: "drive",
            pageToken: pageToken);
        for(File file in result.files){
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

  Future<List<File>> findFoldersThatContainName(String name) async{
    final headers = await _account.authHeaders;
    final httpClient = GoogleHttpClient(headers);
    List<File> files = [];

    String pageToken;

    try{
      do{
        FileList result = await new DriveApi(httpClient).files.list(
            q: "mimeType='application/vnd.google-apps.folder' and name contains '"+name+"' and trashed = false",
            $fields: "nextPageToken, files(id, name, description, folderColorRgb, parents)",
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

  Future<List<File>> findAllFolders(String parent) async{
    final headers = await _account.authHeaders;
    final httpClient = GoogleHttpClient(headers);
    List<File> files = [];
    String pageToken;

    try{
      do{
        FileList result = await new DriveApi(httpClient).files.list(
            q: "mimeType='application/vnd.google-apps.folder' and name='DriveFilerApp' and trashed = false and '"+parent+"' in parents",
            $fields: "nextPageToken, files(id, name, description, folderColorRgb, parents)",
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

  Future<List<File>> findFilesInFolder(String folderId) async{
    final headers = await _account.authHeaders;
    final httpClient = GoogleHttpClient(headers);
    List<File> files = [];
    String pageToken;

    try{
      do{
        FileList result = await new DriveApi(httpClient).files.list(
            q: "mimeType='application/vnd.google-apps.folder' and '"+folderId+"' in parents and trashed = false",
            $fields: "nextPageToken, files(id, name, description, folderColorRgb, parents)",
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

  Future<List<File>> findPicturesInFolder(String folderId) async{
    final headers = await _account.authHeaders;
    final httpClient = GoogleHttpClient(headers);
    List<File> files = [];
    String pageToken;

    try{
      do{
        FileList result = await new DriveApi(httpClient).files.list(
            q: "mimeType='image/jpeg' and '"+folderId+"' in parents and trashed = false",
            $fields: "nextPageToken, files(id, name, parents, thumbnailLink)",
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

  Future<File> savePicture(String name, String parent, String path) async{
    File picture = new File();
    picture.name = name;
    List<String> parents = [parent];
    picture.parents = parents;
    picture.mimeType = 'image/jpeg';

    prefix0.File file = new prefix0.File(path);
    var length = await file.length();
    var media = Media(file.openRead(), length,  contentType: 'image/jpeg');

    try{
      final headers = await _account.authHeaders;
      final httpClient = GoogleHttpClient(headers);
      File file = await new DriveApi(httpClient).files.create(picture, uploadMedia: media);
      return file;
    }catch(e){
      print(e.toString());
      return null;
    }

  }
}