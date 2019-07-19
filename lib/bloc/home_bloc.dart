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
      yield* _mapListFoldersState(event);
    }
    if(event is HomeEventSignOut){
      yield* _mapSignOutState(event);
    }
    if(event is HomeEventCreateFolder){
      yield* _mapCreateFolderState(event);
    }
  }

  Stream<HomeState> _mapListFoldersState(HomeEvent event) async*{
    try{
      yield HomeStateLoading();
      var result = await googleDriveRepository.findFoldersWithName(Strings.app_folder_name);
      var childList;
      var parent;

      if(result.isEmpty){
        var folder = await googleDriveRepository.createFolder(Strings.app_folder_name, "");
        childList = await googleDriveRepository.findFilesInFolder(folder.id);
        parent = folder.id;
      }
      else{
        childList = await googleDriveRepository.findFilesInFolder(result.first.id);
        parent = result.first.id;
      }
      print("##################################" + parent);
      yield HomeStateSearched(childList, parent);

    }catch(e){
      yield HomeStateError();
    }
  }

  Stream<HomeState> _mapSignOutState(HomeEventSignOut event) async*{
    try{
      yield HomeStateLoading();
      await googleSignInRepository.handleSignOut();
      Navigator.pushReplacement(event.context, MaterialPageRoute(builder: (context) => SignIn()));
    }
    catch(e){
      yield HomeStateError();
    }
  }

  Stream<HomeState> _mapCreateFolderState(HomeEventCreateFolder event) async*{
    try{
      yield HomeStateLoading();
      await googleDriveRepository.createFolder(event.folderName, event.parent);
      var childList = await googleDriveRepository.findFilesInFolder(event.parent);
      var parent = event.parent;

      yield HomeStateSearched(childList, parent);
    }
    catch(e){
      print(e.toString());
      yield HomeStateError();
    }
  }

}