
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:islamina_app/core/extensions/media_query_extension.dart';
import 'package:islamina_app/core/utils/app_colors.dart';
import 'package:islamina_app/core/utils/theme/cubit/theme_cubit.dart';
import 'package:islamina_app/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangageDialogWidget extends StatefulWidget {
  const LangageDialogWidget({super.key});

  @override
  State<LangageDialogWidget> createState() => _LangageDialogWidgetState();
}

class _LangageDialogWidgetState extends State<LangageDialogWidget> {
  SharedPreferences prefs = SharedPreferencesService.instance.prefs;
  @override
  void initState() {
  
    super.initState();
    
  }
  int selectedValue = 1;
  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      height: context.getDefaultSize() * 15,
      width: context.getDefaultSize() * 38,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text(
              "English",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Radio<int>(
              value: 1,
              groupValue: prefs.getInt('lang')?? selectedValue,
              onChanged: (value) {
                setState(() {
                  prefs.setInt('lang', 1);

                  BlocProvider.of<ThemeCubit>(context).changeLocale(const Locale('en'));
                });
              },
              fillColor: MaterialStateProperty.all(Get.theme.primaryColor),
              toggleable: true,
            ),
          ),
          // const CustomDividerWidget(thickness: 1.0, whiteSpaceBegin: 15),
          ListTile(
            title: const Text("العربية", style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Radio<int>(
              value: 2,
              groupValue:prefs.getInt('lang')?? selectedValue,
              onChanged: (value) {
                setState(() {
                  prefs.setInt('lang', 2);
                  
                  BlocProvider.of<ThemeCubit>(context).changeLocale(const Locale('ar'));
                });
              },
              fillColor: MaterialStateProperty.all(Get.theme.primaryColor),
              toggleable: true,
            ),
          ),
        ],
      ),
    );
  }
}
