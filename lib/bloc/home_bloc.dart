import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drive_filer/domain/repository/google_drive_repository.dart';
import 'package:flutter_drive_filer/domain/repository/google_sign_in_repository.dart';
import 'package:flutter_drive_filer/ui/home/home.dart';
import 'package:flutter_drive_filer/ui/home/home_events.dart';
import 'package:flutter_drive_filer/ui/home/home_states.dart';
import 'package:flutter_drive_filer/ui/login/sign_in.dart';
import 'package:flutter_drive_filer/ui/res/strings.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{

  final GoogleDriveRepository googleDriveRepository;
  final GoogleSignInRepository googleSignInRepository;

  HomeBloc({this.googleSignInRepository, this.googleDriveRepository});

  @override
  HomeState get initialState => HomeStateDefault();

  @override
  Stream<HomeState> mapEventToState(HomeState currentState, HomeEvent event) async*{
    if(event is HomeEventListFolders){
      yield* _mapListFoldersEvent(event);
    }
    if(event is HomeEventSignOut){
      yield* _mapSignOutEvent(event);
    }
    if(event is HomeEventCreateFolder){
      yield* _mapCreateFolderEvent(event);
    }
    if(event is HomeEventUpdateFolder){
      yield* _mapUpdateFolderEvent(event);
    }
    if(event is HomeEventDeleteFolder){
      yield* _mapDeleteFolderEvent(event);
    }
  }

  Stream<HomeState> _mapListFoldersEvent(HomeEventListFolders event) async*{
    try{
      yield HomeStateLoading();
      var result = await googleDriveRepository.findFoldersWithName(Strings.app_folder_name);
      var childList;
      var parent;

      if(result.isEmpty){
        var folder = await googleDriveRepository.createFolder(Strings.app_folder_name, "", "");
        childList = await googleDriveRepository.findFilesInFolder(folder.id);
        parent = folder.id;
      }
      else{
        childList = await googleDriveRepository.findFilesInFolder(result.first.id);
        parent = result.first.id;
      }
      yield HomeStateSearched(childList, parent);

    }catch(e){
      yield HomeStateError();
    }
  }

  Stream<HomeState> _mapSignOutEvent(HomeEventSignOut event) async*{
    try{
      yield HomeStateLoading();
      await googleSignInRepository.handleSignOut();
      Navigator.pushReplacement(event.context, MaterialPageRoute(builder: (context) => SignIn()));
    }
    catch(e){
      yield HomeStateError();
    }
  }

  Stream<HomeState> _mapCreateFolderEvent(HomeEventCreateFolder event) async*{
    try{
      yield HomeStateLoading();
      print(event.folderDescription);
      await googleDriveRepository.createFolder(event.folderName, event.parent, event.folderDescription);
      var childList = await googleDriveRepository.findFilesInFolder(event.parent);
      var parent = event.parent;
      print(childList[0].folderColorRgb);
      yield HomeStateSearched(childList, parent);
    }
    catch(e){
      print(e.toString());
      yield HomeStateError();
    }
  }

  Stream<HomeState> _mapUpdateFolderEvent(HomeEventUpdateFolder event) async*{
    try{
      yield HomeStateLoading();
      await googleDriveRepository.updateFolder(event.folderName, event.parent, event.folderDescription, event.folderColor, event.folderId);
      var childList = await googleDriveRepository.findFilesInFolder(event.parent);
      var parent = event.parent;
      print(childList[0].folderColorRgb);
      yield HomeStateSearched(childList, parent);
    }
    catch(e){
      print(e.toString());
      yield HomeStateError();
    }
  }

  Stream<HomeState> _mapDeleteFolderEvent(HomeEventDeleteFolder event) async*{
    try{
      yield HomeStateLoading();
      await googleDriveRepository.deleteFolder(event.folderId);
      var childList = await googleDriveRepository.findFilesInFolder(event.parent);
      var parent = event.parent;
      print(childList[0].folderColorRgb);
      yield HomeStateSearched(childList, parent);
    }
    catch(e){
      print(e.toString());
      yield HomeStateError();
    }
  }

}