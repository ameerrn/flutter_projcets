import 'package:bloc_firebase22/auth/auth_error.dart';
import 'package:bloc_firebase22/dialogs/generec_dialog.dart';
import 'package:flutter/cupertino.dart' show BuildContext;

Future<void> showAuthError({
  required BuildContext context,
  required AuthError authError,
}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionBuilder: () => {
      'OK': true,
    },
  );
}
