import 'package:flutter_test/flutter_test.dart';
import 'package:iotflixcinema/core/models/sponsor_model.dart';
import 'package:iotflixcinema/core/repo/ads/sponsors_repo.dart';

void main() {
  test("sponsorsList", () async {
    SponsorsRepo repo = SponsorsRepo();

    List<SponsorData> list = await repo.getAllSponsors();

    print("Sponsors list len :-> ${list.length}");

    list.forEach((element) {
      print("action :-> ${element.action}");
    });

    expect(list.length != 0, true);
  });
}
