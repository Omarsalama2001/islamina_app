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
      'text': 'القرآن الكريم',
      'onTap': () {
        Get.find<HomeController>().onDestinationChanged(1);
      },
    },
    {
      'icon': 'assets/svg/collection_icon/hadees.svg',
      'text': 'تسابيح',
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {'pageTitle': 'تسابيح', 'type': AzkarPageType.tasabih},
        );
      },
    },
    {
      'icon': 'assets/svg/collection_icon/duas.svg',
      'text': 'أذكار المسلم',
      'onTap': () {
        Get.toNamed(Routes.AZKAR_CATEGORIES);
      },
    },
    {
      'icon': 'assets/svg/collection_icon/tasbih.svg',
      'text': 'المسبحة الإلكترونية',
      'onTap': () {
        Get.toNamed(Routes.ELECTRONIC_TASBIH);
      },
    },
    {
      'icon': 'assets/svg/collection_icon/allah.svg',
      'text': 'اسماء الله',
      'onTap': () {
        Get.toNamed(Routes.ASMAULLAH_PAGE);
      },
    },
    {
      'icon': 'assets/svg/collection_icon/prayer_time.svg',
      'text': 'أوقات الصلاة',
      'onTap': () {
        Get.find<HomeController>().onDestinationChanged(2);
      },
    },
    {
      'icon': 'assets/svg/collection_icon/kiblat.svg',
      'text': 'القبلة',
      'onTap': () async {
        bool getCameras =
            await Get.put(QiblaController()).getAvailableCameras();
        if (getCameras) {
          Get.toNamed(Routes.QIBLA_PAGE);
        }
      },
    },
    {
      'icon': 'assets/svg/collection_icon/other.svg',
      'text': 'المزيد',
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
      'text': 'المسبحة الإلكترونية',
    },
    {
      'icon': FlutterIslamicIcons.prayer,
      'onTap': () {
        Get.toNamed(Routes.AZKAR_CATEGORIES);
      },
      'text': 'أذكار المسلم',
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
      'text': 'القبلة',
    },
  ];
  static List<Map<String, dynamic>> activities = [
    {
      'icon': FlutterIslamicIcons.allahText,
      'onTap': () {
        Get.toNamed(Routes.ASMAULLAH_PAGE);
      },
      'text': 'اسماء الله الحسنى',
    },
    {
      'icon': FlutterIslamicIcons.tasbih2,
      'onTap': () {
        Get.toNamed(Routes.ELECTRONIC_TASBIH);
      },
      'text': 'المسبحة الإلكترونية',
    },
    {
      'icon': FlutterIslamicIcons.prayer,
      'onTap': () {
        Get.toNamed(Routes.AZKAR_CATEGORIES);
      },
      'text': 'أذكار المسلم',
    },
    {
      'icon': FlutterIslamicIcons.tasbihHand,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {'pageTitle': 'تسابيح', 'type': AzkarPageType.tasabih},
        );
      },
      'text': 'تسابيح',
    },
    {
      'icon': FlutterIslamicIcons.sajadah,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {
            'pageTitle': 'الحمد',
            'type': AzkarPageType.hmd,
          },
        );
      },
      'text': 'الحمد',
    },
    {
      'icon': FlutterIslamicIcons.prayingPerson,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {'pageTitle': 'استغفار', 'type': AzkarPageType.istighfar},
        );
      },
      'text': 'استغفار',
    },
    {
      'icon': FlutterIslamicIcons.qibla2,
      'onTap': () async {
        // Get.toNamed(Routes.QIBLA_PAGE);
        bool getCameras =
            await Get.put(QiblaController()).getAvailableCameras();
        if (getCameras) {
          Get.toNamed(Routes.QIBLA_PAGE);
        }
      },
      'text': 'القبلة',
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
      'text': 'الاربعون النووية',
    },
    {
      'icon': FlutterIslamicIcons.hadji,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {
            'pageTitle': 'أدعية الانبياء',
            'type': AzkarPageType.prophet_dua
          },
        );
      },
      'text': 'أدعية الأنبياء',
    },
    {
      'icon': FlutterIslamicIcons.prayingPerson,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {
            'pageTitle': 'أدعية نبوية',
            'type': AzkarPageType.p_dua,
          },
        );
      },
      'text': 'أدعية نبوية',
    },
    {
      'icon': FlutterIslamicIcons.quran,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {
            'pageTitle': 'أدعية قرآنية',
            'type': AzkarPageType.quran_dua
          },
        );
      },
      'text': 'أدعية قرآنية',
    },
    {
      'icon': FlutterIslamicIcons.prayingPerson,
      'onTap': () {
        Get.toNamed(Routes.AZKAR_DETAILS, arguments: {
          'pageTitle': 'أدعية أخرى',
          'categoryId': 13,
          'type': AzkarPageType.azkar,
        });
      },
      'text': 'أدعية أخرى',
    },
    {
      'icon': FluentIcons.bookmark_search_20_regular,
      'onTap': () {
        Get.toNamed(Routes.QURAN_BOOKMARKS);
      },
      'text': 'العلامات المرجعية',
    },
    {
      'icon': FluentIcons.book_search_20_regular,
      'onTap': () {
        Get.toNamed(Routes.QURAN_SEARCH_VIEW);
      },
      'text': 'بحث في القرآن',
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
      'text': 'اتصل بنا',
    },
    // {
    //   'icon': FluentIcons.share_20_regular,
    //   'onTap': () {},
    //   'text': 'شارك التطبيق',
    // },
  ];
}
