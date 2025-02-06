import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:islamina_app/core/extensions/media_query_extension.dart';
import 'package:islamina_app/core/utils/app_colors.dart';
import 'package:islamina_app/core/utils/theme/app_theme.dart';
import 'package:islamina_app/core/widgets/main_elevated_button.dart';
import 'package:islamina_app/features/khatma/presentation/blocs/cubit/khatma_cubit.dart';
import 'package:islamina_app/features/khatma/presentation/widgets/add_khatma_header_with_subtitle.dart';

class AddKhatmaPageVeiwSecItemWidget extends StatelessWidget {
  AddKhatmaPageVeiwSecItemWidget({super.key});
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
             AddKhatmaHeaderWithSubtitle(
              title: context.translate('chooseKhatmaNameTitle'),
              subtitle: context.translate('chooseKhatmaNameSubtitle'),
            ),
            const Gap(15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefultTextFeild(
                  hintText: context.translate('writeKhatmaNameHint'),
                  keyboardType: TextInputType.text,
                  isMultiline: false,
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return context.translate('khatmaNameValidationError');
                    }
                    return null;
                  },
                  controller: context.read<KhatmaCubit>().khatmaNameController),
            ),
            const Gap(15),
             AddKhatmaHeaderWithSubtitle(
              title: context.translate('khatmaDescriptionTitle'),
              subtitle: context.translate('khatmaDescriptionSubtitle'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefultTextFeild(
                  keyboardType: TextInputType.text,
                  hintText: context.translate('writeKhatmaDescriptionHint'),
                  isMultiline: true,
                 
                  controller: context.read<KhatmaCubit>().khatmaDescriptionController),
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
                        color:const WidgetStatePropertyAll(Colors.grey),
                        onPressed: () {
                          context.read<KhatmaCubit>().changeAddKhatmaPage(false);
                        },
                        text: context.translate('previousButton')),
                  ),
                ),
              const  Gap(5),
                Flexible(
                   flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: MainElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<KhatmaCubit>().changeAddKhatmaPage(true);
                          }
                        },
                        text: context.translate('next')),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DefultTextFeild extends StatelessWidget {
  final bool isMultiline;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;
  final void Function()? onsuffixIconPressed;
  final void Function()? onpressed;
  final void Function(String)? onChanged;
  final Function()? onEditingComplete;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final bool? readOnly;
  const DefultTextFeild({
    Key? key,
    required this.isMultiline,
    required this.hintText,
    required this.controller,
    this.validator,
    this.suffixIcon,
    this.onsuffixIconPressed,
    this.onpressed,
    this.onChanged,
    this.readOnly,
    this.keyboardType, this.onEditingComplete, this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      readOnly: readOnly ?? false,
      onTap: onpressed,
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      focusNode: focusNode, 
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onChanged,
      minLines: isMultiline ? 4 : null, //Normal textInputField will be displayed
      maxLines: isMultiline ? 6 : null, // when user presses enter it will adapt to it
      style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 15.sp, color: Colors.black),
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: appTheme.textTheme.bodyMedium!.copyWith(color: AppColors.greyColor, fontSize: 15.sp),
        contentPadding: EdgeInsets.all(context.getHight(divide: 0.02)),
        suffixIcon: IconButton(
          icon: Icon(
            suffixIcon,
            size: 5.w,
            color: Colors.amber,
          ),
          onPressed: onsuffixIconPressed,
        ),
        fillColor: AppColors.backgroundColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: const BorderSide(color: AppColors.greyColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: const BorderSide(color: AppColors.greyColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: const BorderSide(color: AppColors.greyColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: const BorderSide(color: AppColors.greyColor),
        ),
      ),
    );
  }
}
