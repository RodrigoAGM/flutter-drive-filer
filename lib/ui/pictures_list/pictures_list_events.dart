import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class PicturesListEvent extends Equatable{}

class PicturesListEventListPictures extends PicturesListEvent {

  final String parent;

  PicturesListEventListPictures(this.parent);

  @override
  String toString() => 'PicturesListEventListPictures';
}

class PicturesListEventDeletePicture extends PicturesListEvent{

  final String parent;
  final String pictureId;

  PicturesListEventDeletePicture(this.parent, this.pictureId);

  @override
  String toString() => 'PicturesListEventDeletePicture';
}