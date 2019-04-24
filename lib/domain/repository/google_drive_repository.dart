import 'package:flutter_drive_filer/domain/model/google_http_client.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

class GoogleDriveRepository{

  GoogleSignInAccount _account;

  GoogleDriveRepository(this._account);

  Future<File> createFolder(String name) async{
    File folder = new File();
    folder.name = name;
    folder.mimeType = "application/vnd.google-apps.folder";

    final headers = await _account.authHeaders;
    final httpClient = GoogleHttpClient(headers);

    File file = await new DriveApi(httpClient).files.create(folder);

    return file;
  }

}