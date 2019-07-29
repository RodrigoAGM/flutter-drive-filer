import 'package:bloc/bloc.dart';
import 'package:flutter_drive_filer/domain/repository/google_drive_repository.dart';
import 'package:flutter_drive_filer/ui/course_days/course_days_events.dart';
import 'package:flutter_drive_filer/ui/course_days/course_days_states.dart';
import 'package:flutter_drive_filer/ui/res/strings.dart';

class CourseDaysBloc extends Bloc<CourseDaysEvent, CourseDaysState>{

  final GoogleDriveRepository googleDriveRepository;

  CourseDaysBloc(this.googleDriveRepository);

  @override
  CourseDaysState get initialState => CourseDaysStateDefault();

  @override
  Stream<CourseDaysState> mapEventToState(CourseDaysState currentState, CourseDaysEvent event) async*{
    if(event is CourseDaysEventListFolders){
      yield* _mapListFoldersEvent(event);
    }
  }

  Stream<CourseDaysState> _mapListFoldersEvent(CourseDaysEventListFolders event) async*{
    try{
      yield CourseDaysStateLoading();

      var childList = await googleDriveRepository.findFilesInFolder(event.parent);
      var parent = event.parent;

      yield CourseDaysStateSearched(childList, parent);

    }catch(e){
      yield CourseDaysStateError();
    }
  }
}

