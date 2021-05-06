import 'package:app/archive/slidable_list_item.dart';
import 'package:flutter/material.dart';

List<Widget> _items = <Widget>[
  SlidableListItem(),
  SlidableListItem(),
  SlidableListItem(),
  SlidableListItem(),
  SlidableListItem(),
  SlidableListItem(),
  SlidableListItem(),
  SlidableListItem(),
  SlidableListItem(),
  SlidableListItem(),
];

class SlidableList extends StatelessWidget {
  const SlidableList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      // Use a delegate to build items as they're scrolled on screen.
      delegate: SliverChildBuilderDelegate(
        (context, index) => _items[index],
        childCount: _items.length,
      ),
    );

    // return Expanded(
    //   child: ListView(
    //     children: _itemList,
    //   ),
    // );
  }
}
