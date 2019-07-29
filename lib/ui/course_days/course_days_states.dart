import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart';

@immutable
abstract class CourseDaysState extends Equatable{
  CourseDaysState([List props = const []]) : super(props);
}

class CourseDaysStateDefault extends CourseDaysState {
  @override
  String toString() => 'CourseDaysStateDefault';
}

class CourseDaysStateLoading extends CourseDaysState {
  @override
  String toString() => 'CourseDaysStateLoading';
}

class CourseDaysStateSearched extends CourseDaysState {

  final List<File> files;
  final String parent;

  CourseDaysStateSearched(this.files, this.parent);

  @override
  String toString() => 'CourseDaysStateSearched';
}

class CourseDaysStateError extends CourseDaysState {
  @override
  String toString() => 'CourseDaysStateError';
}