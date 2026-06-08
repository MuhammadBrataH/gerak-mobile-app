// test/auth_logic_test.dart
// Unit test untuk logika bisnis AuthController - Aplikasi GERAK
// Kelompok 8 - D3 Teknik Informatika POLBAN

import 'package:flutter_test/flutter_test.dart';

// ============================================================
// Helper functions yang di-extract dari AuthController
// (diuji secara isolated tanpa dependency GetX/API)
// ============================================================

bool validatePasswordStrength(String password) {
  return password.length >= 8 &&
      RegExp(r'[A-Za-z]').hasMatch(password) &&
      RegExp(r'\d').hasMatch(password);
}

bool isAllowedEmailDomain(String email) {
  final lower = email.trim().toLowerCase();
  return lower.endsWith('@gmail.com') ||
      lower.endsWith('@googlemail.com') ||
      lower.endsWith('@polban.ac.id');
}

bool isValidEmail(String email) {
  return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());
}

const List<String> communityKeywords = ['xtc', 'polban', 'usf'];

String inferAccountType(String name, String email, String? accountType) {
  if (accountType == 'personal' || accountType == 'community') {
    return accountType!;
  }
  final haystack = '${name} ${email}'.toLowerCase();
  return communityKeywords.any((kw) => haystack.contains(kw))
      ? 'community'
      : 'personal';
}

String buildWhatsAppUrl(String phone, String eventName, String userName) {
  final message = Uri.encodeComponent(
    'Halo, saya $userName ingin join event: $eventName',
  );
  return 'https://wa.me/$phone?text=$message';
}

int calculateSlotsLeft(int maxSlots, int joinedCount) {
  return maxSlots - joinedCount;
}

bool canJoinEvent(int slotsLeft, bool alreadyJoined) {
  return slotsLeft > 0 && !alreadyJoined;
}

// ============================================================
// TEST SUITE
// ============================================================

