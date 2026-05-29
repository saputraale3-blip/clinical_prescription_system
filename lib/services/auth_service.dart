import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {

  static final supabase =
      Supabase.instance.client;

  static String? currentUsername;

  static String currentRole = 'user';

  static DateTime? trialStart;

  static bool currentAiAllowed = false;

  static int currentAiChatCount = 0;

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
      // SAVE ROLE
      // =========================

      currentRole =
          profile['role'] ?? 'user';

      currentUsername =
          profile['username'] ?? 'Guest';

      // =========================
      // SAVE TRIAL START
      // =========================

      if (profile['trial_start'] != null) {

        trialStart = DateTime.parse(
          profile['trial_start'],
        );
      }

      // =========================
      // CHECK AI ACCESS
      // =========================

      currentAiAllowed = false;

currentAiChatCount =
    profile['ai_chat_count'] ?? 0;

    final lastReset =
    profile['ai_last_reset'];

if (lastReset != null) {

  final resetDate =
      DateTime.parse(lastReset);

  final now = DateTime.now();

  final isDifferentDay =
      now.day != resetDate.day ||
      now.month != resetDate.month ||
      now.year != resetDate.year;

  if (isDifferentDay) {

    await supabase
        .from('profiles')
        .update({

      'ai_chat_count': 0,

      'ai_last_reset':
          now.toIso8601String(),

    }).eq('id', user.id);

    currentAiChatCount = 0;
  }
}
    
      if (currentRole == 'pro' ||
          currentRole == 'admin') {

        currentAiAllowed = true;
      }

      // =========================
      // CHECK APPROVED
      // =========================

      final approved =
          profile['approved'] ?? false;

      if (approved != true) {

        await supabase.auth.signOut();

        return 'Account pending admin approval';
      }

      return null;

    } on AuthException catch (e) {

      return e.message;

    } catch (e) {

      return e.toString();
    }
  }

  // =========================
  // REGISTER
  // =========================

  static Future<String?> register({

  required String username,

  required String password,

  required String phone,

}) async {

    try {

      final cleanUsername =
          username.trim();

      final email =
          '$cleanUsername@app.com';

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

      await supabase
          .from('profiles')
          .insert({

        'id': user.id,

        'username': cleanUsername,

        'phone': phone,

        'is_admin': false,

        'role': 'user',

        'trial_start':
            DateTime.now()
                .toIso8601String(),

        'approved': false,
      });

      await supabase.auth.signOut();

      return null;

    } on AuthException catch (e) {

      return e.message;

    } catch (e) {

      return e.toString();
    }
  }

  // =========================
  // LOGOUT
  // =========================

  static Future<void> logout() async {

    await supabase.auth.signOut();
  }

  // =========================
  // CHECK ADMIN
  // =========================

  static Future<bool> isAdmin() async {

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

      return data['is_admin'] == true;

    } catch (e) {

      return false;
    }
  }

  // =========================
  // CHECK LOGIN
  // =========================

  static bool isLoggedIn() {

    return supabase.auth.currentUser != null;
  }

  // =========================
  // CHECK USER TRIAL EXPIRED
  // =========================

  static bool isUserTrialExpired() {

    if (currentRole != 'user') {

      return false;
    }

    if (trialStart == null) {

      return true;
    }

    final expiredDate =
        trialStart!.add(
      const Duration(days: 3),
    );

    return DateTime.now()
        .isAfter(expiredDate);
  }
  static bool isAiLimitReached() {

  return currentAiChatCount >= 30;
}
}