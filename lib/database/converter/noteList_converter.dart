import 'dart:convert';
import 'package:floor/floor.dart';
import 'package:maven/database/table/note.dart';
import 'package:maven/feature/transfer/data/data.dart'; // Import the Note class

 class NoteListConverter extends TypeConverter<List<Note>, String> {
  // Convert List<Note> to JSON string
  @override
  String toSql(List<Note> value) {
    return jsonEncode(value.map((note) => note.toJson()).toList());
  }

  // Convert JSON string back to List<Note>
  @override
  List<Note> fromSql(String dbValue) {
    final List<dynamic> decoded = jsonDecode(dbValue);
    return decoded.map((noteJson) => Note.fromJson(noteJson)).toList();
  }
  
  @override
  List<Note> decode(String databaseValue) {
    // TODO: implement decode
    throw UnimplementedError();
  }
  
  @override
  String encode(List<Note> value) {
    // TODO: implement encode
    throw UnimplementedError();
  }
}
