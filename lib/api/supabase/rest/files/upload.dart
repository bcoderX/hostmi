import 'dart:io';

import 'package:hostmi/api/supabase/supabase_client.dart';

Future<String?> uploadFile(File file, String storagePath) async {
  // String fileName = file.path.split(Platform.pathSeparator).last;
  // final storagePath = 'user_uploads/$userId/$fileName';
  try {
    final response =
        await supabase.storage.from('public').upload(storagePath, file);
    return response;
  } catch (error) {
    return null;
  }
}
