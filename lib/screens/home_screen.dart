import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rss/screens/read_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' as io;
import 'package:webfeed/webfeed.dart';
import 'package:flutter_rss/common/fetch_http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class HomeScreenRSS extends StatefulWidget {
  @override
  _HomeScreenRSSState createState() => _HomeScreenRSSState();
}

class _HomeScreenRSSState extends State {
  bool _darkTheme = false;
  List _productsList = [];

  @override
  void initState() {
    super.initState();
    _setTheme();

    //print("TEST");
  }

  _setTheme() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_prefs.getBool("darkTheme") != null) {
        _darkTheme = _prefs.getBool("darkTheme");
      } else {
        _darkTheme = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: !_darkTheme ? ThemeData.light() : ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Парсер Фути-Бьюти"),
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
                    padding: EdgeInsets.only(
                        left: 10.0, top: 10.0, right: 10.0, bottom: 20.0),
                    scrollDirection: Axis.vertical,
                    itemCount: _productsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                            children: [
                              Text(
                                //'${_habsList[index].title}',  // было так, но переделал без знака $
                                //_habsList[index].title, // так вроде правильнее но не та кодировка
                                utf8.decode(latin1
                                    .encode(_productsList[index].title.toString())),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                //child: Text("${parseDescription(_habsList[index].description)}",),
                                //child: Image(image: NetworkImage("https://xn----btbtc0cdch1fua.xn--p1ai/image/cache/catalog/pen-mas-el-500x500.jpg"),),
                                //child: Image(image: NetworkImage("${_habsList[index].image_link}"),),
                                //child: Image(image: NetworkImage("${_habsList[index].img_prod}"),),
                                //child: Image(image: NetworkImage("${_habsList[index].image}"),),
                                child: Image(
                                  image: NetworkImage(_productsList[index].author),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                //"${parseDescription(_habsList[index].description)}",

                                utf8.decode(latin1
                                    .encode(_productsList[index].description)),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // Text(
                              //   utf8.decode(latin1
                              //       .encode(_habsList[index].price)),
                              //   style: TextStyle(
                              //     fontSize: 16,
                              //     fontWeight: FontWeight.normal,
                              //   ),
                              // ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(DateFormat('dd.MM.yy HH:mm')
                                      .format(DateTime.now())),
                                  //вместо нормальной даты публикации реальное время
                                  //Text(DateFormat('dd.MM.yy HH:mm').format(DateTime.parse('${_habsList[index].pubdate}'))), не заработало(((
                                  FloatingActionButton.extended(
                                    heroTag: null,
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          //builder: (context) => ReadScreen(urlHab: "${_habsList[index].guid}",),
                                          builder: (context) => ReadScreen(
                                            urlHab: "${_productsList[index].link}",
                                            urlImage:
                                                "${_productsList[index].author}",
                                            descr:
                                                "${_productsList[index].description}",
                                          ),
                                        )),
                                    label: Text("Подробнее"),
                                    icon: Icon(Icons.arrow_forward),
                                  )
                                ],
                              ),
                            ],
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
            _saveTheme();
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
    var response = await fetchHttpFuti(Uri.parse(
        'https://xn----btbtc0cdch1fua.xn--p1ai/ocext_google_feed_newrss.xml'));
        //'https://xn----btbtc0cdch1fua.xn--p1ai/index.php?route=extension/feed/ocext_feed_generator_google&token=80993'));

    var chanel = RssFeed.parse(response.body);
    chanel.items.forEach((element) {
      _productsList.add(element);
    });

    return _productsList;
  }

  _saveTheme() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setBool("darkTheme", _darkTheme);
  }
}
