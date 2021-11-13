import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  MySharedPreferences._privateConstructor();

  static final MySharedPreferences instance =
  MySharedPreferences._privateConstructor();


  setUserStringData(String key, String value) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setString(key, value);
  }

  getUserStringData(String key) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getString(key);
  }


  // setUserIntData(String key, int value) async {
  //   SharedPreferences instance = await SharedPreferences.getInstance();
  //   instance.setInt(key, value);
  // }
  //
  // getUserIntData(String key) async {
  //   SharedPreferences instance = await SharedPreferences.getInstance();
  //   return instance.getInt(key);
  // }

}