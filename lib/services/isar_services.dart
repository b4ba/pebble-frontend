import 'package:ecclesia_ui/data/models/choice_model.dart';
import 'package:ecclesia_ui/data/models/election_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<void> addElection(Election election) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.elections.putSync(election));
  }

  Future<void> addChoice(Choice choice) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.choices.putSync(choice));
  }

  Future<Election?> getElectionById(String id) async {
    final isar = await db;
    return await isar.elections.get(int.parse(id));
  }

  Future<List<Election>> getAllElections() async {
    final isar = await db;
    return await isar.elections.where().findAll();
  }

  Stream<List<Election>> listenToElections() async* {
    final isar = await db;
    yield* isar.elections.where().watch();
    // initialReturn: true
  }

  Future<List<Choice>> getChoicesFor(Election election) async {
    final isar = await db;
    return await isar.choices
        .filter()
        .election((q) => q.idEqualTo(election.id))
        .findAll();
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [ElectionSchema, ChoiceSchema],
        inspector: true,
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }
}
