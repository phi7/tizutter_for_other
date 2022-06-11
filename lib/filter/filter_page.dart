import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:informaiton_systems/domain/filterInfo.dart';
import 'package:informaiton_systems/filter/filter_model.dart';
import 'package:latlng/latlng.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import '../constants/gender.dart';
import '../main.dart';


class FilterPage extends StatelessWidget {
  FilterInfo filterInfo;
  FilterPage(this.filterInfo);

  @override
  Widget build(BuildContext context) {
    print("made filterPage");
    return ChangeNotifierProvider<FilterModel>(
        create: (_) => FilterModel(filterInfo),
        child: Scaffold(
          appBar: AppBar(
            title: Text("ピンを検索"),
          ),
          body: Center(
            child: Consumer<FilterModel>(builder: (context, model, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    !model.detailSetting ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("直近"),
                        TextButton(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1.0),
                              ),
                            ),
                            child:  Text(DateFormat('hh時間mm分').format(model.displayDuration)),
                          ),
                          onPressed: () async{
                            DatePicker.showTimePicker(context,
                                showSecondsColumn: false,
                                currentTime: model.displayDuration,
                                onConfirm: model.displayDurationOnChanged
                            );
                          },
                        ),
                        Text("のピンを表示")
                      ],
                    ) : Text(""),
                    OutlinedButton.icon(
                        onPressed: model.detailSettingOnChange,
                        icon: Icon(model.detailSetting ? Icons.expand_less : Icons.expand_more),
                        label: Text("詳細設定")
                    ),

                    model.detailSetting ? SwitchListTile(
                        title: Text("終日", style: TextStyle(fontSize: 20),),
                        value: model.allDay,
                        onChanged: model.alldayOnChange
                    ) : Text(""),
                    model.detailSetting ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("開始"),
                        TextButton(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1.0),
                              ),
                            ),
                            child: Text(DateFormat('yyyy年M月d日').format(model.startDate)),
                          ),
                          onPressed: () async{
                            DateTime? d = await showDatePicker(
                              context: context,
                              initialDate: model.startDate,
                              firstDate: DateTime(1900, 1, 1),
                              lastDate: DateTime(2049, 12, 31),
                            );
                            if(d != null) {
                              model.startDateOnChanged(d);
                            }
                          },
                        ),
                        !model.allDay ? TextButton(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1.0),
                              ),
                            ),
                            child: Text(DateFormat('hh:mm').format(model.startDate)),
                          ),
                          onPressed: () async{
                            TimeOfDay? t = await showTimePicker(
                              context: context,
                              initialTime: new TimeOfDay(hour: model.startDate.hour, minute: model.startDate.minute),
                            );
                            if(t != null){
                              model.endTimeOnChanged(t);
                            }
                          },
                        ) : SizedBox(width: 64,)
                      ],
                    ) : Text(""),
                    model.detailSetting ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("終了"),
                        TextButton(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1.0),
                              ),
                            ),
                            child: Text(DateFormat('yyyy年M月d日').format(model.endDate)),
                          ),
                          onPressed: () async{
                            DateTime? d = await showDatePicker(
                              context: context,
                              initialDate: model.endDate,
                              firstDate: DateTime(1900, 1, 1),
                              lastDate: DateTime(2049, 12, 31),
                            );
                            if(d != null){
                              model.endDateOnChanged(d);
                            }else{
                              print("null");
                            }
                          },
                        ),
                        !model.allDay ? TextButton(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1.0),
                              ),
                            ),
                            child: Text(DateFormat('hh:mm').format(model.endDate)),
                          ),
                          onPressed: () async{
                            TimeOfDay? t = await showTimePicker(
                              context: context,
                              initialTime: new TimeOfDay(hour: model.endDate.hour, minute: model.endDate.minute),
                            );
                            if(t != null){
                              print(t);
                              model.startTimeOnChanged(t);
                            }else{
                              print("null");
                            }
                          },
                        ) : SizedBox(width: 64,)
                      ],
                    ) : Text(""),
                    model.detailSetting ? SizedBox(
                      height: 16,
                    ) : Text(""),
                    model.detailSetting ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Male"),
                        Checkbox(value: model.getMale, onChanged: model.maleOnChange),
                        Text("Female"),
                        Checkbox(value: model.getFemale, onChanged: model.femaleOnChange),
                        Text("Other"),
                        Checkbox(value: model.getOther, onChanged: model.otherOnChange),
                      ],
                    ) : Text(""),
                    model.detailSetting ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("年代"),
                        NumberPicker(
                          minValue: 0,
                          maxValue: 120,
                          value: model.minAge,
                          onChanged: model.minAgeOnChanged,
                        ),
                        Text("才～"),
                        NumberPicker(
                          minValue: 0,
                          maxValue: 120,
                          value: model.maxAge,
                          onChanged: model.maxAgeOnChanged,
                        ),
                        Text("才"),
                      ],
                    ) : Text(""),
                    const SizedBox(
                      height: 16,
                    ),
                    OutlinedButton(
                      // onPressed: null,
                        onPressed: () async {
                          final filter = model.makeFilter();
                          Navigator.of(context).pop(filter);
                        },
                        child: Text("検索")),
                  ],
                ),
              );
            }),
          ),
        )
    );
  }
}
