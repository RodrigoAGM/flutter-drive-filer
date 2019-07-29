import 'package:bloc/bloc.dart';
import 'package:flutter_drive_filer/domain/repository/google_drive_repository.dart';
import 'package:flutter_drive_filer/ui/course_days/course_days_events.dart';
import 'package:flutter_drive_filer/ui/course_days/course_days_states.dart';
import 'package:image_picker/image_picker.dart';

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
    if(event is CourseDaysEventDeleteFolder){
      yield* _mapDeleteFolderEvent(event);
    }
    if(event is CourseDaysEventTakePicture){
      yield* _mapTakePictureEvent(event);
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

  Stream<CourseDaysState> _mapDeleteFolderEvent(CourseDaysEventDeleteFolder event) async*{
    try{
      yield CourseDaysStateLoading();
      await googleDriveRepository.deleteFolder(event.folderId);
      var childList = await googleDriveRepository.findFilesInFolder(event.parent);
      yield CourseDaysStateSearched(childList);
    }
    catch(e){
      print(e.toString());
      yield CourseDaysStateError();
    }
  }

  Stream<CourseDaysState> _mapTakePictureEvent(CourseDaysEventTakePicture event) async*{
    try{
      var _imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
      var childList = event.children;
      if(_imageFile != null){
        //Get the course folder id to save the picture
        var folderId = event.parent;

        //Check if exists folder with the date, if not, create a new folder
        var now = new DateTime.now();
        var dayDate = now.day.toString() + "-" + now.month.toString() + "-" + now.year.toString();
        var result = await googleDriveRepository.findFoldersWithName(dayDate, folderId);
        var dayFolder;

        if(result.isEmpty){
          dayFolder = await googleDriveRepository.createFolder(dayDate, folderId, "");
        }
        else{
          dayFolder = result.first;
        }
        yield CourseDaysStateLoading();
        await googleDriveRepository.savePicture(now.toString().substring(0,now.toString().length - 7), dayFolder.id, _imageFile.path);
        childList = await googleDriveRepository.findFilesInFolder(event.parent);

        _imageFile.delete();
        yield CourseDaysStateSearched(childList);

      }else{
        yield CourseDaysStateSearched(childList);
      }
    }
    catch(e){
      print(e.toString());
      yield CourseDaysStateError();
    }
  }
}

