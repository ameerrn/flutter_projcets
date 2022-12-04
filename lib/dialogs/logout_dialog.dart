import 'package:bloc_firebase22/dialogs/generec_dialog.dart';
import 'package:flutter/cupertino.dart' show BuildContext;

Future<bool> showLogOutDialog(
  BuildContext context,
) {
  return showGenericDialog<bool?>(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to Log out?',
    optionBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
