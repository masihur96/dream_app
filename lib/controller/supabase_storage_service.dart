import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Upload a file and return the download link
  Future<String?> uploadFile(File file, String bucketName) async {
    try {
      // Generate a unique file name
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

      // Upload the file
      await _supabase.storage.from(bucketName).upload(fileName, file);

      // Get the download link
      final downloadLink = _supabase.storage.from(bucketName).getPublicUrl(fileName);
      return downloadLink;
    } catch (e) {
      print("Error uploading file: $e");
      return null;
    }
  }
}