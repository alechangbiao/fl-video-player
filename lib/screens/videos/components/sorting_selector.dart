import 'package:flutter/material.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/sorter.dart';

class SortingSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 0,
      expandedHeight: 20,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        // collapseMode: CollapseMode.pin,
        background: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppLayout.appBarActionMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Sorter(type: SorterType.sequence, isRootPath: true),
              SizedBox(width: 20),
              Sorter(type: SorterType.layout, isRootPath: true),
            ],
          ),
        ),
      ),
    );
  }
}
