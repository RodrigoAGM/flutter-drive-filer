import 'package:equatable/equatable.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeState extends Equatable{
  HomeState([List props = const []]) : super(props);
}

class HomeStateDefault extends HomeState {
  @override
  String toString() => 'HomeStateDefault';
}

class HomeStateLoading extends HomeState {
  @override
  String toString() => 'HomeStateLoading';
}

class HomeStateSearched extends HomeState {

  final List<File> files;
  final String parent;

  HomeStateSearched(this.files, this.parent);

  @override
  String toString() => 'HomeStateSearched';
}

class HomeStateError extends HomeState {
  @override
  String toString() => 'HomeStateError';
}
