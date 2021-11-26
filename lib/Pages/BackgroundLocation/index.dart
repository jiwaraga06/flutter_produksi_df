
import 'package:flutter/material.dart';
import 'package:background_location/background_location.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:location_permissions/location_permissions.dart';

// import 'file_manager.dart';
// import 'location_callback_handler';
// import 'location_service_repository.dart';

class BackgroundLocations extends StatefulWidget {
  const BackgroundLocations({Key? key}) : super(key: key);

  @override
  _BackgroundLocationsState createState() => _BackgroundLocationsState();
}

class _BackgroundLocationsState extends State<BackgroundLocations> {
  // Socket socket;
  var variableSocket = 'https://api2.sipatex.co.id:2053';
  String latitude = 'waiting...';
  String longitude = 'waiting...';
  String altitude = 'waiting...';
  String accuracy = 'waiting...';
  String bearing = 'waiting...';
  String speed = 'waiting...';
  String time = 'waiting...';
  void getCurrentLocation() {
    BackgroundLocation().getCurrentLocation().then((location) {
      print('This is current Location ' + location.toMap().toString());
    });
  }

  // void getBackLocation() async {
  //   IO.Socket socket = IO.io(
  //       'https://api2.sipatex.co.id:2053',
  //       IO.OptionBuilder()
  //           .setTransports(['websocket']) // for Flutter or Dart VM
  //           // disable auto-connection
  //           .setExtraHeaders({'foo': 'bar'}) // optional
  //           .build());
  //   // print('Location');
  //   // BackgroundLocation.setAndroidConfiguration(1000);
  //   BackgroundLocation.setAndroidNotification(
  //       title: 'Flutter Background Location',
  //       message: 'Flutter Notification Message');
  //   BackgroundLocation.startLocationService(distanceFilter: 5);
  //   BackgroundLocation.getLocationUpdates(
  //     (myLocation) => {
  //       print(myLocation.toMap().toString()),
  //       setState(() {
  //         var tgl = DateTime.now().day;
  //         var bln = DateTime.now().month;
  //         var thn = DateTime.now().year;
  //         var jam = DateTime.now().hour;
  //         var menit = DateTime.now().minute;
  //         var detik = DateTime.now().second;
  //         var dates = '$thn-$bln-$tgl $jam.$menit.$detik';
  //         socket.emit('test', {
  //           "barcode": 2020209016,
  //           "nama": 'Raga Puteraku Dermawan',
  //           "lat": myLocation.latitude.toString(),
  //           "lng": myLocation.longitude.toString(),
  //           "warna": 'red',
  //           "gender": 'l',
  //           'waktu': dates
  //         });
  //         latitude = myLocation.latitude.toString();
  //         longitude = myLocation.longitude.toString();
  //         accuracy = myLocation.accuracy.toString();
  //         altitude = myLocation.altitude.toString();
  //         bearing = myLocation.bearing.toString();
  //         speed = myLocation.speed.toString();
  //         time = DateTime.fromMillisecondsSinceEpoch(myLocation.time!.toInt())
  //             .toString();
  //       })
  //     },
  //   );
  // }

  void startLocationService() async {
    BackgroundLocator.initialize();
    final _isRunning = await BackgroundLocator.isServiceRunning();
    print(_isRunning);
  }

  void connectionSocket() {
    try {
      IO.Socket socket = IO.io(
          'https://api2.sipatex.co.id:2053',
          IO.OptionBuilder()
              .setTransports(['websocket']) // for Flutter or Dart VM
              // disable auto-connection
              .setExtraHeaders({'foo': 'bar'}) // optional
              .build());
      // IO.Socket socket = IO.io('https://api2.sipatex.co.id:2053');
      socket.onConnect((_) {
        print('connect');
      });
      socket.connect();
      socket.on('connect', (data) => {print('Socket Connect')});
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    connectionSocket();
    // BackgroundLocation.stopLocationService();
    // var timer = Timer(Duration(seconds: 2), () => {getBackLocation()});
    // timer.cancel();
    var tgl = DateTime.now().day;
    var bln = DateTime.now().month;
    var thn = DateTime.now().year;
    var jam = DateTime.now().hour;
    var menit = DateTime.now().minute;
    var detik = DateTime.now().second;
    var dates = '$thn-$bln-$tgl $jam.$menit.$detik';
    print(dates);
  }

  // @override
  // void dispose() {
  //   BackgroundLocation.stopLocationService();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Background Location'),
      ),
      body: ListView(
        children: [
          ElevatedButton(
              onPressed: connectionSocket, child: Text('koneksi Socket')),
          ElevatedButton(
              onPressed: getCurrentLocation,
              child: Text('Get Current Location')),
          ElevatedButton(
              onPressed: startLocationService,
              child: Text('Get Background Location')),
          Text('Latitude: ' + latitude, style: TextStyle(fontSize: 17)),
          Text('Longitude: ' + longitude, style: TextStyle(fontSize: 17)),
          Text('Altitude: ' + altitude, style: TextStyle(fontSize: 17)),
          Text('Accuracy: ' + accuracy, style: TextStyle(fontSize: 17)),
          Text('Bearing: ' + bearing, style: TextStyle(fontSize: 17)),
          Text('Speed: ' + speed, style: TextStyle(fontSize: 17)),
          Text('Time: ' + time, style: TextStyle(fontSize: 17)),
        ],
      ),
    );
  }
}
