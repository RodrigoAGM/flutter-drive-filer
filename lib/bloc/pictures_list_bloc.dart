import 'package:bloc/bloc.dart';
import 'package:flutter_drive_filer/domain/repository/google_drive_repository.dart';
import 'package:flutter_drive_filer/ui/pictures_list/pictures_list_events.dart';
import 'package:flutter_drive_filer/ui/pictures_list/pictures_list_states.dart';

class PicturesListBloc extends Bloc<PicturesListEvent, PicturesListState>{

  final GoogleDriveRepository googleDriveRepository;

  PicturesListBloc(this.googleDriveRepository);

  @override
  PicturesListState get initialState => PicturesListStateDefault();

  @override
  Stream<PicturesListState> mapEventToState(PicturesListState currentState, PicturesListEvent event) async*{
    if(event is PicturesListEventListPictures){
      yield* _mapListPicturesEvent(event);
    }
    if(event is PicturesListEventDeletePicture){
      yield* _mapDeletePictureEvent(event);
    }
  }

  Stream<PicturesListState> _mapListPicturesEvent(PicturesListEventListPictures event) async*{
    try{
      yield PicturesListStateLoading();

      var childList = await googleDriveRepository.findPicturesInFolder(event.parent);

      yield PicturesListStateSearched(childList);

    }catch(e){
      yield PicturesListStateError();
    }
  }

  Stream<PicturesListState> _mapDeletePictureEvent(PicturesListEventDeletePicture event) async*{
    try{
      yield PicturesListStateLoading();
      await googleDriveRepository.deleteFolder(event.pictureId);
      var childList = await googleDriveRepository.findPicturesInFolder(event.parent);
      yield PicturesListStateSearched(childList);
    }
    catch(e){
      print(e.toString());
      yield PicturesListStateError();
    }
  }
}

