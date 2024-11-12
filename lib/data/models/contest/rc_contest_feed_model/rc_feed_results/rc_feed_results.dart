import 'dart:convert';

RCLiveResults rcResultsFromJson(String str) {
  final rcResults = RCLiveResults.fromJson(json.decode(str));
  // Sort the laughRiotContest list based on totalVotes in ascending order
  rcResults.voteDetails.sort((a, b) => a.totalVotes.compareTo(b.totalVotes));
  return rcResults;
}

String rcResultsToJson(RCLiveResults data) => json.encode(data.toJson());

class RCLiveResults {
  List<VoteDetails> voteDetails;

  RCLiveResults({
    required this.voteDetails,
  });

  factory RCLiveResults.fromJson(Map<String, dynamic> json) => RCLiveResults(
    voteDetails: List<VoteDetails>.from(
      json["Laugh Riot Contest"].map((x) => VoteDetails.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "Laugh Riot Contest": List<dynamic>.from(
      voteDetails.map((x) => x.toJson()),
    ),
  };
}

class VoteDetails {
  String userName;
  dynamic userProfile;
  String media;
  String thumbnail;
  int totalVotes;

  VoteDetails({
    required this.userName,
    required this.userProfile,
    required this.media,
    required this.thumbnail,
    required this.totalVotes,
  });

  factory VoteDetails.fromJson(Map<String, dynamic> json) => VoteDetails(
    userName: json["user_name"],
    userProfile: json["user_profile"],
    media: json["media"],
    thumbnail: json["thumbnail"],
    totalVotes: json["total_votes"],
  );

  Map<String, dynamic> toJson() => {
    "user_name": userName,
    "user_profile": userProfile,
    "media": media,
    "thumbnail": thumbnail,
    "total_votes": totalVotes,
  };
}

