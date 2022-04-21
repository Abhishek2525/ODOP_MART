import '../../api/app_urls.dart';
import '../../api/http_request.dart';
import '../../models/sponsor_model.dart';

/// A utility class that provide a method [getAllSponsors]
/// to sponsors from server
class SponsorsRepo {
  /// get all sponsors from server
  Future<List<SponsorData>> getAllSponsors() async {
    try {
      Map<String, dynamic> res = await HttpHelper.get(AppUrls.sponsorUrl);
      if (res == null) return [];
      if (res.isEmpty) return [];

      SponsorModel m = SponsorModel.fromJson(res);
      return m?.data ?? [];
    } catch (e) {
      return [];
    }
  }
}
