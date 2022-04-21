import 'package:get_storage/get_storage.dart';

import '../../constant/storage_constant.dart';

/// A [Database] utility class [LocalDBUtils]
///
/// Provide methods for saving User Authentication states
/// like, JWT token and others
class LocalDBUtils {
  /// Save JWT token to database using [GetStorage]
  static saveJWTToken(String token) {
    GetStorage getStorage = GetStorage(StorageConstant.authStorage);
    getStorage.write(StorageConstant.jwtToken, token);
  }

  /// Get JWT token from Database
  static String getJWTToken() {
    GetStorage getStorage = GetStorage(StorageConstant.authStorage);
    return getStorage.read(StorageConstant.jwtToken);
  }

  /// Delete JWT token from Database
  static void deleteJWTToken() {
    GetStorage getStorage = GetStorage(StorageConstant.authStorage);
    getStorage.remove(StorageConstant.jwtToken);
  }

  /// save user information
  static saveUserInfo(Map<String, String> userInfo) {
    GetStorage getStorage = GetStorage(StorageConstant.authStorage);
    getStorage.write(StorageConstant.userDetails, userInfo);
  }

  /// Get user info from Database
  static Map<String, dynamic> getUserInfo() {
    GetStorage getStorage = GetStorage(StorageConstant.authStorage);
    return getStorage.read(StorageConstant.userDetails);
  }

  /// Delete user info from Database
  static void deleteUserInfo() {
    GetStorage getStorage = GetStorage(StorageConstant.authStorage);
    getStorage.remove(StorageConstant.userDetails);
  }
  /// save user premium membership status
  static void saveActivePackageId(int isPremiumUser) {
    GetStorage getStorage = GetStorage(StorageConstant.authStorage);
    getStorage.write(StorageConstant.activePackageIdKey, isPremiumUser);
  }

  static int getActivePackageId(){
    GetStorage getStorage = GetStorage(StorageConstant.authStorage);
    return getStorage.read(StorageConstant.activePackageIdKey) as int ?? -1;
  }

  static void deletePackageInformation(){
    GetStorage getStorage = GetStorage(StorageConstant.authStorage);
    getStorage.remove(StorageConstant.activePackageIdKey);
  }
}
