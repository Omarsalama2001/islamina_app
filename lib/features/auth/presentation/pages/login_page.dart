import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamina_app/features/auth/presentation/blocs/cubit/auth_cubit.dart';
import 'package:islamina_app/features/auth/presentation/widgets/login_page_widgets/login_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: const LoginWidget(),
    );
  }
}
