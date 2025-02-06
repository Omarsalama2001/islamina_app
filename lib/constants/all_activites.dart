import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:islamina_app/controllers/home_controller.dart';
import 'package:islamina_app/controllers/qibla_page_controller.dart';
import 'package:islamina_app/pages/hadith40_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../routes/app_pages.dart';
import 'enum.dart';

class Activites {
  static List<Map<String, dynamic>> shortcuts2 = [
    {
      'icon': 'assets/svg/collection_icon/quran.svg',
      'text': 'quran',
      'onTap': () {
        Get.find<HomeController>().onDestinationChanged(1);
      },
    },
    {
      'icon': 'assets/svg/collection_icon/hadees.svg',
      'text': 'tasabih',
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {'pageTitle': 'tasabih', 'type': AzkarPageType.tasabih},
        );
      },
    },
    {
      'icon': 'assets/svg/collection_icon/duas.svg',
      'text': 'azkarCategories',
      'onTap': () {
        Get.toNamed(Routes.AZKAR_CATEGORIES);
      },
    },

    {
      'icon': 'assets/svg/collection_icon/tasbih.svg',
      'text': 'eTasbih',
      'onTap': () {
        Get.toNamed(Routes.sebha);
      },
    },
    // {
    //   'icon': 'assets/svg/collection_icon/allah.svg',
    //   'text': 'اسماء الله',
    //   'onTap': () {
    //     Get.toNamed(Routes.ASMAULLAH_PAGE);
    //   },
    // },
    {
      'icon': 'assets/svg/collection_icon/tasbih.svg',
      'text': 'khatma',
      'onTap': () {
        Get.toNamed(Routes.KHATMA);
      },
    },
    {
      'icon': 'assets/svg/collection_icon/prayer_time.svg',
      'text': 'prayerTimes',
      'onTap': () {
        Get.find<HomeController>().onDestinationChanged(2);
      },
    },
    {
      'icon': 'assets/svg/collection_icon/kiblat.svg',
      'text': 'qibla',
      'onTap': () async {
        bool getCameras = await Get.put(QiblaController()).getAvailableCameras();
        if (getCameras) {
          Get.toNamed(Routes.QIBLA_PAGE);
        }
      },
    },
    {
      'icon': 'assets/svg/collection_icon/other.svg',
      'text': 'more',
      'onTap': () {
        Get.find<HomeController>().onDestinationChanged(3);
      },
    },
  ];
  static List<Map<String, dynamic>> shortcuts = [
    {
      'icon': FlutterIslamicIcons.tasbih2,
      'onTap': () {
        Get.toNamed(Routes.ELECTRONIC_TASBIH);
      },
      'text': 'eTasbih',
    },
    {
      'icon': FlutterIslamicIcons.prayer,
      'onTap': () {
        Get.toNamed(Routes.AZKAR_CATEGORIES);
      },
      'text': 'azkarCategories',
    },
    {
      'icon': FlutterIslamicIcons.allahText,
      'onTap': () {
        Get.toNamed(Routes.ASMAULLAH_PAGE);
      },
      'text': 'اسماء الله الحسنى',
    },
    {
      'icon': FlutterIslamicIcons.prayingPerson,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {
            'pageTitle': 'استغفار',
            'type': AzkarPageType.istighfar,
          },
        );
      },
      'text': 'استغفار',
    },
    {
      'icon': FluentIcons.bookmark_search_20_regular,
      'onTap': () {
        Get.toNamed(Routes.QURAN_BOOKMARKS);
      },
      'text': 'العلامات المرجعية',
    },
    {
      'icon': FlutterIslamicIcons.qibla2,
      'onTap': () {
        Get.toNamed(Routes.QIBLA_PAGE);
      },
      'text': 'qibla',
    },
  ];
  static List<Map<String, dynamic>> activities = [
    {
      'icon': FlutterIslamicIcons.allahText,
      'onTap': () {
        Get.toNamed(Routes.ASMAULLAH_PAGE);
      },
      'text': 'asmaullah',
    },
    {
      'icon': FlutterIslamicIcons.tasbih2,
      'onTap': () {
        Get.toNamed(Routes.ELECTRONIC_TASBIH);
      },
      'text': "eTasbih",
    },
    {
      'icon': FlutterIslamicIcons.prayer,
      'onTap': () {
        Get.toNamed(Routes.AZKAR_CATEGORIES);
      },
      'text':  "azkarCategories",
    },
    {
      'icon': FlutterIslamicIcons.tasbihHand,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {'pageTitle': "tasabih", 'type': AzkarPageType.tasabih},
        );
      },
      'text':"tasabih",
    },
    {
      'icon': FlutterIslamicIcons.sajadah,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {
            'pageTitle': "hmd",
            'type': AzkarPageType.hmd,
          },
        );
      },
      'text': "hmd",
    },
    {
      'icon': FlutterIslamicIcons.prayingPerson,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {'pageTitle':"istighfar", 'type': AzkarPageType.istighfar},
        );
      },
      'text': "istighfar",
    },
    {
      'icon': FlutterIslamicIcons.qibla2,
      'onTap': () async {
        // Get.toNamed(Routes.QIBLA_PAGE);
        bool getCameras = await Get.put(QiblaController()).getAvailableCameras();
        if (getCameras) {
          Get.toNamed(Routes.QIBLA_PAGE);
        }
      },
      'text': 'qibla',
    },
    // {
    //   'icon': FlutterIslamicIcons.qibla,
    //   'onTap': () async {
    //     await availableCameras().then((value) {
    //       Get.to(QiblaVrPage(cameras: value));
    //     }).catchError((_) {
    //       //* handle this case
    //     });
    //   },
    //   'text': 'قبلة الواقع المعزز',
    // },
    {
      'icon': FlutterIslamicIcons.quran2,
      'onTap': () {
        Get.to(() => const Hadith40Page());
      },
      'text':"hadith40",
    },
    {
      'icon': FlutterIslamicIcons.hadji,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {'pageTitle': "prophetDua", 'type': AzkarPageType.prophet_dua},
        );
      },
      'text': "prophetDua",
    },
    {
      'icon': FlutterIslamicIcons.prayingPerson,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {
            'pageTitle': "pDua",
            'type': AzkarPageType.p_dua,
          },
        );
      },
      'text':    "pDua" ,
    },
    {
      'icon': FlutterIslamicIcons.quran,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {'pageTitle': "quranDua", 'type': AzkarPageType.quran_dua},
        );
      },
      'text': "quranDua",
    },
    {
      'icon': FlutterIslamicIcons.prayingPerson,
      'onTap': () {
        Get.toNamed(Routes.AZKAR_DETAILS, arguments: {
          'pageTitle': 'anotherDua',
          'categoryId': 13,
          'type': AzkarPageType.azkar,
        });
      },
      'text': 'anotherDua',
    },
    {
      'icon': FluentIcons.bookmark_search_20_regular,
      'onTap': () {
        Get.toNamed(Routes.QURAN_BOOKMARKS);
      },
      'text': 'quranBookMarks',
    },
    {
      'icon': FluentIcons.book_search_20_regular,
      'onTap': () {
        Get.toNamed(Routes.QURAN_SEARCH_VIEW);
      },
      'text': 'quranSearch',
    },
      {
      'icon': FluentIcons.radio_button_16_filled,
      'onTap': () {
        Get.toNamed(Routes.radio);
      },
      'text': 'radio',
    },
    // {
    //   'icon': FluentIcons.note_add_20_regular,
    //   // 'icon': FluentIcons.book_add_20_regular,
    //   'onTap': () {
    //     Get.toNamed(Routes.KHATMA);
    //   },
    //   'text': 'الختمة',
    // },
    {
      'icon': Icons.contact_support_outlined,
      'onTap': () async {
        // support@islamina.com
        final url = Uri(scheme: 'mailto', path: 'support@islamina.com');
        if (await canLaunchUrl(url)) {
          launchUrl(
            url,
            // mode: LaunchMode.externalApplication,
          );
        }
      },
      'text': 'contactUs',
    },
    // {
    //   'icon': FluentIcons.share_20_regular,
    //   'onTap': () {},
    //   'text': 'شارك التطبيق',
    // },
  ];
}
