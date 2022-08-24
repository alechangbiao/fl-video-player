import 'package:flutter/material.dart';

class FolderIcons {
  /// Returns an icon by a given name
  static IconData? name(String? name) {
    if (name == null) return null;
    FolderIcon item = _folderIcons.firstWhere(
      (element) => element.name == name,
      // orElse: () => null,
    );
    return item.icon;
  }

  static List<FolderIcon> allIcons = _folderIcons;
}

class FolderIcon {
  final String name;
  final IconData icon;

  FolderIcon({required this.name, required this.icon});
}

List<FolderIcon> _folderIcons = [
  FolderIcon(name: IconNames.Airplane, icon: Icons.flight),
  FolderIcon(name: IconNames.Android, icon: Icons.android),
  FolderIcon(name: IconNames.Cellphone, icon: Icons.phone_iphone),
  FolderIcon(name: IconNames.Code, icon: Icons.code),
  FolderIcon(name: IconNames.Cooking, icon: Icons.restaurant),
  FolderIcon(name: IconNames.Devices, icon: Icons.devices),
  FolderIcon(name: IconNames.Engineering, icon: Icons.engineering),
  FolderIcon(name: IconNames.Fashion, icon: Icons.checkroom),
  FolderIcon(name: IconNames.Fitness, icon: Icons.fitness_center),
  FolderIcon(name: IconNames.Gaming, icon: Icons.sports_esports),
  FolderIcon(name: IconNames.History, icon: Icons.history),
  FolderIcon(name: IconNames.Info, icon: Icons.info),
  FolderIcon(name: IconNames.Likes, icon: Icons.thumb_up),
  FolderIcon(name: IconNames.Medical, icon: Icons.local_hospital),
  FolderIcon(name: IconNames.Meditation, icon: Icons.self_improvement),
  FolderIcon(name: IconNames.Movie, icon: Icons.movie),
  FolderIcon(name: IconNames.Music, icon: Icons.music_video),
  FolderIcon(name: IconNames.People, icon: Icons.people_alt),
  FolderIcon(name: IconNames.Sports, icon: Icons.sports_football),
  FolderIcon(name: IconNames.Technology, icon: Icons.memory),
  FolderIcon(name: IconNames.Trending, icon: Icons.local_fire_department),
  FolderIcon(name: IconNames.Tablet, icon: Icons.tablet_mac),
  FolderIcon(name: IconNames.Work, icon: Icons.business_center),
  FolderIcon(name: IconNames.World, icon: Icons.public),
];

class IconNames {
  static const Airplane = "Airplane";
  static const Android = "Android";
  static const Cellphone = "Cellphone";
  static const Code = "Code";
  static const Cooking = "Cooking";
  static const Devices = "Devices";
  static const Engineering = "Engineering";
  static const Fashion = "Fashion";
  static const Fitness = "Fitness";
  static const Gaming = "Gaming";
  static const History = "History";
  static const Info = "Info";
  static const Likes = "Likes";
  static const Medical = "Medical";
  static const Meditation = "Meditation";
  static const Movie = "Movie";
  static const Music = "Music";
  static const People = "People";
  static const Sports = "Sports";
  static const Tablet = "Tablet";
  static const Technology = "Technology";
  static const Trending = "Trending";
  static const Work = "Work";
  static const World = "World";
}

extension FolderIconUtilsExtension on String {
  /// Get and icon by its name String
  IconData? get getIcon => FolderIcons.name(this);
}
