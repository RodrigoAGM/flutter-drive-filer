import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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