import 'package:bloc/bloc.dart';
import 'package:flutter_drive_filer/ui/home/home_events.dart';
import 'package:flutter_drive_filer/ui/home/home_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{

  @override
  HomeState get initialState => HomeStateDefault();

  @override
  Stream<HomeState> mapEventToState(HomeState currentState, HomeEvent event) {
    // TODO: implement mapEventToState
    return null;
  }

}