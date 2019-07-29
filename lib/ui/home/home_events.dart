import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeEvent extends Equatable{}

class HomeEventListFolders extends HomeEvent {

  @override
  String toString() => 'HomeEventListFolders';
}

class HomeEventSignOut extends HomeEvent {

  final BuildContext context;

  HomeEventSignOut(this.context);

  @override
  String toString() => 'HomeEventSignOut';
}

class HomeEventCreateFolder extends HomeEvent{

  final String parent;
  final String folderName;
  final String folderDescription;

  HomeEventCreateFolder(this.parent, this.folderName, this.folderDescription);

  @override
  String toString() => 'HomeEventCreateFolder';
}

class HomeEventUpdateFolder extends HomeEvent{

  final String parent;
  final String folderName;
  final String folderDescription;
  final String folderColor;
  final String folderId;

  HomeEventUpdateFolder(this.parent, this.folderName, this.folderDescription, this.folderColor, this.folderId);

  @override
  String toString() => 'HomeEventUpdateFolder';
}

class HomeEventDeleteFolder extends HomeEvent{

  final String parent;
  final String folderId;

  HomeEventDeleteFolder(this.parent, this.folderId);

  @override
  String toString() => 'HomeEventDeleteFolder';
}

class HomeEventTakePicture extends HomeEvent{

  final List<File> children;
  final String parent;
  final BuildContext context;

  HomeEventTakePicture(this.children, this.parent, this.context);

  @override
  String toString() => 'HomeEventTakePicture';
}