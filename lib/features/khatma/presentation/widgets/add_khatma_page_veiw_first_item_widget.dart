import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/widgets/main_elevated_button.dart';
import 'package:islamina_app/features/khatma/presentation/blocs/cubit/khatma_cubit.dart';
import 'package:islamina_app/features/khatma/presentation/pages/add_khatma_page_veiw.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/add_khatma_chips.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/add_khatma_header.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/add_khatma_header_with_subtitle.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/khatma_radio_item.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddKhatmaPageViewFirstItemWidget extends StatelessWidget {
  const AddKhatmaPageViewFirstItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: BlocBuilder<KhatmaCubit, KhatmaState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               AddKhatmaHeader(
                withDash: true,
                title:context.translate("iWillreadmyWerdthrough") ,// "addKhatma",
              ),
               Gap(0.5.h),
              KhatmaRadioItem(
                headerText: context.translate("app'sMoshaf"),
                subText:context.translate("app'sMoshafDescription") ,
                radioValue: 0,
                groupValue: context.read<KhatmaCubit>().khatamaRadioValue,
                onChanged: (p0) {
                  context.read<KhatmaCubit>().changeKhatamaRadioValue(p0!);
                },
                onTap: () {
                  context.read<KhatmaCubit>().changeKhatamaRadioValue(0);
                },
              ),
               Gap(0.7.h),
              KhatmaRadioItem(
                headerText: context.translate("ownMoshaf"),
                subText: context.translate("ownMoshafDescription"),
                radioValue: 1,
                groupValue: context.read<KhatmaCubit>().khatamaRadioValue,
                onChanged: (p0) {
                  context.read<KhatmaCubit>().changeKhatamaRadioValue(p0!);
                },
                onTap: () {
                  context.read<KhatmaCubit>().changeKhatamaRadioValue(1);
                },
              ),
               Gap(0.5.h),
               AddKhatmaHeaderWithSubtitle(
                title: context.translate("thepurposeoftheKhatma"),
                subtitle: context.translate("thepurposeoftheKhatmaDescription"),
              ),
               Gap(0.5.h),
              const AddKhatmaChips(),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: MainElevatedButton(
                  text: context.translate("next"),
                  onPressed: () {
                    context.read<KhatmaCubit>().changeAddKhatmaPage(true);
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
