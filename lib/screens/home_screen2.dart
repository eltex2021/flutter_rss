import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' as io;
import 'package:xml_parser/xml_parser.dart';


//пробую парсить xml!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

class HomeScreenRSS2 extends StatefulWidget {
  @override
  _HomeScreenRSSState createState() => _HomeScreenRSSState();
}

class _HomeScreenRSSState extends State {
  bool _darkTheme = false;
  List _productsList = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: !_darkTheme ? ThemeData.light() : ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Парсер"),
          actions: [
            Icon(_getAppBarIcon()),
            _getPlatformSwitch(),
          ],
        ),
        body: FutureBuilder(
          future: _getHttp(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _productsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Container(
                          child: Column(
                            //  children:[Text('привет')],
                            children: [Text('${_productsList[index].title}')],
                          ),
                        ),
                      );
                    }),
              );
            }
          },
        ),
      ),
    );
  }

  _getAppBarIcon() {
    if (_darkTheme) {
      return Icons.lightbulb_outline;
    } else {
      return Icons.highlight;
    }
  }

  _getPlatformSwitch() {
    if (io.Platform.isIOS) {
      return CupertinoSwitch(
        value: _darkTheme,
        onChanged: (bool value) {
          setState(() {
            _darkTheme = !_darkTheme;
          });
        },
      );
    } else if (io.Platform.isAndroid) {
      return Switch(
        value: _darkTheme,
        onChanged: (bool value) {
          setState(() {
            _darkTheme = !_darkTheme;
          });
        },
      );
    }
  }




  _getHttp() async {
    XmlDocument xmlDocument =
    await XmlDocument.fromUri(
        'https://xn----btbtc0cdch1fua.xn-');

    return _productsList;
    }
}
