import 'package:cross_file/cross_file.dart';
import 'package:sqlite3/common.dart';
import 'package:sqlite3/sqlite3.dart';

Future<CommonSqlite3> loadSqlite() async {
  return sqlite3;
}

Future<CommonDatabase> loadDatabase(CommonSqlite3 sqlite, XFile xfile) async {
  return sqlite3.open(xfile.path, mode: OpenMode.readOnly);
}
