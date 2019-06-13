import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:to_do_flutter/db/AppDatabase.dart';

void main() {
  test('database should connect', () async {
    Database dbInstance = await AppDatabase.db.instance;
    expect(dbInstance.isOpen, true);
  });
}