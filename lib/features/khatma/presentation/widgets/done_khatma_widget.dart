import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/features/khatma/presentation/blocs/cubit/khatma_cubit.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/defult_khatma_widget.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/khatma_item.dart';

class DoneKhatmaWidget extends StatefulWidget {
  const DoneKhatmaWidget({super.key});

  @override
  State<DoneKhatmaWidget> createState() => _DoneKhatmaWidgetState();
}

class _DoneKhatmaWidgetState extends State<DoneKhatmaWidget> {
  @override
  void initState() {
    super.initState();
    context.read<KhatmaCubit>().getDoneKhatma();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KhatmaCubit, KhatmaState>(
      buildWhen: (prev,curr)=>curr is GetAllDoneKhatmaSuccessState || prev is GetAllDoneKhatmaLoadingState,
      builder: (context, state) {
        if (state is GetAllDoneKhatmaLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetAllDoneKhatmaSuccessState && state.khatmaModelList.isNotEmpty) {
          return ListView.separated(
              separatorBuilder: (_, __) => const Gap(15),
              itemCount: state.khatmaModelList.length,
              itemBuilder: (_, index) => KhatmaItem(
                    khatmaModel: state.khatmaModelList[index],
                  ));
        } else {
          return  DefultKhatmaWidget(
            image: 'assets/images/khatma.png',
            title: context.translate("noKhatmaFound"),
          );
        }
      },
    );
  }
}
