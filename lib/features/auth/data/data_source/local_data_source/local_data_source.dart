import 'package:islamina_app/core/constants/cache_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  void saveToken({required String token});
  void removeToken();
}

class LocalDataSourceImpl implements LocalDataSource {
  SharedPreferences sharedPreferences;
  LocalDataSourceImpl({
    required this.sharedPreferences,
  });
  // ignore: constant_identifier_names

  @override
  void saveToken({required String token}) async {
    await sharedPreferences.setString(TOKENID_KEY, token);
  }

  @override
  void removeToken() async {
    await sharedPreferences.remove(TOKENID_KEY);
  }
}
