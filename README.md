## Islamina Mobile App

<p align="center">
  <img src="https://raw.githubusercontent.com/Omarsalama2001/islamina_app/main/assets/images/islamina_logo.png" 
       width="300" 
       alt="Islamina Logo"/>
</p>




## 📸 Screenshots

**Mobile View I Implemented**  
<p align="center">
  <!-- Row 1 -->
  <img src="https://raw.githubusercontent.com/Omarsalama2001/islamina_app/main/assets/screenshots/screenshot-1772626258547-portrait.png" width="250"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://raw.githubusercontent.com/Omarsalama2001/islamina_app/main/assets/screenshots/screenshot-1772626320212-portrait.png" width="250"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://raw.githubusercontent.com/Omarsalama2001/islamina_app/main/assets/screenshots/screenshot-1772626361798-portrait.png" width="250"/>
</p>

<br/>

<p align="center">
  <!-- Row 2 -->
  <img src="https://raw.githubusercontent.com/Omarsalama2001/islamina_app/main/assets/screenshots/khatma-portrait.png" width="250"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://raw.githubusercontent.com/Omarsalama2001/islamina_app/main/assets/screenshots/khatma2-portrait.png" width="250"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://raw.githubusercontent.com/Omarsalama2001/islamina_app/main/assets/screenshots/asmaa_allah-portrait.png" width="250"/>
    <img src="https://raw.githubusercontent.com/Omarsalama2001/islamina_app/main/assets/screenshots/radio.png" width="250"/>
</p>

## 📂  Project Structure

Here's how I organized my code (ASCII tree):

<details>
<summary>📂veiw strucure details</summary>

