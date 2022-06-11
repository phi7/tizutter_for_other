class FilterInfo {
  FilterInfo();
  DateTime duration = DateTime(0,0,0,3);
  bool detail = false;
  bool allDay = false;
  DateTime endDate = DateTime.now();
  DateTime startDate = DateTime.now().add(Duration(hours: -3));
  List genders = ["male", "female", "other"];
  int minAge = 0;
  int maxAge = 100;
  void setFilter(detail,duration,allDay,endDate,startDate,genders,minAge,maxAge){
    this.detail = detail;
    this.duration = duration;
    this.allDay = allDay;
    this.endDate = endDate;
    this.startDate = startDate;
    this.genders = genders;
    this.minAge = minAge;
    this.maxAge = maxAge;
  }
}