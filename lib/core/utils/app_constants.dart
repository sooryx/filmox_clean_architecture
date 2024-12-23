class AppConstants {
  // Regular Expressions
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';

  // Base Paths
  static const String basePath = 'assets/images/';
  static const String baseAnimation = 'assets/animations/';

  // Logos
  static const String filmoxLogo = '${basePath}logo.png';

  // Loading Animations
  static const String loginLoadingDialogAnimation = '${baseAnimation}login_loading.json';
  static const String dialogLoading = '${baseAnimation}dialogLoading.json';
  static const String noEpisodes = '${baseAnimation}no_data.json';
  static const String videoUploading = '${baseAnimation}video_uploading.json';
  static const String successVideoUpload = '${baseAnimation}video_uploaded_success.json';

  // Icons
  static const String uploadIcon = '${basePath}upload.png';
  static const String allIcon = '${basePath}all_icon.png';

  // Digital Theater Images
  static const String digiTheaterSingle = '${basePath}singlemediaupload.jpg';
  static const String digiTheaterMultiple = '${basePath}multiple.jpg';
  static const String digiTheaterTrailer = '${basePath}trailer.jpg';
  static const String digitalTheaterDrawerIcon = '${basePath}digitalTheaterDrawerIcon.png';
  static const String jobsDrawerIcon = '${basePath}jobsdrawerIcon.png';
  static const String mediaDrawerIcon = '${basePath}mediaDrawerIcon.png';
  static const String gamesDrawerIcon = '${basePath}games.png';

  // Series and Movies
  static const String digiSeries = '${basePath}series.jpeg';
  static const String digiMovie = '${basePath}movies.jpeg';

  // Contest Animations
  static const String nextAnimation = '${baseAnimation}next.json';
  static const String votedLottie = '${baseAnimation}votes_lottie.json';
  static const String noResult = '${baseAnimation}no_result.json';

  // Error Screens
  static const String mainError = '${basePath}error_main.png';

  // Miscellaneous Images
  static const String scareCrow = '${basePath}scarecrow.png';
  static const String joker = '${basePath}joker.png';
}
