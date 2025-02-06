import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/bindings/azkar_categories_binding.dart';
import 'package:islamina_app/controllers/home_controller.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/features/auth/presentation/pages/login_page.dart';
import 'package:islamina_app/features/khatma/presentation/blocs/cubit/khatma_cubit.dart';
import 'package:islamina_app/features/khatma/presentation/pages/add_khatma_page_veiw.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/khatma_main_page_widget.dart';
import 'package:islamina_app/pages/add_khatma_page.dart';
import 'package:islamina_app/pages/home_page.dart';
import 'package:islamina_app/routes/app_pages.dart';

class KhatmaMainPage extends StatelessWidget {
  const KhatmaMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Get.put(HomeController());
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const HomePage()), (route) => false);
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddKhatmaPage()));
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                context.read<KhatmaCubit>().syncKhatmas();
              },
              icon: const Icon(Icons.sync))
        ],
        title: Text(
          context.translate('khatma'),
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ));
  }

  _buildBody() => KhatmaMainPageWidget();
}
