import 'package:bloc_firebase22/bloc/app_bloc.dart';
import 'package:bloc_firebase22/bloc/app_event.dart';
import 'package:bloc_firebase22/bloc/app_state.dart';
import 'package:bloc_firebase22/views/main_popup_menu.dart';
import 'package:bloc_firebase22/views/storage_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGallaryView extends HookWidget {
  const PhotoGallaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(() => ImagePicker(), [key]);

    final images = context.watch<AppBloc>().state.images ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo_Gallery'),
        actions: [
          IconButton(
            onPressed: () async {
              final imag = await picker.pickImage(source: ImageSource.gallery);
              if (imag == null) {
                return;
              }
              context.read<AppBloc>().add(
                    AppEventUploadImage(filPathToUpload: imag.path),
                  );
            },
            icon: const Icon(Icons.upload),
          ),
          const MainPopupMenuButton(),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8),
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        children: images
            .map((img) => StorageImageView(
                  image: img,
                ))
            .toList(),
      ),
    );
  }
}
