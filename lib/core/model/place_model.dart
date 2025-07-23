class Place {
  final String name;
  final String description;
  final String location;
  final double price;
  final String contact;
  final String imageUrl;
  final String commissionerId;

  Place({
    required this.name,
    required this.description,
    required this.location,
    required this.price,
    required this.contact,
    required this.imageUrl,
    required this.commissionerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'location': location,
      'price': price,
      'contact': contact,
      'imageUrl': imageUrl,
      'commissionerId': commissionerId,
    };
  }

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      name: map['name'],
      description: map['description'],
      location: map['location'],
      price: (map['price'] as num).toDouble(),
      contact: map['contact'],
      imageUrl: map['imageUrl'],
      commissionerId: map['commissionerId'],
    );
  }
}
