import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../view/pages/actors/actors_page.dart';
import '../models/actor_model.dart';
import '../models/actors_movies_model.dart';

/// This is a [GetX] controller
///
/// Allow to manage state throughout the application, specifically for [ActorsPage]
///
/// Here we are using [Get] as State Management Library
/// Allow to update User Interface in runtime of application and separating
/// the logical portion of application from View
class ActorViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getActorMethod();
  }

  /// This method call an APi using [ActorViewModel] data class and get all
  /// actors list and update [actorModel] with new value
  getActorMethod() async {
    actorModelLoading = true;
    update();
    try {
      ActorModel temp = ActorModel();
      await temp.callApi();
      actorModel = temp;
      actorModelLoading = false;
      update();
    } catch (e) {}
  }

  bool actorModelLoading = false;
  ActorModel actorModel = ActorModel();

  /// This method get all movie list from server for a specific Actor
  getActorsMovies({int id}) async {
    actorMovieModelLoading.value = true;
    ActorsMoviesModel tempModel = ActorsMoviesModel();
    await tempModel.callApi(id: id);
    actorMovieModelLoading.value = false;
    actorsMoviesModel.value = tempModel;
  }

  /// RxList for contain all movie list of a actor
  Rx<ActorsMoviesModel> actorsMoviesModel = ActorsMoviesModel().obs;

  /// keep trace whether network call in progress or completed
  Rx<bool> actorMovieModelLoading = false.obs as Rx<bool>;
}
