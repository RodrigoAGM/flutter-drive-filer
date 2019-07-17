import 'package:bloc/bloc.dart';
import 'package:flutter_drive_filer/domain/repository/google_drive_repository.dart';
import 'package:flutter_drive_filer/ui/home/home_events.dart';
import 'package:flutter_drive_filer/ui/home/home_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{

  final GoogleDriveRepository googleDriveRepository;

  HomeBloc({this.googleDriveRepository});

  @override
  HomeState get initialState => HomeStateDefault();

  @override
  Stream<HomeState> mapEventToState(HomeState currentState, HomeEvent event) async*{
    if(event is HomeEventListFolders){
      yield* _mapListFoldersState(event);
    }
  }

  Stream<HomeState> _mapListFoldersState(HomeEvent event) async*{
    try{
      yield HomeStateLoading();
      var result = await googleDriveRepository.findFoldersWithName("DriveFilerApp");
      if(result.isEmpty){
        googleDriveRepository.createFolder("DriveFilerApp");
      }
      var list = await googleDriveRepository.findAllFolders();
      yield HomeStateSearched(list);

    }catch(e){
      yield HomeStateError();
    }
  }

}