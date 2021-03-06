import 'package:rescado/src/data/models/image.dart';
import 'package:rescado/src/data/models/shelter.dart';

enum AnimalKind {
  dog,
  cat,
}

enum AnimalSex {
  male,
  female,
}

class Animal {
  final int id;
  final AnimalKind kind;
  final String breed;
  final String name;
  final String description;
  final AnimalSex sex;
  final DateTime birthday;
  final int weight;
  final bool vaccinated;
  final bool sterilized;
  final String availability;
  final List<Image> photos;
  final Shelter shelter;

  int get age {
    final diff = DateTime.now().difference(birthday);
    return diff.inDays ~/ 365;
  }

  Animal._({
    required this.id,
    required this.kind,
    required this.breed,
    required this.name,
    required this.description,
    required this.sex,
    required this.birthday,
    required this.weight,
    required this.vaccinated,
    required this.sterilized,
    required this.availability,
    required this.photos,
    required this.shelter,
  });

  factory Animal.fromJson(Map<String, dynamic> json) => Animal._(
        id: json['id'] as int,
        kind: AnimalKind.values.byName((json['kind'] as String).toLowerCase()),
        breed: json['breed'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        sex: AnimalSex.values.byName((json['sex'] as String).toLowerCase()),
        birthday: DateTime.parse(json['birthday'] as String),
        weight: json['weight'] as int,
        vaccinated: json['vaccinated'] as bool,
        sterilized: json['sterilized'] as bool,
        availability: json['availability'] as String,
        photos: (List<Map<String, dynamic>>.from(json['photos'] as List)).map((photo) => Image.fromJson(photo)).toList(),
        shelter: Shelter.fromJson(json['shelter'] as Map<String, dynamic>),
      );
}
