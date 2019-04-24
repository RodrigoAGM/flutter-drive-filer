import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeEvent extends Equatable{}

class HomeEventListFolders extends HomeEvent {

  @override
  String toString() => 'HomeEventListFolders';
}

