import 'package:get/get_state_manager/get_state_manager.dart';

import '../../view/pages/dashboard/dashboard_screen.dart';
import '../../view/pages/explore/explore_page.dart';
import '../../view/search_delegate/search_delegate.dart';
import '../models/sponsor_model.dart';
import '../repo/ads/sponsors_repo.dart';

/// A [GetxController] to manage states of sponsor related widgets
class SponsorViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getSponsorMethod();
  }

  /// This method call an api and get sponsor list from server
  getSponsorMethod() async {
    SponsorsRepo repo = SponsorsRepo();
    sponsorsList = await repo.getAllSponsors();

    homeViewSponsorList = sponsorsList
        .where((element) =>
            element?.sponsorType?.position?.toLowerCase() ==
            "Home"?.toLowerCase())
        ?.toList();
    exploreSponsorList = sponsorsList
        .where((element) =>
            element?.sponsorType?.position?.toLowerCase() ==
            "Explore"?.toLowerCase())
        ?.toList();
    searchSponsorList = sponsorsList
        .where((element) =>
            element?.sponsorType?.position?.toLowerCase() ==
            "Search"?.toLowerCase())
        ?.toList();
    update();
  }

  /// This field contains sponsor list
  List<SponsorData> sponsorsList = [];

  /// This field contains sponsor list for [Dashboard]
  List<SponsorData> homeViewSponsorList = [];

  /// This field contains sponsor list for [ExplorePage]
  List<SponsorData> exploreSponsorList = [];

  /// This field contains sponsor list for [SearchPage]
  List<SponsorData> searchSponsorList = [];
}
