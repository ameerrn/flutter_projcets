import 'package:bloc_firebase22/bloc/app_bloc.dart';
import 'package:bloc_firebase22/bloc/app_event.dart';
import 'package:bloc_firebase22/dialogs/delete_account_dialog.dart';
import 'package:bloc_firebase22/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MenuAction { logOut, deleteAccount }

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
        onSelected: (value) async {
          switch (value) {
            case MenuAction.logOut:
              final shouldLogOut = await showLogOutDialog(context);
              if (shouldLogOut) {
                context.read<AppBloc>().add(
                      const AppEventLogOut(),
                    );
              }
              break;
            case MenuAction.deleteAccount:
              final shouldDeletAccount = await showDeleteAccountDialog(context);
              if (shouldDeletAccount) {
                context.read<AppBloc>().add(
                      const AppEventDeleteAccount(),
                    );
              }
              break;
          }
        },
        itemBuilder: (context) => [
              const PopupMenuItem<MenuAction>(
                value: MenuAction.logOut,
                child: Text('Log out'),
              ),
              const PopupMenuItem<MenuAction>(
                value: MenuAction.deleteAccount,
                child: Text('Delete account'),
              )
            ]);
  }
}
