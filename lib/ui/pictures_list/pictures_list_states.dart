import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart';

@immutable
abstract class PicturesListState extends Equatable{
  PicturesListState([List props = const []]) : super(props);
}

class PicturesListStateDefault extends PicturesListState {
  @override
  String toString() => 'PicturesListStateDefault';
}

class PicturesListStateLoading extends PicturesListState {
  @override
  String toString() => 'PicturesListStateLoading';
}

class PicturesListStateSearched extends PicturesListState {

  final List<File> files;

  PicturesListStateSearched(this.files);

  @override
  String toString() => 'PicturesListStateSearched';
}

class PicturesListStateError extends PicturesListState {
  @override
  String toString() => 'PicturesListStateError';
}