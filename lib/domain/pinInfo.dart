// マップに表示するために渡す型
// pinIDと緯度・経度、ピンの属性だけ渡す
class PinInfo {
  PinInfo(this.pid,this.latitude,this.longitude,this.withComment,this.withPicture);
  String pid;
  double latitude;
  double longitude;
  bool withComment;
  bool withPicture;
}
