import 'package:flutter/material.dart';

// Class model of an organization
class Organization {
  final String id;
  final String name;
  final String description;
  final IconData icon;

  const Organization({required this.id, required this.name, required this.description, required this.icon});

  static List<Organization> organizations = [
    const Organization(id: '0', name: 'Edinburgh Baking Society', description: 'Description here', icon: Icons.cake),
    const Organization(id: '1', name: 'Edinburgh University Sports Union (EUSU)', description: 'Description here', icon: Icons.sports_baseball_rounded),
    const Organization(id: '2', name: 'Informatics 19/23', description: 'Description here', icon: Icons.computer_rounded),
    const Organization(id: '3', name: 'Edinburgh University Students\' Association (EUSA)', description: 'Description here', icon: Icons.people),
  ];
}
