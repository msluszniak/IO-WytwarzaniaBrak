// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorStorage {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$StorageBuilder databaseBuilder(String name) =>
      _$StorageBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$StorageBuilder inMemoryDatabaseBuilder() => _$StorageBuilder(null);
}

class _$StorageBuilder {
  _$StorageBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$StorageBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$StorageBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<Storage> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$Storage();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$Storage extends Storage {
  _$Storage([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ExerciseDao? _exerciseDAOInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Exercise` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `equipmentId` INTEGER NOT NULL, `bodyPart` TEXT, `description` TEXT, `isFavorite` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ExerciseDao get exerciseDAO {
    return _exerciseDAOInstance ??= _$ExerciseDao(database, changeListener);
  }
}

class _$ExerciseDao extends ExerciseDao {
  _$ExerciseDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _exerciseInsertionAdapter = InsertionAdapter(
            database,
            'Exercise',
            (Exercise item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'equipmentId': item.equipmentId,
                  'bodyPart': item.bodyPart,
                  'description': item.description,
                  'isFavorite': item.isFavorite ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Exercise> _exerciseInsertionAdapter;

  @override
  Future<void> updateExerciseFavorites(List<int> favoriteIds) async {
    const offset = 1;
    final _sqliteVariablesForFavoriteIds =
        Iterable<String>.generate(favoriteIds.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'UPDATE Exercise SET isFavorite=1 WHERE id in (' +
            _sqliteVariablesForFavoriteIds +
            ')',
        arguments: [...favoriteIds]);
  }

  @override
  Future<List<Exercise>> getExercises() async {
    return _queryAdapter.queryList('SELECT * FROM Exercise',
        mapper: (Map<String, Object?> row) => Exercise(
            id: row['id'] as int?,
            name: row['name'] as String,
            equipmentId: row['equipmentId'] as int,
            bodyPart: row['bodyPart'] as String?,
            description: row['description'] as String?,
            isFavorite: (row['isFavorite'] as int) != 0));
  }

  @override
  Future<List<Exercise>> getFavExercises() async {
    return _queryAdapter.queryList('SELECT * FROM Exercise WHERE isFavorite',
        mapper: (Map<String, Object?> row) => Exercise(
            id: row['id'] as int?,
            name: row['name'] as String,
            equipmentId: row['equipmentId'] as int,
            bodyPart: row['bodyPart'] as String?,
            description: row['description'] as String?,
            isFavorite: (row['isFavorite'] as int) != 0));
  }

  @override
  Future<void> setFavourite(int id, bool isFavorite) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Exercise SET isFavorite=?2 WHERE id=?1',
        arguments: [id, isFavorite ? 1 : 0]);
  }

  @override
  Future<void> updateExercises(List<Exercise> person) async {
    await _exerciseInsertionAdapter.insertList(
        person, OnConflictStrategy.replace);
  }

  @override
  Future<void> addExercise(Exercise exercise) async {
    await _exerciseInsertionAdapter.insert(exercise, OnConflictStrategy.abort);
  }
}
