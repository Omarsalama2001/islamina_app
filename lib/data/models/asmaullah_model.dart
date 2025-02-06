class AsmaullahModel {
  int? id;
  String? ttl;
  String? dsc;
  String? fontCode;

  AsmaullahModel({this.id, this.ttl, this.dsc,this.fontCode});

  AsmaullahModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ttl = json['name'];
    dsc = json['text'];
    fontCode = json['color_font_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = ttl;
    data['text'] = dsc;
    data['color_font_id'] = fontCode;
    return data;
  }
}
