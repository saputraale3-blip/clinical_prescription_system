import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {

  static final supabase =
      Supabase.instance.client;

  // =========================
  // LOGIN
  // =========================

  static Future<String?> login({

    required String username,

    required String password,

  }) async {

    try {

      final email =
          '${username.trim()}@app.com';

      // =========================
      // LOGIN
      // =========================

      final response =
          await supabase.auth
              .signInWithPassword(

        email: email,

        password: password,
      );

      final user =
          response.user;

      if (user == null) {

        return 'Login failed';
      }

      // =========================
      // GET PROFILE
      // =========================

      final profile =
          await supabase

              .from('profiles')

              .select()

              .eq('id', user.id)

              .single();

      // =========================
      // CHECK APPROVED
      // =========================

      final approved =
          profile['approved'] ?? false;

      if (approved != true) {

        // FORCE LOGOUT

        await supabase.auth.signOut();

        return 'Account pending admin approval';
      }

      return null;
    }

    on AuthException catch (e) {

      return e.message;
    }

    catch (e) {

      return e.toString();
    }
  }

  // =========================
  // REGISTER
  // =========================

  static Future<String?> register({

    required String username,

    required String password,

  }) async {

    try {

      final cleanUsername =
          username.trim();

      final email =
          '$cleanUsername@app.com';

      // =========================
      // CREATE AUTH USER
      // =========================

      final response =
          await supabase.auth.signUp(

        email: email,

        password: password,
      );

      final user =
          response.user;

      if (user == null) {

        return 'Register failed';
      }

      // =========================
      // INSERT PROFILE
      // =========================

      await supabase
          .from('profiles')
          .insert({

        'id': user.id,

        'username': cleanUsername,

        'is_admin': false,

        // IMPORTANT

        'approved': false,
      });

      // LOGOUT AFTER REGISTER

      await supabase.auth.signOut();

      return null;
    }

    on AuthException catch (e) {

      return e.message;
    }

    catch (e) {

      return e.toString();
    }
  }

  // =========================
  // LOGOUT
  // =========================

  static Future<void>
      logout() async {

    await supabase.auth.signOut();
  }

  // =========================
  // CHECK ADMIN
  // =========================

  static Future<bool>
      isAdmin() async {

    try {

      final user =
          supabase.auth.currentUser;

      if (user == null) {

        return false;
      }

      final data =
          await supabase

              .from('profiles')

              .select()

              .eq('id', user.id)

              .single();

      return data['is_admin'] ==
          true;
    }

    catch (e) {

      return false;
    }
  }

  // =========================
  // CHECK LOGIN
  // =========================

  static bool isLoggedIn() {

    return supabase.auth.currentUser !=
        null;
  }
}