import 'package:flutter/material.dart';

class FolderIcons {
  /// Returns an icon by a given name
  static IconData name(String name) {
    FolderIcon item = _folderIcons.firstWhere((element) => element.name == name);
    return item.icon;
  }
}

class FolderIcon {
  final String name;
  final IconData icon;

  FolderIcon({this.name, this.icon});
}

List<FolderIcon> _folderIcons = [
  FolderIcon(name: 'Sports', icon: Icons.directions_run),
  FolderIcon(name: 'History', icon: Icons.history),
  FolderIcon(name: 'Likes', icon: Icons.thumb_up),
  FolderIcon(name: 'Gaming', icon: Icons.sports_esports),
  FolderIcon(name: 'Fashion', icon: Icons.checkroom),
  FolderIcon(name: 'Technology', icon: Icons.memory),
  FolderIcon(name: 'Music', icon: Icons.music_video),
  FolderIcon(name: 'Movie', icon: Icons.movie),
  FolderIcon(name: 'Trending', icon: Icons.local_fire_department),
  FolderIcon(name: 'Fitness', icon: Icons.fitness_center),
  FolderIcon(name: 'Code', icon: Icons.code),
  FolderIcon(name: 'Work', icon: Icons.business_center),
  FolderIcon(name: 'Engineering', icon: Icons.engineering),
  FolderIcon(name: 'Android', icon: Icons.android),
  FolderIcon(name: 'iOS', icon: Icons.phone_iphone),
  FolderIcon(name: 'Cooking', icon: Icons.restaurant),
  FolderIcon(name: 'Info', icon: Icons.info),
  FolderIcon(name: 'People', icon: Icons.people_alt),
  FolderIcon(name: 'World', icon: Icons.public),
  FolderIcon(name: 'Airplane', icon: Icons.flight),
  FolderIcon(name: 'Medical', icon: Icons.local_hospital),
  FolderIcon(name: 'Meditation', icon: Icons.self_improvement),
];
