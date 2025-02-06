
import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import '../database.dart';

@Entity(
  tableName: 'user',
  primaryKeys: [
    'id',
  ],
)
class User extends Equatable {
  const User({
    required this.id,
    required this.username,
    required this.description,
    required this.gender,
    required this.height,
    required this.weight,
    required this.age,
    required this.createdAt,
    required this.picture,
  });

  User.base({
    this.id = 1000,
    this.username = 'John Doe',
    this.description = 'Weightlifter',
    this.gender = Gender.male,
    this.height = 5.10,
    this.weight = 75.0,
    this.age = 18,
    this.picture = " ",
  }) : createdAt = DateTime.now();

  @PrimaryKey(autoGenerate: true)
  @ColumnInfo(name: 'id')
  final int id;

  @ColumnInfo(name: 'username')
  final String username;

  @ColumnInfo(name: 'description')
  final String description;

  @ColumnInfo(name: 'gender')
  final Gender gender;

  @ColumnInfo(name: 'height')
  final double height;

  @ColumnInfo(name : 'weight')
  final double weight;

  @ColumnInfo(name: 'age')
  final int age;

  @ColumnInfo(name: 'created_at')
  final DateTime createdAt;

  @ColumnInfo(name: 'picture')
  final String picture;

  User copyWith({
   
    int? id,
    String? username,
    String? description,
    Gender? gender,
    double? height,
    double? weight,
    int? age,
    String?  picture ,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      description: description ?? this.description,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      createdAt: createdAt ?? this.createdAt,
      picture: picture ?? this.picture,
    );
  }

  @override
  List<Object?> get props => [
    id,
    username,
    description,
    gender,
    height,
    weight,
    age,
    createdAt,
    picture,
  ];
}

enum Gender { male, female }

extension GenderExtension on Gender {
  String toApiString() {
    return this.toString().split('.').last.toLowerCase();
  }
}
