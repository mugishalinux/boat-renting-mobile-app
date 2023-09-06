class BoatData {
  final int id;
  final int price;
  final int maxNumber;
  final List<String> boatImages;
  final String serialNumber;

  BoatData(
      {required this.id,
      required this.price,
      required this.maxNumber,
      required this.boatImages,required this.serialNumber,});

  factory BoatData.fromJson(Map<String, dynamic> json) {
    return BoatData(
      id: json['id'],
      price: json['price'],
      maxNumber: json['maxNumber'],
      boatImages: json['boatImages'].toString().split(','),
      serialNumber: json['serialNumber'],
    );
  }
}
