
import 'package:floor/floor.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'user.dart';
import '../database.dart';

@dao
abstract class UserDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> add(User user);

  @Query('SELECT * FROM user WHERE name = :name')
  Future<User?> findByName(String name);

  @Query('SELECT COUNT(id) FROM user')
  Future<int?> countUsers();

  @Query('SELECT * FROM user')
  Future<List<User>> getAllUsers();
  
  @Query('SELECT * FROM user LIMIT 1')
  Future<User?> get();

  @update
  Future<int> modify(User user);

  @Query('DELETE FROM user')
  Future<void> remove();

  // Check if it's the user's first launch by checking user count
  Future<bool> isFirstLaunch() async {
    final count = await countUsers();
    print("total users:");
    print(count);
    if (count==0)
    return true;
    else
    return false;
  }
}
