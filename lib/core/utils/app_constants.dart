class AppConstants {
  static const String appName = 'My Clean Architecture App';
  static const int apiTimeoutDuration = 30; // in seconds

  // Commonly used URLs
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Regular expressions for validation
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';



  static const String basePath = 'assets/images/';
  static const String baseAnimation = 'assets/animations/';
  static const String filmoxLogo = '${basePath}logo.png';

  static const String loginLoadingDialogAnimation = '${baseAnimation}login_loading.json';
  static const String dialogLoading = '${baseAnimation}dialogLoading.json';

  static String digiTheaterSingle = "${basePath}singlemediaupload.jpg";
  static String digiTheaterMultiple = "${basePath}multiple.jpg";
  static String digiTheaterTrailer = "${basePath}trailer.jpg";
  static String digitalTheaterDrawerIcon = "${basePath}digitalTheaterDrawerIcon.png";
  static String jobsDrawerIcon = "${basePath}jobsdrawerIcon.png";
  static String mediaDrawerIcon = "${basePath}mediaDrawerIcon.png";


  static String digiSeries = "${basePath}series.jpeg";
  static String digiMovie = "${basePath}movies.jpeg";
  static String noEpisodes = "${baseAnimation}no_data.json";

  static String videouploading = "${baseAnimation}video_uploading.json";
  static String uploadIcon = "${basePath}upload.png";
  static String successVideoUpload =
      "${baseAnimation}video_uploaded_success.json";

  static String allIcon = '${basePath}all_icon.png';
  ///Contest
  static String nextAnimation = "${baseAnimation}next.json";
  static String votedLottie = "${baseAnimation}votes_lottie.json";
  static String no_result = "${baseAnimation}no_result.json";


}


