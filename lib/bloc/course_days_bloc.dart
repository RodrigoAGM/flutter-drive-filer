import 'package:bloc/bloc.dart';
import 'package:flutter_drive_filer/domain/repository/google_drive_repository.dart';
import 'package:flutter_drive_filer/ui/course_days/course_days_events.dart';
import 'package:flutter_drive_filer/ui/course_days/course_days_states.dart';

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
    if(event is CourseDaysEventUpdateFolder){
      yield* _mapUpdateFolderEvent(event);
    }
  }

  Stream<CourseDaysState> _mapListFoldersEvent(CourseDaysEventListFolders event) async*{
    try{
      yield CourseDaysStateLoading();

      var childList = await googleDriveRepository.findFilesInFolder(event.parent);

      yield CourseDaysStateSearched(childList);

    }catch(e){
      yield CourseDaysStateError();
    }
  }

  Stream<CourseDaysState> _mapUpdateFolderEvent(CourseDaysEventUpdateFolder event) async*{
    try{
      yield CourseDaysStateLoading();
      await googleDriveRepository.updateFolder(event.folderName, event.parent, event.folderDescription, event.folderColor, event.folderId);
      var childList = await googleDriveRepository.findFilesInFolder(event.parent);
      print(childList[0].folderColorRgb);
      yield CourseDaysStateSearched(childList);
    }
    catch(e){
      print(e.toString());
      yield CourseDaysStateError();
    }
  }
}

