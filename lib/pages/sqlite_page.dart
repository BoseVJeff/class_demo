import 'package:equatable/equatable.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Row;
import 'package:flutter/services.dart';
import 'package:sqlite3/common.dart';
import 'package:class_demo/utils/sqlite_web.dart'
    if (dart.library.ffi) 'package:class_demo/utils/sqlite_ffi.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class SqlitePage extends StatelessWidget {
  const SqlitePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQLite"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed("/sqlite/code");
            },
            icon: Icon(Icons.code),
            tooltip: "View Code",
          ),
        ],
      ),
      body: const SqliteLoader(),
    );
  }
}

class SqliteLoader extends StatefulWidget {
  const SqliteLoader({super.key});

  @override
  State<SqliteLoader> createState() => _SqliteLoaderState();
}

class _SqliteLoaderState extends State<SqliteLoader> {
  late Future<CommonSqlite3> sqliteLoader;

  @override
  void initState() {
    super.initState();
    sqliteLoader = loadSqlite();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CommonSqlite3>(
      future: sqliteLoader,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text("Loading SQLite3 binary..."),
              ],
            ),
          );
        } else {
          if (snapshot.hasError) {
            print(snapshot.stackTrace!);
            return Center(child: Text(snapshot.error.toString()));
          } else if (!snapshot.hasData) {
            return Center(child: Text("No Data!"));
          } else {
            return SqliteExplore(sqlite3: snapshot.data!);
          }
        }
      },
    );
  }
}

class SqliteExplore extends StatefulWidget {
  final CommonSqlite3 sqlite3;
  const SqliteExplore({super.key, required this.sqlite3});

  @override
  State<SqliteExplore> createState() => _SqliteExploreState();
}

class _SqliteExploreState extends State<SqliteExplore> {
  CommonDatabase? _database;
  bool loadingDatabase = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _database?.dispose();
    super.dispose();
  }

  List<DatabaseTable> getTables() {
    if (_database == null) {
      return [];
    }
    CommonDatabase db = _database!;
    List<DatabaseTable> tables = [];

    ResultSet tablesResult;
    try {
      tablesResult = db.select(
        "SELECT name, sql FROM sqlite_master WHERE type='table'",
      );
    } on SqliteException catch (e, s) {
      print(e.message);
      if (kDebugMode) {
        print(e.explanation);
        print(s);
      }
      return [];
    }

    for (final Row row in tablesResult) {
      // Get column metadata
      ResultSet colResults = db.select("PRAGMA table_info(${row["name"]})");

      List<DbTableColumn> cols = [];

      for (var col in colResults) {
        cols.add(
          DbTableColumn(
            col["name"],
            col["type"],
            col["notnull"] == 1,
            col["pk"] == 1,
          ),
        );
      }

      // Get row counts
      int rowCnt;
      ResultSet rowCntResultSet = db.select(
        "SELECT count(*) AS cnt FROM ${row["name"]}",
      );
      rowCnt = rowCntResultSet.first["cnt"];

      tables.add(DatabaseTable(row["name"], row["sql"], cols, rowCnt));
    }

    return tables;
  }

  @override
  Widget build(BuildContext context) {
    if (_database == null) {
      return Center(
        child: FilledButton.icon(
          onPressed: loadingDatabase
              ? null
              : () async {
                  setState(() {
                    loadingDatabase = true;
                  });
                  final XFile? file = await openFile();
                  if (file != null) {
                    loadDatabase(widget.sqlite3, file).then((value) {
                      setState(() {
                        loadingDatabase = false;
                        _database = value;
                      });
                    });
                  }
                },
          label: Text("Choose file"),
          icon: Icon(Icons.file_open_rounded),
        ),
      );
    } else {
      List<DatabaseTable> tables = getTables();
      if (tables.isEmpty) {
        return Center(child: Text("No tables found in database!"));
      } else {
        return TablesBrowser(tables: tables, database: _database!);
      }
    }
  }
}

class TablesBrowser extends StatefulWidget {
  final List<DatabaseTable> tables;
  final CommonDatabase database;
  const TablesBrowser({
    super.key,
    required this.tables,
    required this.database,
  });

  @override
  State<TablesBrowser> createState() => _TablesBrowserState();
}

class _TablesBrowserState extends State<TablesBrowser> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Flexible(
          flex: 1,
          child: ListView.builder(
            itemCount: widget.tables.length,
            itemBuilder: (BuildContext context, int index) {
              DatabaseTable table = widget.tables.elementAt(index);
              return Card(
                elevation: index == selectedIndex ? 1 : 0,
                child: ListTile(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  title: Text(
                    table.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(table.name),
                          content: Text(table.sql),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: table.sql),
                                );
                              },
                              child: Text("Copy SQL"),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.code),
                  ),
                ),
              );
            },
          ),
        ),
        Flexible(
          flex: 4,
          child: DbTableView(
            table: widget.tables[selectedIndex],
            database: widget.database,
          ),
        ),
      ],
    );
  }
}

class DbTableView extends StatelessWidget {
  const DbTableView({super.key, required this.table, required this.database});

  final DatabaseTable table;
  final CommonDatabase database;

  @override
  Widget build(BuildContext context) {
    return TableView.builder(
      key: ValueKey<String>(table.name),
      pinnedRowCount: 1,
      cellBuilder: (BuildContext context, TableVicinity vicinity) {
        if (vicinity.row == 0) {
          DbTableColumn col = table.columns[vicinity.column];
          return TableViewCell(
            child: ListTile(
              leading: col.primaryKey ? Icon(Icons.key) : null,
              title: Text(col.name),
              subtitle: Text(col.type),
            ),
          );
        }
        String val = table.getCell(database, vicinity.column, vicinity.row);
        return TableViewCell(child: Text(val));
      },
      columnCount: table.columns.length,
      columnBuilder: (int column) {
        return TableSpan(
          extent: FixedTableSpanExtent(256),
          foregroundDecoration: TableSpanDecoration(
            border: TableSpanBorder(
              trailing: BorderSide(
                color: Colors.black,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
          ),
        );
      },
      rowCount: table.rows + 1,
      rowBuilder: (int row) {
        return TableSpan(
          extent: FixedTableSpanExtent(64),
          backgroundDecoration: TableSpanDecoration(
            color: row.isEven ? Colors.blueAccent[100] : Colors.white,
          ),
        );
      },
    );
  }
}

class DatabaseTable extends Equatable {
  final String name;
  final String sql;
  final List<DbTableColumn> columns;
  final int rows;

  const DatabaseTable(this.name, this.sql, this.columns, this.rows);

  String getCell(CommonDatabase db, int col, int row) {
    ResultSet set = db.select("SELECT * FROM $name LIMIT ${row - 1},1");
    return set.first.columnAt(col).toString();
  }

  @override
  List<Object?> get props => [name, sql];
}

class DbTableColumn extends Equatable {
  final String name;
  final String type;
  final bool notNull;
  final bool primaryKey;

  const DbTableColumn(this.name, this.type, this.notNull, this.primaryKey);

  @override
  List<Object?> get props => [name, type, notNull, primaryKey];
}

extension FindColumn on List<DbTableColumn> {
  DbTableColumn findColumn(String name) =>
      firstWhere((element) => element.name == name);
}
