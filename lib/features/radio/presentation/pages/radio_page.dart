import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/features/radio/presentation/blocs/cubit/raido_cubit.dart';
import 'package:islamina_app/features/radio/presentation/pages/radio_player_page.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:country_flags/country_flags.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  final AudioPlayer _player = AudioPlayer();
  Dio dio = Dio();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<RaidoCubit>(context).getAllRadios();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text(context.translate("radio")),
        ),
        body: SizedBox(
          width: Get.width,
          height: double.infinity,

          child: BlocConsumer<RaidoCubit, RaidoState>(

            listener: (context, state) {},
             buildWhen: (previous, current) => current is GetAllRadiosSuccessState || previous is GetAllRadiosLoadingState,
            builder: (context, state) {
              if (state is GetAllRadiosSuccessState) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                      separatorBuilder: (context, index) => const Gap(5),
                      itemCount: state.radios.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            context.read<RaidoCubit>().changeSelectedRadio(index);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RadioPlayerPage(
                                          radioEntity: state.radios[index],
                                        )));

                            // isPlaying ? await stop() : await _init(state.radios[index].audioUrl);
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white, boxShadow: const [BoxShadow(color: Colors.grey, spreadRadius: 0.3, blurRadius: 3)]),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                CountryFlag.fromCountryCode(
                                  state.radios[index].countryCode,
                                  shape: const Circle(),
                                ),
                                const Gap(10),
                                Text(
                                  state.radios[index].title,
                                  style: GoogleFonts.cairo(
                                    color: Colors.black,
                                  ),
                                )
                              ]),
                            ),
                          ),
                        );
                      }),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
}
