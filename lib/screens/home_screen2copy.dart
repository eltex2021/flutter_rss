// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'dart:io' as io;
// import 'package:webfeed/webfeed.dart';
// import 'package:flutter_rss/common/fetch_http.dart';
// import 'dart:convert';
//
//
//
//
// class HomeScreenRSS extends StatefulWidget {
//   @override
//   _HomeScreenRSSState createState() => _HomeScreenRSSState();
// }
//
// class _HomeScreenRSSState extends State {
//   bool _darkTheme = false;
//   List _habsList = [];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: !_darkTheme ? ThemeData.light() : ThemeData.dark(),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Парсер хабр 1"),
//           actions: [
//             Icon(_getAppBarIcon()),
//             _getPlatformSwitch(),
//           ],
//         ),
//         body: FutureBuilder(
//           future: _getHttpHabs(),
//           builder: (context, AsyncSnapshot snapshot) {
//             if (!snapshot.hasData) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else {
//               return Container(
//                 child: ListView.builder(
//                     scrollDirection: Axis.vertical,
//                     itemCount: _habsList.length,
//                     itemBuilder: (
//                       BuildContext context,
//                       int index) {
//                       return Card(
//                         child: Container(
//                           child: Column(
//                           //  children:[Text('привет')],
//                            children:[Text('${_habsList[index].title}')],
//                           ),
//                         ),
//                       );
//                     }),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   _getAppBarIcon() {
//     if (_darkTheme) {
//       return Icons.lightbulb_outline;
//     } else {
//       return Icons.highlight;
//     }
//   }
//
//   _getPlatformSwitch() {
//     if (io.Platform.isIOS) {
//       return CupertinoSwitch(
//         value: _darkTheme,
//         onChanged: (bool value) {
//           setState(() {
//             _darkTheme = !_darkTheme;
//           });
//         },
//       );
//     } else if (io.Platform.isAndroid) {
//       return Switch(
//         value: _darkTheme,
//         onChanged: (bool value) {
//           setState(() {
//             _darkTheme = !_darkTheme;
//           });
//         },
//       );
//     }
//   }
//
//   _getHttpHabs() async {
//     var response = await fetchHttpHabs('https://habr.com/ru/rss/hubs/all/');
//     var chanel = RssFeed.parse(response.body);
//     chanel.items.forEach((element) {
//       _habsList.add(element);
//     });
//   return _habsList;
//   }
// }
