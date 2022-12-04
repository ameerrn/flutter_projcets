import 'package:bloc_firebase22/dialogs/generec_dialog.dart';
import 'package:flutter/cupertino.dart' show BuildContext;

Future<bool> showDeleteAccountDialog(
  BuildContext context,
) {
  return showGenericDialog<bool?>(
    context: context,
    title: 'Delete account',
    content:
        'Are you sure you want to delete your account? You cannot undo this operation',
    optionBuilder: () => {
      'Cancel': false,
      'Delete account': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
