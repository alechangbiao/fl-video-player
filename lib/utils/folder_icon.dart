import 'package:flutter/material.dart';

class FolderIcons {
  /// Returns an icon by a given name
  static IconData name(String name) {
    if (name == null) return null;
    FolderIcon item = _folderIcons.firstWhere(
      (element) => element.name == name,
      orElse: () => null,
    );
    return item.icon;
  }

  static List<FolderIcon> allIcons = _folderIcons;
}

class FolderIcon {
  final String name;
  final IconData icon;

  FolderIcon({this.name, this.icon});
}

List<FolderIcon> _folderIcons = [
  FolderIcon(name: IconNames.Sports, icon: Icons.sports_football),
  FolderIcon(name: IconNames.History, icon: Icons.history),
  FolderIcon(name: IconNames.Likes, icon: Icons.thumb_up),
  FolderIcon(name: IconNames.Gaming, icon: Icons.sports_esports),
  FolderIcon(name: IconNames.Fashion, icon: Icons.checkroom),
  FolderIcon(name: IconNames.Technology, icon: Icons.memory),
  FolderIcon(name: IconNames.Music, icon: Icons.music_video),
  FolderIcon(name: IconNames.Movie, icon: Icons.movie),
  FolderIcon(name: IconNames.Trending, icon: Icons.local_fire_department),
  FolderIcon(name: IconNames.Fitness, icon: Icons.fitness_center),
  FolderIcon(name: IconNames.Code, icon: Icons.code),
  FolderIcon(name: IconNames.Work, icon: Icons.business_center),
  FolderIcon(name: IconNames.Engineering, icon: Icons.engineering),
  FolderIcon(name: IconNames.Android, icon: Icons.android),
  FolderIcon(name: IconNames.Cellphone, icon: Icons.phone_iphone),
  FolderIcon(name: IconNames.Tablet, icon: Icons.tablet_mac),
  FolderIcon(name: IconNames.Devices, icon: Icons.devices),
  FolderIcon(name: IconNames.Cooking, icon: Icons.restaurant),
  FolderIcon(name: IconNames.Info, icon: Icons.info),
  FolderIcon(name: IconNames.People, icon: Icons.people_alt),
  FolderIcon(name: IconNames.World, icon: Icons.public),
  FolderIcon(name: IconNames.Airplane, icon: Icons.flight),
  FolderIcon(name: IconNames.Medical, icon: Icons.local_hospital),
  FolderIcon(name: IconNames.Meditation, icon: Icons.self_improvement),
];

class IconNames {
  static const Sports = "Sports";
  static const History = "History";
  static const Likes = "Likes";
  static const Gaming = "Gaming";
  static const Fashion = "Fashion";
  static const Technology = "Technology";
  static const Music = "Music";
  static const Movie = "Movie";
  static const Trending = "Trending";
  static const Fitness = "Fitness";
  static const Code = "Code";
  static const Work = "Work";
  static const Engineering = "Engineering";
  static const Android = "Android";
  static const Cellphone = "Cellphone";
  static const Tablet = "Tablet";
  static const Devices = "Devices";
  static const Cooking = "Cooking";
  static const Info = "Info";
  static const People = "People";
  static const World = "World";
  static const Airplane = "Airplane";
  static const Medical = "Medical";
  static const Meditation = "Meditation";
}

extension FolderIconUtilsExtension on String {
  /// Get and icon by its name String
  IconData get getIcon => FolderIcons.name(this);
}
