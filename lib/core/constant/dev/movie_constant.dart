class MovieConstant {
  static List<String> movieList = [
    'assets/images/genre/621718.jpg',
    'assets/images/genre/520923.jpg',
    'assets/images/genre/674154.jpg',
    'assets/images/genre/674263.jpg',
    'assets/images/genre/684832.jpg',
    'assets/images/genre/689398.jpg',
    'assets/images/genre/690190.jpg',
    'assets/images/genre/692437.jpg',
    'assets/images/genre/701996.jpg',
    'assets/images/genre/718156.jpg',
  ];

  static String getMovie(int i) {
    return movieList[i % movieList.length];
  }
}