```
📦 lib
 ├── 📄 bloc_observer.dart
 ├── 📄 firebase_options.dart
 ├── 📄 HomeWidgetData.dart
 ├── 📄 init.dart
 ├── 📄 main.dart
 │
 ├── 📂 bindings
 │   ├── 📄 azkar_categories_binding.dart
 │   ├── 📄 azkar_details_binding.dart
 │   ├── 📄 boarding_binding.dart
 │   ├── 📄 e_tasbih_binding.dart
 │   ├── 📄 home_binding.dart
 │   ├── 📄 khatma_binding.dart
 │   ├── 📄 main_binding.dart
 │   ├── 📄 more_activities_binding.dart
 │   ├── 📄 qibla_page_binding.dart
 │   ├── 📄 qibla_vr_binding.dart
 │   ├── 📄 quran_audio_download_manager_binding.dart
 │   ├── 📄 quran_audio_player.dart
 │   ├── 📄 quran_audio_player_settings_binding.dart
 │   ├── 📄 quran_main_dashborad_binding.dart
 │   ├── 📄 quran_reading_view_binding.dart
 │   ├── 📄 quran_search_binding.dart
 │   ├── 📄 quran_settings_binding.dart
 │   ├── 📄 splash_binding.dart
 │   ├── 📄 tafsir_details_binding.dart
 │   └── 📄 tafsir_download_manager_binding.dart
 │
 ├── 📂 constants
 │   ├── 📄 all_activites.dart
 │   ├── 📄 cache_keys.dart
 │   ├── 📄 constants.dart
 │   ├── 📄 enum.dart
 │   ├── 📄 images.dart
 │   ├── 📄 json_path.dart
 │   ├── 📄 save_locations.dart
 │   ├── 📄 themes.dart
 │   └── 📄 urls.dart
 │
 ├── 📂 controllers
 │   ├── 📄 azkar_categories_controller.dart
 │   ├── 📄 azkar_details_controller.dart
 │   ├── 📄 azkar_settings_controller.dart
 │   ├── 📄 e_tasbih_controller.dart
 │   ├── 📄 home_controller.dart
 │   ├── 📄 khatma_controller.dart
 │   ├── 📄 main_controller.dart
 │   ├── 📄 more_activities_controller.dart
 │   ├── 📄 prayer_time_controller.dart
 │   ├── 📄 qibla_page_controller.dart
 │   ├── 📄 qibla_vr_controller.dart
 │   ├── 📄 quran_audio_download_manager_controller.dart
 │   ├── 📄 quran_audio_player_controller.dart
 │   ├── 📄 quran_audio_player_settings_controller.dart
 │   ├── 📄 quran_main_dashborad_controller.dart
 │   ├── 📄 quran_reading_controller.dart
 │   ├── 📄 quran_search_controller.dart
 │   ├── 📄 quran_settings_controller.dart
 │   ├── 📄 tafsir_details_controller.dart
 │   └── 📄 tafsir_download_manager_controller.dart
 │
 ├── 📂 core
 │   ├── 📂 constants
 │   │   └── 📄 cache_keys.dart
 │   ├── 📂 error
 │   │   ├── 📄 exeptions.dart
 │   │   └── 📄 faliure.dart
 │   ├── 📂 extensions
 │   │   ├── 📄 media_query_extension.dart
 │   │   └── 📄 translation_extension.dart
 │   ├── 📂 network
 │   │   ├── 📄 network_info.dart
 │   │   └── 📂 connection
 │   │       └── 📂 bloc
 │   │           ├── 📄 connection_bloc.dart
 │   │           ├── 📄 connection_event.dart
 │   │           └── 📄 connection_states.dart
 │   ├── 📂 strings
 │   │   ├── 📄 faliures.dart
 │   │   └── 📄 messages.dart
 │   ├── 📂 utils
 │   │   ├── 📄 app_colors.dart
 │   │   ├── 📄 size_config.dart
 │   │   ├── 📂 Localization
 │   │   │   ├── 📄 app_localization.dart
 │   │   │   └── 📄 app_localization_setup.dart
 │   │   ├── 📂 styles
 │   │   │   └── 📄 text_styles.dart
 │   │   └── 📂 theme
 │   │       ├── 📄 app_theme.dart
 │   │       └── 📂 cubit
 │   │           ├── 📄 theme_cubit.dart
 │   │           └── 📄 theme_state.dart
 │   └── 📂 widgets
 │       ├── 📄 cusom_header_text_widget.dart
 │       ├── 📄 loading_widget.dart
 │       ├── 📄 main_elevated_button.dart
 │       └── 📄 snack_bar.dart
 │
 ├── 📂 data
 │   ├── 📂 cache
 │   │   ├── 📄 app_settings_cache.dart
 │   │   ├── 📄 audio_settings_cache.dart
 │   │   ├── 📄 azkar_settings_cache.dart
 │   │   ├── 📄 bookmark_cache.dart
 │   │   ├── 📄 prayer_time_cache.dart
 │   │   ├── 📄 quran_reader_cache.dart
 │   │   └── 📄 quran_settings_cache.dart
 │   ├── 📂 models
 │   │   ├── 📄 asmaullah_model.dart
 │   │   ├── 📄 azkar_category_mode.dart
 │   │   ├── 📄 azkar_detail_model.dart
 │   │   ├── 📄 azkar_notification_model.dart
 │   │   ├── 📄 azkar_settings_model.dart
 │   │   ├── 📄 daily_content_model.dart
 │   │   ├── 📄 download_surah_model.dart
 │   │   ├── 📄 e_tasbih.dart
 │   │   ├── 📄 hadith40_model.dart
 │   │   ├── 📄 prayer_time_model.dart
 │   │   ├── 📄 quran_audio_segments.dart
 │   │   ├── 📄 quran_bookmark.dart
 │   │   ├── 📄 quran_navigation_data_model.dart
 │   │   ├── 📄 quran_page.dart
 │   │   ├── 📄 quran_play_range_model.dart
 │   │   ├── 📄 quran_reader.dart
 │   │   ├── 📄 quran_settings_model.dart
 │   │   ├── 📄 quran_simple.dart
 │   │   ├── 📄 quran_verse_model.dart
 │   │   ├── 📄 tafsir.dart
 │   │   └── 📄 tafsir_data.dart
 │   └── 📂 repository
 │       ├── 📄 asmaullah_repository.dart
 │       ├── 📄 azkar_repository.dart
 │       ├── 📄 daily_content_repository.dart
 │       ├── 📄 e_tasbih_repository.dart
 │       ├── 📄 hadith40_repository.dart
 │       ├── 📄 prayer_time_repository.dart
 │       ├── 📄 quran_audio_playlist_repository.dart
 │       ├── 📄 quran_repository.dart
 │       ├── 📄 readers_repository.dart
 │       ├── 📄 segmets_repository.dart
 │       └── 📄 tafsir_repository.dart
 │
 ├── 📂 features
 │   ├── 📂 auth
 │   │   ├── 📂 data
 │   │   │   └── 📂 data_source
 │   │   │       ├── 📄 user_model.dart
 │   │   │       ├── 📂 local_data_source
 │   │   │       │   └── 📄 local_data_source.dart
 │   │   │       └── 📂 remote_data_source
 │   │   │           └── 📄 remote_data_source.dart
 │   │   └── 📂 presentation
 │   │       ├── 📂 blocs
 │   │       │   └── 📂 cubit
 │   │       │       ├── 📄 auth_cubit.dart
 │   │       │       └── 📄 auth_state.dart
 │   │       ├── 📂 pages
 │   │       │   └── 📄 login_page.dart
 │   │       └── 📂 widgets
 │   │           ├── 📄 google_signin_button.dart
 │   │           └── 📂 login_page_widgets
 │   │               └── 📄 login_widget.dart
 │   ├── 📂 khatma
 │   │   ├── 📂 data
 │   │   │   ├── 📂 data_sources
 │   │   │   ├── 📂 models
 │   │   │   │   └── 📄 khatma_model.dart
 │   │   │   └── 📂 repositories_impl
 │   │   ├── 📂 domain
 │   │   │   ├── 📂 entities
 │   │   │   ├── 📂 repositories
 │   │   │   └── 📂 use_cases
 │   │   └── 📂 presentation
 │   │       ├── 📂 blocs
 │   │       │   └── 📂 cubit
 │   │       │       ├── 📄 khatma_cubit.dart
 │   │       │       └── 📄 khatma_state.dart
 │   │       ├── 📂 pages
 │   │       │   ├── 📄 add_khatma_page.dart
 │   │       │   ├── 📄 add_khatma_page_veiw.dart
 │   │       │   └── 📄 khatma_main_page.dart
 │   │       └── 📂 widgets
 │   │           ├── 📄 add_khatma_chips.dart
 │   │           ├── 📄 add_khatma_header.dart
 │   │           ├── 📄 khatma_item.dart
 │   │           └── 📄 khatma_main_page_widget.dart
 │   ├── 📂 on_boarding
 │   │   └── 📂 presentation
 │   │       ├── 📂 cubit
 │   │       │   ├── 📄 on_boarding_cubit.dart
 │   │       │   └── 📄 on_boarding_state.dart
 │   │       ├── 📂 pages
 │   │       │   └── 📄 on_boarding_screen.dart
 │   │       └── 📂 widgets
 │   │           ├── 📄 custom_skip_button_widget.dart
 │   │           ├── 📄 lang_widget.dart
 │   │           └── 📄 on_boarding_widget.dart
 │   ├── 📂 radio
 │   │   ├── 📂 data
 │   │   │   ├── 📂 data_sources
 │   │   │   ├── 📂 models
 │   │   │   │   └── 📄 radio_model.dart
 │   │   │   └── 📂 repositories_impl
 │   │   ├── 📂 domain
 │   │   │   ├── 📂 entities
 │   │   │   │   └── 📄 radio_entity.dart
 │   │   │   ├── 📂 repositories
 │   │   │   └── 📂 use_cases
 │   │   └── 📂 presentation
 │   │       ├── 📂 blocs
 │   │       │   └── 📂 cubit
 │   │       │       ├── 📄 raido_cubit.dart
 │   │       │       └── 📄 raido_state.dart
 │   │       └── 📂 pages
 │   │           ├── 📄 radio_page.dart
 │   │           └── 📄 radio_player_page.dart
 │   └── 📂 sebha
 │       ├── 📂 pages
 │       │   └── 📄 sebha_page.dart
 │       └── 📂 widgets
 │           ├── 📄 drawer_item_widget.dart
 │           ├── 📄 modal_sheet_item_widget.dart
 │           ├── 📄 sebha_widget.dart
 │           └── 📄 sebha_widget_counter.dart
 │
 ├── 📂 generated
 │   ├── 📄 l10n.dart
 │   └── 📂 intl
 │       ├── 📄 messages_all.dart
 │       ├── 📄 messages_ar.dart
 │       └── 📄 messages_en.dart
 │
 ├── 📂 handlers
 │   ├── 📄 notification_alarm_handler.dart
 │   ├── 📄 quran_audio_download_handler.dart
 │   ├── 📄 quran_audio_player_handler.dart
 │   ├── 📄 reader_timing_data_download_handler.dart
 │   └── 📄 tafsir_download_handler.dart
 │
 ├── 📂 pages
 │   ├── 📄 home_page.dart
 │   ├── 📄 main_page.dart
 │   ├── 📄 splash_screen.dart
 │   ├── 📄 quran_main_dashborad_page.dart
 │   ├── 📄 quran_reading_page.dart
 │   ├── 📄 prayer_time_page.dart
 │   ├── 📄 qibla_page.dart
 │   └── 📄 more_activities_page.dart
 │
 ├── 📂 routes
 │   ├── 📄 app_pages.dart
 │   └── 📄 app_routes.dart
 │
 ├── 📂 services
 │   ├── 📄 database_service.dart
 │   ├── 📄 download_service.dart
 │   ├── 📄 notification_service.dart
 │   ├── 📄 shared_preferences_service.dart
 │   └── 📂 audio
 │       ├── 📄 audio_download_service.dart
 │       ├── 📄 audio_manager.dart
 │       └── 📄 setup_audio.dart
 │
 ├── 📂 utils
 │   ├── 📄 extension.dart
 │   ├── 📄 quran_utils.dart
 │   ├── 📄 utils.dart
 │   ├── 📂 dialogs
 │   │   ├── 📄 dialogs.dart
 │   │   └── 📄 select_madhab_dialog.dart
 │   └── 📂 sheets
 │       ├── 📄 ayah_bottom_sheet.dart
 │       └── 📄 sheet_methods.dart
 │
 ├── 📂 views
 │   ├── 📄 asmaullah_page_view.dart
 │   ├── 📄 hizb_list_view.dart
 │   ├── 📄 juz_list_view.dart
 │   ├── 📄 quran_bookmarks_view.dart
 │   ├── 📄 quran_search_view.dart
 │   └── 📄 surah_list_view.dart
 │
 └── 📂 widgets
     ├── 📄 animated_circular_progress_indicator.dart
     ├── 📄 arabic_timer_widget.dart
     ├── 📄 custom_button_big_icon.dart
     ├── 📄 custom_container.dart
     ├── 📄 daily_content_widget.dart
     ├── 📄 e_tasbih_widget.dart
     ├── 📄 quran_tab_bar.dart
     └── 📄 zkr_widget.dart
```

