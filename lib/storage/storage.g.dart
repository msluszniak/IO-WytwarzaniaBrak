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

  GymDao? _gymDAOInstance;

  EquipmentDao? _equipmentDAOInstance;

  WorkoutDao? _workoutDAOInstance;

  WorkoutExerciseDao? _workoutExerciseDAOInstance;

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
            'CREATE TABLE IF NOT EXISTS `Exercise` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `equipmentId` INTEGER NOT NULL, `bodyPart` TEXT, `description` TEXT, `repTime` INTEGER, `isFavorite` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Equipment` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Gym` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `lat` REAL NOT NULL, `lng` REAL NOT NULL, `name` TEXT NOT NULL, `description` TEXT, `address` TEXT, `isFavorite` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Workout` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `isFavorite` INTEGER NOT NULL, `userDefined` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `WorkoutExercise` (`workoutId` INTEGER NOT NULL, `exerciseId` INTEGER NOT NULL, `series` INTEGER NOT NULL, `reps` INTEGER NOT NULL, FOREIGN KEY (`workoutId`) REFERENCES `Workout` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`exerciseId`) REFERENCES `Exercise` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`workoutId`, `exerciseId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ExerciseDao get exerciseDAO {
    return _exerciseDAOInstance ??= _$ExerciseDao(database, changeListener);
  }

  @override
  GymDao get gymDAO {
    return _gymDAOInstance ??= _$GymDao(database, changeListener);
  }

  @override
  EquipmentDao get equipmentDAO {
    return _equipmentDAOInstance ??= _$EquipmentDao(database, changeListener);
  }

  @override
  WorkoutDao get workoutDAO {
    return _workoutDAOInstance ??= _$WorkoutDao(database, changeListener);
  }

  @override
  WorkoutExerciseDao get workoutExerciseDAO {
    return _workoutExerciseDAOInstance ??=
        _$WorkoutExerciseDao(database, changeListener);
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
                  'repTime': item.repTime,
                  'isFavorite': item.isFavorite ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Exercise> _exerciseInsertionAdapter;

  @override
  Future<void> addFavorite(int id, bool isFavorite) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Exercise SET isFavorite=?2 WHERE id=?1',
        arguments: [id, isFavorite ? 1 : 0]);
  }

  @override
  Future<List<Exercise>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM Exercise',
        mapper: (Map<String, Object?> row) => Exercise(
            id: row['id'] as int?,
            name: row['name'] as String,
            equipmentId: row['equipmentId'] as int,
            bodyPart: row['bodyPart'] as String?,
            description: row['description'] as String?,
            repTime: row['repTime'] as int?,
            isFavorite: (row['isFavorite'] as int) != 0));
  }

  @override
  Future<List<Exercise>> getFavorite() async {
    return _queryAdapter.queryList('SELECT * FROM Exercise WHERE isFavorite',
        mapper: (Map<String, Object?> row) => Exercise(
            id: row['id'] as int?,
            name: row['name'] as String,
            equipmentId: row['equipmentId'] as int,
            bodyPart: row['bodyPart'] as String?,
            description: row['description'] as String?,
            repTime: row['repTime'] as int?,
            isFavorite: (row['isFavorite'] as int) != 0));
  }

  @override
  Future<void> deleteRemoved(List<int> keptIds) async {
    const offset = 1;
    final _sqliteVariablesForKeptIds =
        Iterable<String>.generate(keptIds.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'DELETE FROM Exercise WHERE id NOT IN (' +
            _sqliteVariablesForKeptIds +
            ')',
        arguments: [...keptIds]);
  }

  @override
  Future<void> updateFavorites(List<int> favoriteIds) async {
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
  Future<List<Workout>> getJoinedWorkouts(int exerciseId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Workout WHERE id IN (SELECT workoutId FROM WorkoutExercise WHERE exerciseId = ?1)',
        mapper: (Map<String, Object?> row) => Workout(id: row['id'] as int?, name: row['name'] as String, isFavorite: (row['isFavorite'] as int) != 0, userDefined: (row['userDefined'] as int) != 0),
        arguments: [exerciseId]);
  }

  @override
  Future<List<Equipment>> getJoinedEquipments(int exerciseId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Equipment WHERE id IN (SELECT equipmentId FROM Exercise WHERE id = ?1)',
        mapper: (Map<String, Object?> row) => Equipment(id: row['id'] as int?, name: row['name'] as String),
        arguments: [exerciseId]);
  }

  @override
  Future<int> add(Exercise exercise) {
    return _exerciseInsertionAdapter.insertAndReturnId(
        exercise, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> addAll(List<Exercise> exercises) {
    return _exerciseInsertionAdapter.insertListAndReturnIds(
        exercises, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateAll(List<Exercise> exercises) async {
    await _exerciseInsertionAdapter.insertList(
        exercises, OnConflictStrategy.replace);
  }
}

class _$GymDao extends GymDao {
  _$GymDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _gymInsertionAdapter = InsertionAdapter(
            database,
            'Gym',
            (Gym item) => <String, Object?>{
                  'id': item.id,
                  'lat': item.lat,
                  'lng': item.lng,
                  'name': item.name,
                  'description': item.description,
                  'address': item.address,
                  'isFavorite': item.isFavorite ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Gym> _gymInsertionAdapter;

  @override
  Future<void> addFavorite(int id, bool isFavorite) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Gym SET isFavorite=?2 WHERE id=?1',
        arguments: [id, isFavorite ? 1 : 0]);
  }

  @override
  Future<List<Gym>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM Gym',
        mapper: (Map<String, Object?> row) => Gym(
            id: row['id'] as int?,
            lat: row['lat'] as double,
            lng: row['lng'] as double,
            name: row['name'] as String,
            description: row['description'] as String?,
            address: row['address'] as String?,
            isFavorite: (row['isFavorite'] as int) != 0));
  }

  @override
  Future<List<Gym>> getFavorite() async {
    return _queryAdapter.queryList('SELECT * FROM Gym WHERE isFavorite',
        mapper: (Map<String, Object?> row) => Gym(
            id: row['id'] as int?,
            lat: row['lat'] as double,
            lng: row['lng'] as double,
            name: row['name'] as String,
            description: row['description'] as String?,
            address: row['address'] as String?,
            isFavorite: (row['isFavorite'] as int) != 0));
  }

  @override
  Future<void> deleteRemoved(List<int> keptIds) async {
    const offset = 1;
    final _sqliteVariablesForKeptIds =
        Iterable<String>.generate(keptIds.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'DELETE FROM Gym WHERE id NOT IN (' + _sqliteVariablesForKeptIds + ')',
        arguments: [...keptIds]);
  }

  @override
  Future<void> updateFavorites(List<int> favoriteIds) async {
    const offset = 1;
    final _sqliteVariablesForFavoriteIds =
        Iterable<String>.generate(favoriteIds.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'UPDATE Gym SET isFavorite=1 WHERE id in (' +
            _sqliteVariablesForFavoriteIds +
            ')',
        arguments: [...favoriteIds]);
  }

  @override
  Future<int> add(Gym gym) {
    return _gymInsertionAdapter.insertAndReturnId(
        gym, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> addAll(List<Gym> gyms) {
    return _gymInsertionAdapter.insertListAndReturnIds(
        gyms, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateAll(List<Gym> gyms) async {
    await _gymInsertionAdapter.insertList(gyms, OnConflictStrategy.replace);
  }
}

class _$EquipmentDao extends EquipmentDao {
  _$EquipmentDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _equipmentInsertionAdapter = InsertionAdapter(
            database,
            'Equipment',
            (Equipment item) =>
                <String, Object?>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Equipment> _equipmentInsertionAdapter;

  @override
  Future<List<Equipment>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM Equipment',
        mapper: (Map<String, Object?> row) =>
            Equipment(id: row['id'] as int?, name: row['name'] as String));
  }

  @override
  Future<void> deleteRemoved(List<int> keptIds) async {
    const offset = 1;
    final _sqliteVariablesForKeptIds =
        Iterable<String>.generate(keptIds.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'DELETE FROM Equipment WHERE id NOT IN (' +
            _sqliteVariablesForKeptIds +
            ')',
        arguments: [...keptIds]);
  }

  @override
  Future<List<Exercise>> getJoinedExercises(int equipmentId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Exercise WHERE equipmentId = ?1',
        mapper: (Map<String, Object?> row) => Exercise(
            id: row['id'] as int?,
            name: row['name'] as String,
            equipmentId: row['equipmentId'] as int,
            bodyPart: row['bodyPart'] as String?,
            description: row['description'] as String?,
            repTime: row['repTime'] as int?,
            isFavorite: (row['isFavorite'] as int) != 0),
        arguments: [equipmentId]);
  }

  @override
  Future<int> add(Equipment equipment) {
    return _equipmentInsertionAdapter.insertAndReturnId(
        equipment, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> addAll(List<Equipment> equipments) {
    return _equipmentInsertionAdapter.insertListAndReturnIds(
        equipments, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateAll(List<Equipment> equipments) async {
    await _equipmentInsertionAdapter.insertList(
        equipments, OnConflictStrategy.replace);
  }
}

class _$WorkoutDao extends WorkoutDao {
  _$WorkoutDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _workoutInsertionAdapter = InsertionAdapter(
            database,
            'Workout',
            (Workout item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'isFavorite': item.isFavorite ? 1 : 0,
                  'userDefined': item.userDefined ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Workout> _workoutInsertionAdapter;

  @override
  Future<void> addFavorite(int id, bool isFavorite) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Workout SET isFavorite=?2 WHERE id=?1',
        arguments: [id, isFavorite ? 1 : 0]);
  }

  @override
  Future<List<Workout>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM Workout',
        mapper: (Map<String, Object?> row) => Workout(
            id: row['id'] as int?,
            name: row['name'] as String,
            isFavorite: (row['isFavorite'] as int) != 0,
            userDefined: (row['userDefined'] as int) != 0));
  }

  @override
  Future<List<Workout>> getFavorite() async {
    return _queryAdapter.queryList('SELECT * FROM Workout WHERE isFavorite',
        mapper: (Map<String, Object?> row) => Workout(
            id: row['id'] as int?,
            name: row['name'] as String,
            isFavorite: (row['isFavorite'] as int) != 0,
            userDefined: (row['userDefined'] as int) != 0));
  }

  @override
  Future<void> deleteRemoved(List<int> keptIds) async {
    const offset = 1;
    final _sqliteVariablesForKeptIds =
        Iterable<String>.generate(keptIds.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'DELETE FROM Workout WHERE id NOT IN (' +
            _sqliteVariablesForKeptIds +
            ')',
        arguments: [...keptIds]);
  }

  @override
  Future<void> updateFavorites(List<int> favoriteIds) async {
    const offset = 1;
    final _sqliteVariablesForFavoriteIds =
        Iterable<String>.generate(favoriteIds.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'UPDATE Workout SET isFavorite=1 WHERE id in (' +
            _sqliteVariablesForFavoriteIds +
            ')',
        arguments: [...favoriteIds]);
  }

  @override
  Future<List<Exercise>> getJoinedExercises(int workoutId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Exercise WHERE id IN (SELECT exerciseId FROM WorkoutExercise WHERE workoutId = ?1)',
        mapper: (Map<String, Object?> row) => Exercise(id: row['id'] as int?, name: row['name'] as String, equipmentId: row['equipmentId'] as int, bodyPart: row['bodyPart'] as String?, description: row['description'] as String?, repTime: row['repTime'] as int?, isFavorite: (row['isFavorite'] as int) != 0),
        arguments: [workoutId]);
  }

  @override
  Future<List<Workout>> getLocal() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Workout WHERE userDefined = 1',
        mapper: (Map<String, Object?> row) => Workout(
            id: row['id'] as int?,
            name: row['name'] as String,
            isFavorite: (row['isFavorite'] as int) != 0,
            userDefined: (row['userDefined'] as int) != 0));
  }

  @override
  Future<void> removeLocal() async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Workout WHERE userDefined = 1');
  }

  @override
  Future<int> add(Workout workout) {
    return _workoutInsertionAdapter.insertAndReturnId(
        workout, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> addAll(List<Workout> workouts) {
    return _workoutInsertionAdapter.insertListAndReturnIds(
        workouts, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateAll(List<Workout> workouts) async {
    await _workoutInsertionAdapter.insertList(
        workouts, OnConflictStrategy.replace);
  }
}

class _$WorkoutExerciseDao extends WorkoutExerciseDao {
  _$WorkoutExerciseDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _workoutExerciseInsertionAdapter = InsertionAdapter(
            database,
            'WorkoutExercise',
            (WorkoutExercise item) => <String, Object?>{
                  'workoutId': item.workoutId,
                  'exerciseId': item.exerciseId,
                  'series': item.series,
                  'reps': item.reps
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WorkoutExercise> _workoutExerciseInsertionAdapter;

  @override
  Future<List<WorkoutExercise>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM WorkoutExercise',
        mapper: (Map<String, Object?> row) => WorkoutExercise(
            workoutId: row['workoutId'] as int,
            exerciseId: row['exerciseId'] as int,
            series: row['series'] as int,
            reps: row['reps'] as int));
  }

  @override
  Future<List<WorkoutExercise>> getAllWithWorkout(int workoutId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM WorkoutExercise WHERE workoutId = ?1',
        mapper: (Map<String, Object?> row) => WorkoutExercise(
            workoutId: row['workoutId'] as int,
            exerciseId: row['exerciseId'] as int,
            series: row['series'] as int,
            reps: row['reps'] as int),
        arguments: [workoutId]);
  }

  @override
  Future<List<WorkoutExercise>> getAllWithExercise(int exerciseId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM WorkoutExercise WHERE exerciseId = ?1',
        mapper: (Map<String, Object?> row) => WorkoutExercise(
            workoutId: row['workoutId'] as int,
            exerciseId: row['exerciseId'] as int,
            series: row['series'] as int,
            reps: row['reps'] as int),
        arguments: [exerciseId]);
  }

  @override
  Future<void> clearAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM WorkoutExercise');
  }

  @override
  Future<void> removeLocal() async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM WorkoutExercise WHERE workoutId IN (SELECT id FROM Workout WHERE userDefined = 1)');
  }

  @override
  Future<int> add(WorkoutExercise workout) {
    return _workoutExerciseInsertionAdapter.insertAndReturnId(
        workout, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> addAll(List<WorkoutExercise> workoutExercises) {
    return _workoutExerciseInsertionAdapter.insertListAndReturnIds(
        workoutExercises, OnConflictStrategy.abort);
  }
}
