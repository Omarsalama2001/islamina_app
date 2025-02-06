import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/widgets/main_elevated_button.dart';
import 'package:islamina_app/features/khatma/presentation/blocs/cubit/khatma_cubit.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/add_khatma_header_with_subtitle.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/khatma_radio_item.dart';

class AddKhatmaPageViewThirdItemWidget extends StatelessWidget {
  const AddKhatmaPageViewThirdItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: BlocBuilder<KhatmaCubit, KhatmaState>(
        builder: (context, state) {
          return Column(children: [
            AddKhatmaHeaderWithSubtitle(
              title: context.translate('calculateKhatmaTitle'),
              subtitle: context.translate('calculateKhatmaSubtitle'),
            ),
            const Gap(15),
            KhatmaRadioItem(
              headerText: context.translate('expectedDurationHeader'),
              subText: context.translate('expectedDurationSubtext'),
              radioValue: 0,
              onChanged: (p0) {
                context.read<KhatmaCubit>().changeKhatamaWayRadioValue(p0!);
              },
              onTap: () {
                context.read<KhatmaCubit>().changeKhatamaWayRadioValue(0);
              },
              groupValue: context.read<KhatmaCubit>().khatmaWayRadioValue,
            ),
            const Gap(10),
            KhatmaRadioItem(
              headerText: context.translate('dailyWerdRateHeader'),
              subText: context.translate('dailyWerdRateSubtext'),
              radioValue: 1,
              groupValue: context.read<KhatmaCubit>().khatmaWayRadioValue,
              onChanged: (p0) {
                context.read<KhatmaCubit>().changeKhatamaWayRadioValue(p0!);
              },
              onTap: () {
                context.read<KhatmaCubit>().changeKhatamaWayRadioValue(1);
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: MainElevatedButton(
                        color: const WidgetStatePropertyAll(Colors.grey),
                        onPressed: () {
                          context.read<KhatmaCubit>().changeAddKhatmaPage(false);
                        },
                        text: context.translate('previousButton')),
                  ),
                ),
                const Gap(5),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: MainElevatedButton(
                        onPressed: () {
                          context.read<KhatmaCubit>().changeAddKhatmaPage(true);
                        },
                        text: context.translate('next')),
                  ),
                ),
              ],
            )
          ]);
        },
      ),
    );
  }
}
