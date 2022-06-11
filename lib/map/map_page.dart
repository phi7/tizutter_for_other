import 'dart:async';
import 'package:flutter/material.dart';
import 'package:informaiton_systems/domain/filterInfo.dart';
import 'package:informaiton_systems/domain/pin.dart';
import 'package:informaiton_systems/filter/filter_page.dart';
import 'package:location/location.dart';

// import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../post/post_page.dart';
import 'map_model.dart';

class MapPage extends StatelessWidget {
  FilterInfo filter;
  MapPage(this.filter);
  // 現在位置
  LocationData? yourLocation;
  Function? lookAt = null;
  GoogleMap? googleMap;

  void setFilter(FilterInfo filterInfo){
    filter = filterInfo;
  }
  Function? rewrite;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapPageModel>(
        create: (_) => MapPageModel()..locationListen()..getLocationForApp(),
        child: Consumer<MapPageModel>(builder: (context, model, child) {
          rewrite ??= ()async{
            var map = await model.controller.future;
            var bounds = await map.getVisibleRegion();
            List<Pin> pinList =
                await model.fetchPinList(filter, bounds);
            model.addMarker(pinList, context);
            print("rewrite map");
          };
          if(model.yourLocation!=null&&googleMap==null){
            print("make googleMap");
            googleMap = GoogleMap(
              // 初期表示される位置情報を現在位置から設定
              initialCameraPosition: CameraPosition(
                target: LatLng(model.yourLocation!.latitude!,
                    model.yourLocation!.longitude!),
                zoom: 15.0,
              ),
              markers: model.markers,
              onMapCreated: (GoogleMapController controller) {
                model.controller.complete(controller);
              },
              myLocationEnabled: true,
              // onCameraMove: null,
            );
          }
          lookAt ??= (Pin pin, FilterInfo filter) async{
              var camera = await model.controller.future;
              camera.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(pin.posLat,pin.posLng),
                zoom: 15,
              )));
              LatLngBounds bounds = await camera.getVisibleRegion();
              List<Pin> pinList = await model.fetchPinList(filter, bounds);
              model.addMarker(pinList, context);
            };
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('Home'),
              actions: [
                // 再読み込み
                IconButton(
                  onPressed: () async {
                    print("marker renew");
                    var map = await model.controller.future;
                    var bounds = await map.getVisibleRegion();
                    List<Pin> pinList =
                        await model.fetchPinList(filter, bounds);
                    model.addMarker(pinList, context);
                  },
                  icon: Icon(Icons.autorenew),
                ),
                // 検索
                IconButton(
                    onPressed: () async {
                      print("search start");
                      filter = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FilterPage(filter),
                          ));
                      setFilter(filter);
                      print(filter == null
                          ? "filter is null"
                          : "get filter succeed");
                      print(filter.startDate.toString());
                      var map = await model.controller.future;
                      var bounds = await map.getVisibleRegion();
                      List<Pin> pinList =
                          await model.fetchPinList(filter, bounds);
                      print("get pinList");
                      model.addMarker(pinList, context);
                      print("add marker");
                    },
                    icon: Icon(Icons.search))
              ],
            ),
            body: Center(
                child: model.yourLocation != null
                    ? googleMap
                    : const CircularProgressIndicator()),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostPage(model.yourLocation),
                        fullscreenDialog: true));
                model.notifyListeners();
              },
              //   await postPageDialog(context);},
              child: Icon(Icons.post_add),
            ),
          );
        }));
  }
}
