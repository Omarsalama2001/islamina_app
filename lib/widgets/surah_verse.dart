import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:islamina_app/core/utils/theme/cubit/theme_cubit.dart';
import 'package:islamina_app/utils/extension.dart';

class SurahVerseWidget extends StatelessWidget {
  const SurahVerseWidget({
    super.key,
    required this.surah,
    required this.verse,
    this.showSurahName = true,
  });

  final int surah;
  final int verse;
  final bool showSurahName;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), // if you need this
              border: Border.all(
                color:
                    Theme.of(context).colorScheme.onBackground.withAlpha(100),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                // ArabicNumbers().convert(
                //   "$surah:$verse",
                // ),
                "$surah:$verse",
                
                
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
        if (showSurahName) ...{
          const Gap(5),
          Text(
            BlocProvider.of<ThemeCubit>(context).locale.languageCode=='ar'?
            surah.getSurahNameOnlyArabicSimple:surah.getSurahNameEnglish,
            style: const TextStyle(fontSize: 20),
          ),
        
        }
      ],
    );
  }
}
