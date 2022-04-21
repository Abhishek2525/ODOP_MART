/// This is a Utils class used parsing error message
class ApiUtils {
  static String getError(Map<String, dynamic> errors) {
    try {
      if (errors == null) return null;

      List<String> keys = errors.keys.toList();
      print(keys);
      List<String> errorsList = <String>[];
      if (keys.length < 1) return null;
      keys.forEach((element) {
        if (errors[element] is String) {
          errorsList.add(errors[element]);
        } else
          errors[element].forEach((e) {
            errorsList.add(e);
          });
      });

      print(errorsList);
      if (errorsList.length > 0)
        return errorsList.first;
      else
        return null;
    } catch (e, t) {
      print(e);
      print(t);
      return null;
    }
  }
}
