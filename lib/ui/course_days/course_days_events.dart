import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart';

@immutable
abstract class CourseDaysEvent extends Equatable{}

class CourseDaysEventListFolders extends CourseDaysEvent {

  final String parent;

  CourseDaysEventListFolders(this.parent);

  @override
  String toString() => 'CourseDaysEventListFolders';
}

class CourseDaysEventUpdateFolder extends CourseDaysEvent{

  final String parent;
  final String folderName;
  final String folderDescription;
  final String folderColor;
  final String folderId;

  CourseDaysEventUpdateFolder(this.parent, this.folderName, this.folderDescription, this.folderColor, this.folderId);

  @override
  String toString() => 'CourseDaysEventUpdateFolder';
}

class CourseDaysEventDeleteFolder extends CourseDaysEvent{

  final String parent;
  final String folderId;

  CourseDaysEventDeleteFolder(this.parent, this.folderId);

  @override
  String toString() => 'CourseDaysEventDeleteFolder';
}

class CourseDaysEventTakePicture extends CourseDaysEvent{

  final List<File> children;
  final String parent;
  final BuildContext context;

  CourseDaysEventTakePicture(this.children, this.parent, this.context);

  @override
  String toString() => 'CourseDaysEventTakePicture';
}