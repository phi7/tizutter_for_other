// タイムラインに表示するために渡す型
// pinIDと時間、コメント、写真だけ渡す
class PinInfoForTimeline {
  PinInfoForTimeline(this.pid,this.time,this.comment,this.imgURL);
  String pid;
  String comment;
  String imgURL;
  DateTime time;
}
