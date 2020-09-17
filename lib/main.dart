import 'package:cuba_2/util.dart';
import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:cuba_2/util.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool _isEnabled = false;
  bool _isConnected = false;
  bool _isPrevEnabled = false;


  @override
  void initState() {
    WiFiForIoTPlugin.isEnabled().then((val) {
      if (val != null) {
        _isEnabled = val;
      }
    });

    WiFiForIoTPlugin.isConnected().then((val) {
      if (val != null) {
        _isConnected = val;
      }
    });

    super.initState();

  }

  Widget getWidgets() {
    WiFiForIoTPlugin.isConnected().then((val) =>
        setState(() {
          _isConnected = val;
        }));

    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: getButtonWidgetsForAndroid(),
        ),
      ),
    );
  }

  List<Widget> getButtonWidgetsForAndroid() {
    List<Widget> htPrimaryWidgets = List();

    htPrimaryWidgets.addAll(<Widget> [
      Text(Util.getData()),
    ]);

    WiFiForIoTPlugin.isEnabled().then((val) =>
        setState(() {
          _isEnabled = val;
        }));

    if (_isEnabled) {
      htPrimaryWidgets.addAll([
        SizedBox(height: 10),
        Text("Wifi Enabled"),
        RaisedButton(
          child: Text("Disable"),
          onPressed: () {
            WiFiForIoTPlugin.setEnabled(false);
          },
        ),
      ]);

      WiFiForIoTPlugin.isConnected().then((val) {
        if (val != null) {
          setState(() {
            _isConnected = val;
          });
        }
      });

      if (_isConnected) {
        htPrimaryWidgets.addAll(<Widget>[
          Text("Connected"),
          FutureBuilder(
              future: WiFiForIoTPlugin.getSSID(),
              initialData: "Loading..",
              builder: (BuildContext context, AsyncSnapshot<String> ssid) {
                return Text("SSID: ${ssid.data}");
              }),
          FutureBuilder(
              future: WiFiForIoTPlugin.getBSSID(),
              initialData: "Loading..",
              builder: (BuildContext context, AsyncSnapshot<String> bssid) {
                return Text("BSSID: ${bssid.data}");
              }),
          FutureBuilder(
              future: WiFiForIoTPlugin.getCurrentSignalStrength(),
              initialData: 0,
              builder: (BuildContext context, AsyncSnapshot<int> signal) {
                return Text("Signal: ${signal.data}");
              }),
          FutureBuilder(
              future: WiFiForIoTPlugin.getFrequency(),
              initialData: 0,
              builder: (BuildContext context, AsyncSnapshot<int> freq) {
                return Text("Frequency : ${freq.data}");
              }),
          FutureBuilder(
              future: WiFiForIoTPlugin.getIP(),
              initialData: "Loading..",
              builder: (BuildContext context, AsyncSnapshot<String> ip) {
                return Text("IP : ${ip.data}");
              }),
          RaisedButton(
            child: Text("Disconnect"),
            onPressed: () {
              WiFiForIoTPlugin.disconnect();
              if(!_isPrevEnabled) {
                WiFiForIoTPlugin.setEnabled(false);
              }
            },
          ),
        ]);
      } else {
        htPrimaryWidgets.addAll(<Widget>[
          Text("Disconnected"),
          Text("lagi"),
          Text("lagilagi"),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     RaisedButton(
          //       child: Text("Use WiFi"),
          //       onPressed: () {
          //         WiFiForIoTPlugin.forceWifiUsage(true);
          //       },
          //     ),
          //     RaisedButton(
          //       child: Text("Use 3G/4G"),
          //       onPressed: () {
          //         WiFiForIoTPlugin.forceWifiUsage(false);
          //       },
          //     ),
          //   ],
          // )
        ]);
      }


    } else {
      htPrimaryWidgets.addAll(<Widget>[
        SizedBox(height: 10),
        Text("Wifi Disabled"),
        RaisedButton(
          child: Text("Enable"),
          onPressed: () {
            setState(() {
              WiFiForIoTPlugin.setEnabled(true);
            });
          },
        ),
      ]);
    }

    htPrimaryWidgets.addAll(<Widget>[
      RaisedButton(
        child: Text("Connect to NiNe"),
        onPressed: () {
          _isPrevEnabled = _isEnabled;
          print("Connect to NiNe");
          setState(() {
            WiFiForIoTPlugin.connect("GreenFinderIOT",
                password: "0xadezcsw1",
                joinOnce: true,
                security: NetworkSecurity.WPA);
          });
        },
      ),
    ]
    );

    return htPrimaryWidgets;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: getWidgets(),
      ),
    );
  }
}
