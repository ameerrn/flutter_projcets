import 'dart:io';

import 'package:bloc_firebase22/bloc/app_event.dart';
import 'package:bloc_firebase22/bloc/app_state.dart';
import 'package:bloc_firebase22/utils/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/auth_error.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        ) {
    on<AppEventLogIn>(
      (event, emit) async {
        emit(
          const AppStateLoggedOut(
            isLoading: true,
          ),
        );
        try {
          final userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );

          final user = userCredential.user!;
          final images = await _getImages(user.uid);

          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
              images: images,
            ),
          );
        } on FirebaseAuthException catch (authError) {
          emit(
            AppStateLoggedOut(
              isLoading: false,
              authError: AuthError.from(authError),
            ),
          );
        }
      },
    );

    on<AppEventRegister>(
      (event, emit) async {
        emit(
          const AppStateIsInRegistrationView(
            isLoading: true,
          ),
        );
        try {
          final userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );

          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: userCredential.user!,
              images: const [],
            ),
          );
        } on FirebaseAuthException catch (authError) {
          emit(
            AppStateIsInRegistrationView(
              isLoading: false,
              authError: AuthError.from(authError),
            ),
          );
        }
      },
    );

    on<AppEventGoToLoging>(
      (event, emit) {
        emit(
          const AppStateLoggedOut(isLoading: false),
        );
      },
    );

    on<AppEventGoToLogIn>(
      (event, emit) {
        emit(
          const AppStateIsInRegistrationView(isLoading: false),
        );
      },
    );

    on<AppEventInitialize>(
      (event, emit) async {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          emit(const AppStateLoggedOut(isLoading: false));
        } else {
          final images = await _getImages(currentUser.uid);
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: currentUser,
              images: images,
            ),
          );
        }
      },
    );

    on<AppEventLogOut>(
      (event, emit) async {
        emit(
          const AppStateLoggedOut(
            isLoading: true,
          ),
        );
        await FirebaseAuth.instance.signOut();
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      },
    );

    on<AppEventUploadImage>(
      (event, emit) async {
        final user = state.user;
        if (user == null) {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
          return;
        }

        emit(
          AppStateLoggedIn(
            isLoading: true,
            user: user,
            images: state.images ?? [],
          ),
        );

        final file = File(event.filPathToUpload);
        await uploadImage(file: file, userId: user.uid);
        final images = await _getImages(user.uid);
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: images,
          ),
        );
      },
    );

    on<AppEventDeleteAccount>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
          return;
        }

        emit(
          AppStateLoggedIn(
            isLoading: true,
            user: user,
            images: state.images ?? [],
          ),
        );

        try {
          final folder = await FirebaseStorage.instance.ref(user.uid).listAll();
          for (final item in folder.items) {
            await item.delete().catchError((_) {});
          }
          await FirebaseStorage.instance
              .ref(user.uid)
              .delete()
              .catchError((_) {});

          await user.delete();
          await FirebaseAuth.instance.signOut();
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedIn(
                isLoading: false,
                user: user,
                images: state.images ?? [],
                authError: AuthError.from(e)),
          );
        } on FirebaseException {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        }
      },
    );
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}
