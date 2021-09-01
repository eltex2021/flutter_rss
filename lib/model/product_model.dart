class Product {
  String title;
  String hab_url;
  String body;
  String image;
  String gtin;
  String descr;
  var price;

  Product({this.title, this.hab_url, this.body, this.image, this.gtin, this.descr, this.price
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'hab_url': hab_url,
        'body': body,
        'image': image,
        'gtin': gtin,
        'descr': descr,
        'price': price,

      };

  Product.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        hab_url = json['hab_url'],
        body = json['body'],
        image = json['image'],
        gtin = json['gtin'],
        descr = json['descr'],
        price = json['price']
  ;
}
