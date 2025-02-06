import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/widgets/main_elevated_button.dart';
import 'package:islamina_app/features/khatma/presentation/blocs/cubit/khatma_cubit.dart';
import 'package:islamina_app/features/khatma/presentation/pages/add_khatma_page_veiw.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/defult_khatma_widget.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/khatma_item.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AllKhatmaWidget extends StatefulWidget {
  const AllKhatmaWidget({super.key});

  @override
  State<AllKhatmaWidget> createState() => _AllKhatmaWidgetState();
}

class _AllKhatmaWidgetState extends State<AllKhatmaWidget> {
  @override
  void initState() {
    super.initState();
    context.read<KhatmaCubit>().getAllKhatma();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<KhatmaCubit, KhatmaState>(
      listener: (context, state) {
     if (state is SyncKhatmaLoadingState){
      QuickAlert.show(context: context, type: QuickAlertType.loading, text: context.translate("syncing"),);
     } 
        if (state is SyncKhatmaSuccessState || state is SyncKhatmaErrorState) {
          Get.back();
        }
      },
      child: BlocBuilder<KhatmaCubit, KhatmaState>(
          buildWhen: (previous, current) =>
              (current is GetAllKhatmaSuccessState || previous is GetAllKhatmaLoadingState) ,
          builder: (context, state) {
            if (state is GetAllKhatmaSuccessState &&context.read<KhatmaCubit>().khatmas.isNotEmpty) {
              return ListView.separated(
                  separatorBuilder: (_, __) => const Gap(15),
                  itemCount: context.read<KhatmaCubit>().khatmas.length,
                  itemBuilder: (_, index) => KhatmaItem(
                        khatmaModel: context.read<KhatmaCubit>().khatmas[index],
                      ));
            } else if (state is GetAllKhatmaLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                 DefultKhatmaWidget(
                  image: 'assets/images/khatma.png',
                  title:context.translate("khatmaslogan") ,// "khatmaslogan",
                ),
                const Gap(150),
                MainElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AddKhatmaPage()));
                    },
                    text: context.translate("createNewKhatma"))
              ]),
            );
          },
        ),
    );
  }
}
