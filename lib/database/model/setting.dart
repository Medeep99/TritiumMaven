import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(
  tableName: 'setting',
  primaryKeys: [
    'id',
  ],
)
class Setting extends Equatable {
  const Setting({
    required this.id,
    required this.languageCode,
    required this.countryCode,
    required this.themeId,
    required this.username,
    required this.description,
  });

  @PrimaryKey()
  final int id;

  @ColumnInfo(name: 'language_code')
  final String languageCode;

  @ColumnInfo(name: 'country_code')
  final String countryCode;

  @ColumnInfo(name: 'theme_id')
  final int themeId;

  @ColumnInfo(name: 'username')
  final String username;

  @ColumnInfo(name: 'description')
  final String description;

  Setting copyWith({
    int? id,
    String? languageCode,
    String? countryCode,
    int? themeId,
    String? username,
    String? description,
  }) {
    return Setting(
      id: id ?? this.id,
      languageCode: languageCode ?? this.languageCode,
      countryCode: countryCode ?? this.countryCode,
      themeId: themeId ?? this.themeId,
      username: username ?? this.username,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
        id,
        languageCode,
        countryCode,
        themeId,
        username,
        description,
      ];
}
