import 'package:flutter/material.dart';

class Storage extends StatelessWidget {
  List<Item> taskList = [
    Item(id: '1', title: 'Test app 1', status: 'Employee', name: 'John'),
    Item(id: '2', title: 'Test app 2', status: 'Manager', name: 'Jenny'),
    Item(id: '3', title: 'Test app 3', status: 'Customer', name: 'Jane')
  ];

  @override
  Widget build(BuildContext context) {
    print('Building Storage Page...');

    return Scaffold(
      appBar: AppBar(
        title: Text('Storage'),
      ),
      body: ReorderableListView(
        children: taskList.map((item) => toDo(item, context)).toList(),
        onReorder: (prevIndex, newIndex) {
          if (newIndex > prevIndex) {
            newIndex -= 1;
          }
          final Item item = taskList.removeAt(prevIndex);
          taskList.insert(newIndex, item);
        },
      ),
    );
  }

  // void _onReorder(prevIndex, newIndex) {
  //   if (newIndex > prevIndex) {
  //     newIndex -= 1;
  //   }
  //   final Item item = taskList.removeAt(prevIndex);
  //   taskList.insert(newIndex, item);
  // }

  Widget toDo(Item todo, BuildContext context) {
    return Container(
        key: Key(todo.id),
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle, // BoxShape.circle or BoxShape.retangle
          // color: const Color(0xFF66BB6A),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.blue,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(todo.title),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ownerNameWidget(todo),
                  statusWidget(todo),
                ],
              ),
            )
          ],
        ));
  }

  Widget ownerNameWidget(Item todo) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 5.0),
              child: Text(
                'Owner',
                style: TextStyle(
                  fontSize: 17.07,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                '${todo.name}',
                style: TextStyle(
                  fontSize: 17.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statusWidget(Item todo) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 5.0),
              child: Text(
                'status',
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                '${todo.status}',
                style: TextStyle(
                  fontSize: 17.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  String id;
  String title;
  String status;
  String name;

  Item({required this.id, required this.title, required this.status, required this.name});
}
