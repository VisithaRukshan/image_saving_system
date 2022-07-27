class Image {
  int? id;
  String? name;
  String? image;
  bool isSelected = false;

  Image.initial()
      : name = '',
        image = '';

  Image({
    this.id,
    this.name,
    this.image,
  });

  Image.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['image'] = image;
    return map;
  }
}
