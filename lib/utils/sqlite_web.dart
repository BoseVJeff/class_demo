import 'package:cross_file/cross_file.dart';
import 'package:sqlite3/wasm.dart';

Future<CommonSqlite3> loadSqlite() async {
  final sqlite = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
  return sqlite;
}

String _name = "/database";
// final VirtualFileSystem _fileSystem = InMemoryFileSystem();

Future<CommonDatabase> loadDatabase(CommonSqlite3 sqlite, XFile xfile) async {
  print("Setting up VFS...");
  final VirtualFileSystem _fileSystem = await IndexedDbFileSystem.open(
    dbName: _name,
  );
  sqlite.registerVirtualFileSystem(_fileSystem, makeDefault: true);

  // print("Opening file...");
  final openResult = _fileSystem.xOpen(
    Sqlite3Filename(_name),
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
  return sqlite.open(_name, mode: OpenMode.readOnly);
}
