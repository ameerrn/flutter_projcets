import 'package:bloc_firebase22/bloc/app_bloc.dart';
import 'package:bloc_firebase22/bloc/app_event.dart';
import 'package:bloc_firebase22/extention/if_debugging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RegisterView extends HookWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(
      text: 'am@am.com'.ifDebugging,
    );
    final passwordController = useTextEditingController(
      text: 'am123456'.ifDebugging,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  const InputDecoration(hintText: 'Enter your email here'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              obscuringCharacter: '*',
              decoration:
                  const InputDecoration(hintText: 'Enter your password here'),
            ),
            TextButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                context.read<AppBloc>().add(
                      AppEventRegister(
                        email: email,
                        password: password,
                      ),
                    );
              },
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                context.read<AppBloc>().add(
                      const AppEventGoToLogIn(),
                    );
              },
              child: const Text(
                'Already registerd? Log in here!',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
