import 'package:bloc_firebase22/bloc/app_bloc.dart';
import 'package:bloc_firebase22/bloc/app_event.dart';
import 'package:bloc_firebase22/bloc/app_state.dart';
import 'package:bloc_firebase22/dialogs/show_auth_error.dart';
import 'package:bloc_firebase22/loading/loading_screen.dart';
import 'package:bloc_firebase22/views/login_view.dart';
import 'package:bloc_firebase22/views/photo_gallary_view.dart';
import 'package:bloc_firebase22/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()
        ..add(
          const AppEventInitialize(),
        ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocConsumer<AppBloc, AppState>(
          builder: ((context, state) {
            if (state is AppStateLoggedOut) {
              return const LoginView();
            } else if (state is AppStateLoggedIn) {
              return const PhotoGallaryView();
            } else if (state is AppStateIsInRegistrationView) {
              return const RegisterView();
            } else {
              return Container();
            }
          }),
          listener: ((context, state) {
            if (state.isLoading) {
              return LoadingScreen.instance()
                  .show(context: context, text: 'Loading...');
            } else {
              LoadingScreen.instance().hide();
            }
            final authError = state.authError;
            if (authError != null) {
              showAuthError(
                context: context,
                authError: authError,
              );
            }
          }),
        ),
      ),
    );
  }
}
