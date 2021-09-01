import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

fetchHttpFuti(url) {
  var client = http.Client();
  return client.get(url);
}

//для попытки спарсить фото товара
parseImage_link(image_link) {
  image_link = parse(image_link);
  var txtimage_link = parse(image_link.body.text).documentElement.text;
  return txtimage_link;
}

parseGtin(gtin) {
  gtin = parse(gtin);
  var txtgtin = parse(gtin.body.text).documentElement.text;
  return txtgtin;
}
