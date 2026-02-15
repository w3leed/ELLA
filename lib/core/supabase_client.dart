import 'package:supabase_flutter/supabase_flutter.dart';

/// 🧩 Supabase Client Manager
/// Handles initialization and provides an easy global access point.
class SupabaseManager {
  // ✅ Initialize Supabase connection
  static Future<void> init() async {
    // ⚙️ Put your actual URL and Anon Key below
    const supabaseUrl = 'https://ztbsjnpqmqzeszyodpcb.supabase.co';
    const supabaseAnonKey =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp0YnNqbnBxbXF6ZXN6eW9kcGNiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzExMzgyMTEsImV4cCI6MjA4NjcxNDIxMX0.LnCltsqQcPVpZi9W3mcDVMSG2Ym9yJqavCGCefrCu10';

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  /// 🧠 Shortcuts
  static SupabaseClient get client => Supabase.instance.client;

  /// 🔍 Example: get all users
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await client.from('users').select();
    return List<Map<String, dynamic>>.from(response);
  }

  /// ➕ Example: add new user manually (since you’re not using Supabase Auth)
  static Future<void> insertUser(Map<String, dynamic> data) async {
    await client.from('users').insert(data);
  }

  /// 🔑 Example: login check manually
  static Future<Map<String, dynamic>?> loginUser(
      String email, String password) async {
    final response = await client
        .from('users')
        .select()
        .eq('email', email)
        .eq('password', password)
        .maybeSingle();

    return response;
  }

  /// 🚪 Example: update profile
  static Future<void> updateUser(int id, Map<String, dynamic> data) async {
    await client.from('users').update(data).eq('id', id);
  }
}
