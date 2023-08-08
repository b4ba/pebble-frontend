import 'dart:async';

import 'package:ecclesia_ui/data/models/choice_model.dart';
import 'package:ecclesia_ui/data/models/election_model.dart';
import 'package:ecclesia_ui/data/models/organization_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;
  final _electionsController = StreamController<List<Election>>.broadcast();
  Stream<List<Election>> get electionsStream => _electionsController.stream;

  IsarService() {
    db = openDB();
  }

  Future<Election?> getElectionByInvitationId(String invId) async {
    final isar = await db;
    return await isar.elections.filter().invitationIdEqualTo(invId).findFirst();
  }

  Future<void> addElection(Election election) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.elections.putSync(election));
    final allElections = await getAllElections();
    _electionsController.add(allElections);
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

  Stream<List<Election>> listenToElections() async* {
    final isar = await db;
    yield* isar.elections.where().watch();
    // initialReturn: true
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