void main() {
  // -------------------------------------------------------
  // TC-AUTH: Password Validation
  // -------------------------------------------------------
  group('TC-AUTH: validatePasswordStrength()', () {
    test(
      'TC-AUTH-PW-01 [Positive] Password valid (8+ karakter, huruf & angka)',
      () {
        expect(validatePasswordStrength('Gerak123'), isTrue);
        expect(validatePasswordStrength('Password1'), isTrue);
        expect(validatePasswordStrength('abcdefg1'), isTrue);
      },
    );

    test('TC-AUTH-PW-02 [Negative] Password terlalu pendek (< 8 karakter)', () {
      expect(validatePasswordStrength('abc123'), isFalse);
      expect(validatePasswordStrength('Ab1'), isFalse);
    });

    test('TC-AUTH-PW-03 [Negative] Password tanpa angka', () {
      expect(validatePasswordStrength('Gerakolahraga'), isFalse);
      expect(validatePasswordStrength('passwordonly'), isFalse);
    });

    test('TC-AUTH-PW-04 [Negative] Password tanpa huruf', () {
      expect(validatePasswordStrength('12345678'), isFalse);
      expect(validatePasswordStrength('000000000'), isFalse);
    });

    test('TC-AUTH-PW-05 [Edge Case] Password kosong', () {
      expect(validatePasswordStrength(''), isFalse);
    });
  });

  // -------------------------------------------------------
  // TC-AUTH: Email Domain Validation
  // -------------------------------------------------------
  group('TC-AUTH: isAllowedEmailDomain()', () {
    test('TC-AUTH-EM-01 [Positive] Gmail domain diizinkan', () {
      expect(isAllowedEmailDomain('user@gmail.com'), isTrue);
      expect(isAllowedEmailDomain('USER@GMAIL.COM'), isTrue);
    });

    test('TC-AUTH-EM-02 [Positive] Polban domain diizinkan', () {
      expect(isAllowedEmailDomain('ersya@polban.ac.id'), isTrue);
      expect(isAllowedEmailDomain('mahasiswa@polban.ac.id'), isTrue);
    });

    test('TC-AUTH-EM-03 [Positive] Googlemail domain diizinkan', () {
      expect(isAllowedEmailDomain('user@googlemail.com'), isTrue);
    });

    test('TC-AUTH-EM-04 [Negative] Domain lain tidak diizinkan', () {
      expect(isAllowedEmailDomain('user@yahoo.com'), isFalse);
      expect(isAllowedEmailDomain('user@outlook.com'), isFalse);
      expect(isAllowedEmailDomain('user@hotmail.com'), isFalse);
    });

    test('TC-AUTH-EM-05 [Edge Case] Email dengan spasi di depan/belakang', () {
      expect(isAllowedEmailDomain('  user@gmail.com  '), isTrue);
    });
  });

  // -------------------------------------------------------
  // TC-AUTH: Email Format Validation
  // -------------------------------------------------------
  group('TC-AUTH: isValidEmail()', () {
    test('TC-AUTH-FMT-01 [Positive] Format email valid', () {
      expect(isValidEmail('user@gmail.com'), isTrue);
      expect(isValidEmail('ersya.hasby@polban.ac.id'), isTrue);
    });

    test('TC-AUTH-FMT-02 [Negative] Email tanpa @', () {
      expect(isValidEmail('usergmail.com'), isFalse);
    });

    test('TC-AUTH-FMT-03 [Negative] Email tanpa domain', () {
      expect(isValidEmail('user@'), isFalse);
    });

    test('TC-AUTH-FMT-04 [Edge Case] Email kosong', () {
      expect(isValidEmail(''), isFalse);
    });
  });

  // -------------------------------------------------------
  // TC-AUTH: Account Type Inference
  // -------------------------------------------------------
  group('TC-AUTH: inferAccountType()', () {
    test('TC-AUTH-AT-01 [Positive] accountType personal eksplisit', () {
      expect(
        inferAccountType('Budi', 'budi@gmail.com', 'personal'),
        'personal',
      );
    });

    test('TC-AUTH-AT-02 [Positive] accountType community eksplisit', () {
      expect(
        inferAccountType('Tim Futsal', 'tim@gmail.com', 'community'),
        'community',
      );
    });

    test('TC-AUTH-AT-03 [Positive] Nama mengandung keyword komunitas', () {
      expect(
        inferAccountType('UKM USF Polban', 'usf@gmail.com', null),
        'community',
      );
      expect(
        inferAccountType('Komunitas XTC', 'xtc@gmail.com', null),
        'community',
      );
    });

    test('TC-AUTH-AT-04 [Positive] Email mengandung keyword komunitas', () {
      expect(
        inferAccountType('Tim', 'ukm-usf@polban.ac.id', null),
        'community',
      );
    });

    test('TC-AUTH-AT-05 [Negative] Nama & email tidak mengandung keyword', () {
      expect(
        inferAccountType('Ersya Hasby', 'ersya@gmail.com', null),
        'personal',
      );
    });
  });

  // -------------------------------------------------------
  // TC-EVENT: Slot & Join Logic
  // -------------------------------------------------------
  group('TC-EVENT: calculateSlotsLeft()', () {
    test('TC-EVENT-SL-01 [Positive] Slot tersisa dihitung benar', () {
      expect(calculateSlotsLeft(10, 3), 7);
      expect(calculateSlotsLeft(5, 5), 0);
    });

    test('TC-EVENT-SL-02 [Edge Case] Event penuh (0 slot)', () {
      expect(calculateSlotsLeft(10, 10), 0);
    });

    test('TC-EVENT-SL-03 [Edge Case] Belum ada yang join', () {
      expect(calculateSlotsLeft(8, 0), 8);
    });
  });

  group('TC-EVENT: canJoinEvent()', () {
    test(
      'TC-EVENT-JOIN-01 [Positive] Bisa join - slot tersedia & belum join',
      () {
        expect(canJoinEvent(5, false), isTrue);
      },
    );

    test('TC-EVENT-JOIN-02 [Negative] Tidak bisa join - slot penuh', () {
      expect(canJoinEvent(0, false), isFalse);
    });

    test('TC-EVENT-JOIN-03 [Negative] Tidak bisa join - sudah join', () {
      expect(canJoinEvent(5, true), isFalse);
    });

    test('TC-EVENT-JOIN-04 [Edge Case] Slot penuh DAN sudah join', () {
      expect(canJoinEvent(0, true), isFalse);
    });
  });

  // -------------------------------------------------------
  // TC-WA: WhatsApp Smart-Redirect
  // -------------------------------------------------------
  group('TC-WA: buildWhatsAppUrl()', () {
    test('TC-WA-01 [Positive] URL WhatsApp terbentuk dengan benar', () {
      final url = buildWhatsAppUrl(
        '6281234567890',
        'Futsal Open Slot',
        'Ersya',
      );
      expect(url, startsWith('https://wa.me/6281234567890'));
      expect(url, contains('text='));
    });

    test('TC-WA-02 [Positive] Nama event dan user ter-encode di URL', () {
      final url = buildWhatsAppUrl('6281234567890', 'Event Test', 'Brata');
      expect(url, contains('Brata'));
      expect(url, contains('Event%20Test'));
    });

    test('TC-WA-03 [Edge Case] Nama dengan karakter spesial ter-encode', () {
      final url = buildWhatsAppUrl('628111', 'Futsal & Basket', 'User');
      expect(url, isNot(contains('&text='))); // & harus ter-encode
    });
  });
}
