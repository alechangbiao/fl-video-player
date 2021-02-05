import 'package:flutter/material.dart';

class RenameFolderDialog extends StatelessWidget {
  const RenameFolderDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rename Folder'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Enter foler name'),
            ),
          ],
        ),
      ),
      actions: buildActionButtons(context),
    );
  }

  List<Widget> buildActionButtons(BuildContext context) {
    return <Widget>[
      TextButton(
        child: Text(
          'Cancel',
          style: TextStyle(color: Colors.grey),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      TextButton(
        child: Text('Approve'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ];
  }
}
