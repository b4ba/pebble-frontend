import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'organization_model.g.dart';

// Class model of an organization
@Collection(inheritance: false)
class Organization {
  final Id id = Isar.autoIncrement;
  @Index(unique: true)
  final String identifier;
  final String name;
  final String description;
  final String url;
  @ignore
  final IconData icon;

  const Organization(
      {required this.identifier,
      required this.name,
      required this.description,
      required this.url,
      this.icon = Icons.business});

  static List<Organization> organizations = [
    const Organization(
        identifier: '0',
        name: 'Edinburgh Baking Society',
        description: 'Description here',
        url: '',
        icon: Icons.cake),
    const Organization(
        identifier: '1',
        name: 'Edinburgh University Sports Union (EUSU)',
        description: 'Description here',
        url: '',
        icon: Icons.sports_baseball_rounded),
    const Organization(
        identifier: '2',
        name: 'Informatics 19/23',
        description: 'Description here',
        url: '',
        icon: Icons.computer_rounded),
    const Organization(
        identifier: '3',
        name: 'Edinburgh University Students\' Association (EUSA)',
        description: 'Description here',
        url: '',
        icon: Icons.people),
  ];

  factory Organization.fromJson(json) {
    final data = jsonDecode(json);
    try {
      return Organization(
          identifier: data['id'],
          name: data['name'],
          description: data['description'],
          url: data['url'],
          icon: Icons.business);
    } catch (e) {
      throw Exception('Organization data received is not valid');
    }
  }
}
