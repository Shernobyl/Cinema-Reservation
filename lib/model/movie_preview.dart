class MoviePreview {
  final String id;
  final String title;
  final String? imageUrl;
  final String year;
  final String startDate;
  final String endDate;
  final List<bool> seats;
  final String screeningRoom;
  String overview;

  MoviePreview(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.year,
      required this.overview,
      required this.startDate,
      required this.endDate,
      required this.seats,
      required this.screeningRoom});
}
