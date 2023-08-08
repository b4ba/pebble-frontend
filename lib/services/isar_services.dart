import 'dart:async';

import 'package:ecclesia_ui/data/models/choice_model.dart';
import 'package:ecclesia_ui/data/models/election_model.dart';
import 'package:ecclesia_ui/data/models/organization_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  final _electionsController = StreamController<List<Election>>.broadcast();

  // Stream<List<Election>> listenToElections() {
  //   // Listen for changes in the elections box and add them to the stream
  //   Isar.instance.elections.watch().listen((event) {
  //     final elections = Isar.instance.elections.where().findAllSync();
  //     _electionsController.add(elections);
  //   });
  //   return _electionsController.stream;
  // }

  Stream<List<Election>> listenToElections() async* {
    _loadInitialElections();
    final isar = await db;
    isar.elections.where().watch().listen((event) {
      final elections = isar.elections.where().findAllSync();
      _electionsController.add(elections);
    });
    yield* _electionsController.stream;
  }

  void _loadInitialElections() async {
    final isar = await db;
    final initialElections = await isar.elections.where().findAll();
    _electionsController.add(initialElections);
  }

  Future<Election?> getElectionByInvitationId(String invId) async {
    final isar = await db;
    return await isar.elections.filter().invitationIdEqualTo(invId).findFirst();
  }

  Future<void> addElection(Election election) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.elections.putSync(election));
  }

  Future<void> addChoice(Choice choice) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.choices.putSync(choice));
  }

  Future<void> addOrganization(Organization organization) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.organizations.putSync(organization));
  }

  Future<Organization?> getOrganizationByIdentifier(String id) async {
    final isar = await db;
    return await isar.organizations.filter().identifierEqualTo(id).findFirst();
  }

  Future<List<Election>> getAllElections() async {
    final isar = await db;
    return await isar.elections.where().findAll();
  }

  Future<void> deleteOrganization(String identifier) async {
    final isar = await db;
    isar.writeTxn(() => isar.organizations.deleteByIdentifier(identifier));
  }

  Future<List<Organization>> getAllOrganizations() async {
    final isar = await db;
    return await isar.organizations.where().findAll();
  }

  Future<List<Choice>> getChoicesFor(String invitationKey) async {
    final isar = await db;
    return await isar.choices
        .filter()
        .invitationIdEqualTo(invitationKey)
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
        [ElectionSchema, ChoiceSchema, OrganizationSchema],
        inspector: true,
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }
}
