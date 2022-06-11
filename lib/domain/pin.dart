class Pin{
  Pin(this.pinID,
      this.userID,
      this.posLat,
      this.posLng,
      this.time,
      this.like,
      this.comment,
      this.imgURL);
  String pinID;
  String userID;
  double posLat;
  double posLng;
  DateTime time;
  int like;
  String? comment;
  String? imgURL;
}