</details>




## ✨ Features

<table>
  <tr>
    <td align="center" width="50%">
      <h3>🕌 Prayer Times</h3>
      <p>Accurate daily prayer times based on your current location with multiple calculation methods and Madhab support</p>
    </td>
    <td align="center" width="50%">
      <h3>📖 Holy Quran</h3>
      <p>Full Quran with a smooth and beautiful reading experience, supporting multiple fonts and display settings</p>
    </td>
  </tr>
  <tr>
    <td align="center" width="50%">
      <h3>🎙️ Quran Audio Player</h3>
      <p>Listen to the Holy Quran with <strong>10+ world-renowned reciters</strong> with full playback controls </p>
    </td>
    <td align="center" width="50%">
      <h3>📚 Quran Tafsir</h3>
      <p>Quran Tafsir available in <strong>different languages</strong> for a deeper understanding of the Quran</p>
    </td>
  </tr>
  <tr>
    <td align="center" width="50%">
      <h3>📿 Digital Tasbih</h3>
      <p>Animated digital Tasbih that feels like a real one, with customizable Azkar and counter settings</p>
    </td>
    <td align="center" width="50%">
      <h3>📔 Khatma Tracker</h3>
      <p>Track your Quran reading progress with <strong>cloud sync</strong> across all your devices using the same account</p>
    </td>
  </tr>
  <tr>
    <td align="center" width="50%">
      <h3>🧭 Qibla Finder</h3>
      <p>Accurate Qibla direction with real-time compass and distance from the Holy Mosque in Makkah</p>
    </td>
    <td align="center" width="50%">
      <h3>📻 Quran Radio</h3>
      <p>Live streaming of the most famous Quran radio stations including <strong>Egypt, Saudi Arabia</strong> and more</p>
    </td>
  </tr>
</table>

---

## 🔗 Related Projects

<table>
  <tr>
    <td align="center" width="100%">
      <h3>📻 Quran Radio Backend</h3>
      <img src="https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white"/>
      <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white"/>
      <img src="https://img.shields.io/badge/Vercel-000000?style=for-the-badge&logo=vercel&logoColor=white"/>
      <br/><br/>
      <p>
        A dedicated <strong>FastAPI</strong> backend that powers the Quran Radio feature,
        providing live streaming from the most famous Islamic radio stations
        around the world 🌍
      </p>
      <a href="https://github.com/Omarsalama2001/islamina1">
        <img src="https://img.shields.io/badge/View_Backend_Repo-181717?style=for-the-badge&logo=github&logoColor=white"/>
      </a>
      &nbsp;
      <a href="https://islamina1-68jbw7rmy-omarsalama2001s-projects.vercel.app/?vercelToolbarCode=nb7OGz7VpUfDpfF">
        <img src="https://img.shields.io/badge/Live_API-success?style=for-the-badge&logo=vercel&logoColor=white"/>
      </a>
    </td>
  </tr>
</table>

---


