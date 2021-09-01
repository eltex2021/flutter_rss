import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:flutter_rss/common/fetch_http.dart';
import 'package:flutter_rss/model/product_model.dart';
import 'dart:convert';

class ReadScreen extends StatefulWidget {
  final urlHab;
  final urlImage;
  final descr;
  final price;
  double price2;
  int amount;

  ReadScreen({@required this.urlHab, this.urlImage, this.descr, this.price});

  @override
  _ReadScreenState createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  var _prodModel = Product();

  num get amount => 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Парсер Данных товара'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _getProd());
  }

  _getProd() {
    return FutureBuilder(
      future: _getHttp(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            padding: EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10.0, bottom: 40.0),
            children: [
              Text(
                '${_prodModel.title}',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.0,
              ),
              Column(
                children: [
                  Image(
                    image: NetworkImage("${_prodModel.image}"),
                  ),

                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Цена " +
                    ("${double.tryParse(_prodModel.price) * amount}") +
                    " Руб.",
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                '${_prodModel.descr}',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
              ),
            ],
          );
        }
      },
    );
  }

  _getHttp() async {
    var response = await fetchHttpFuti(widget.urlHab);
    var _hab = parse(response.body);
    _prodModel.title =
        _hab.getElementsByClassName("breadcrumb")[0].children[3].text;

    String a = _hab.getElementsByClassName("priceproduct-new")[0].text;
    List<String> priceTextList = a.split(".");
    String firstprice = priceTextList[0].replaceAll(" ", "");

    var price2 = double.tryParse(firstprice);

    print(price2 * amount);

    _prodModel.price = firstprice;

    // print(_hab.getElementsByClassName("tab-pane active")[0].children[0].text); // описание товара
    // print(_hab.getElementsByClassName("priceproduct-new")[0].text); // цена товара
    //print(_hab.getElementsByClassName("line-product")[0].text); // цены и фраза нашли дешевле
    //print(_hab.getElementsByClassName("line-product")[0].text);
    //print(_hab.getElementsByClassName("zoomLens")[0].text);
    //print(_hab.getElementsByClassName("thumbnail imglink")[0].innerHtml);
    //print(_hab.getElementsByClassName("thumbnail imglink")[0].text);
    // print(_hab.getElementsByClassName("thumbnail imglink")[0].children[0].namespaceUri);
    // print(_hab.getElementsByClassName("thumbnails")[0].children[1].text);
    // print(_hab.getElementsByClassName("thumbnails")[0]);
    // print(_hab.getElementsByClassName("thumbnails")[0]);
    // print(_hab.getElementsByClassName("cart")[0].text);
    // print(_hab.getElementsByTagName("h1")[0].text);  // смогли найти по тэгу текст H1!!!!!!!!!!!!!!!

    _prodModel.body =
        _hab.getElementsByClassName("tab-pane active")[0].children[0].text;

    _prodModel.hab_url = widget.urlHab;
    _prodModel.image = widget.urlImage;
    _prodModel.descr = utf8.decode(latin1.encode(widget.descr.toString()));

    return _prodModel;
  }
}
