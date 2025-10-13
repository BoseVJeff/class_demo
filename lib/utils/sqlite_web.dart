import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';
import 'package:sqlite3/wasm.dart';

Future<CommonSqlite3> loadSqlite() async {
  final sqlite = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
  final fileSystem = await IndexedDbFileSystem.open(dbName: 'my_app');
  sqlite.registerVirtualFileSystem(fileSystem, makeDefault: true);
  return sqlite;
}

Future<CommonDatabase> loadDatabase(XFile xfile) async {
  print("Setting up VFS...");
  String name = "/database";
  final sqlite = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
  // final fileSystem = await IndexedDbFileSystem.open(dbName: name);
  final VirtualFileSystem fileSystem = InMemoryFileSystem();
  sqlite.registerVirtualFileSystem(fileSystem, makeDefault: true);

  // print("Opening file...");
  final openResult = fileSystem.xOpen(
    Sqlite3Filename(name),
    SqlFlag.SQLITE_OPEN_CREATE | SqlFlag.SQLITE_OPEN_READWRITE,
  );
  // print("Writing data to file...");
  openResult.file.xWrite(await xfile.readAsBytes(), 0);
  // print("Syncing/Flushing file data...");
  openResult.file.xSync(
    SqlFlag.SQLITE_OPEN_CREATE | SqlFlag.SQLITE_OPEN_READWRITE,
  );
  openResult.file.xClose();
  // print("Written ${openResult.file.xFileSize()} to file");

  print("Opening database...");
  return sqlite.open(name, mode: OpenMode.readOnly);
}
