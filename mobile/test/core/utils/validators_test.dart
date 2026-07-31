import 'package:flutter_test/flutter_test.dart';
import 'package:healthify_mobile/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('rejects empty input', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
    });

    test('rejects malformed addresses', () {
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.email('a@b'), isNotNull);
      expect(Validators.email('a b@mail.com'), isNotNull);
    });

    test('accepts valid addresses', () {
      expect(Validators.email('sarah@healthify.app'), isNull);
      expect(Validators.email('thakuri.sumina23@gmail.com'), isNull);
    });
  });

  group('Validators.password', () {
    test('rejects short passwords', () {
      expect(Validators.password('Ab1'), isNotNull);
    });

    test('requires letters and numbers', () {
      expect(Validators.password('onlyletters'), isNotNull);
      expect(Validators.password('12345678'), isNotNull);
    });

    test('accepts a strong password', () {
      expect(Validators.password('Skincare2026'), isNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('rejects mismatch', () {
      expect(Validators.confirmPassword('abc12345', 'different1'), isNotNull);
    });

    test('accepts match', () {
      expect(Validators.confirmPassword('abc12345', 'abc12345'), isNull);
    });
  });

  group('Validators.name', () {
    test('rejects blank and single characters', () {
      expect(Validators.name('  '), isNotNull);
      expect(Validators.name('A'), isNotNull);
    });

    test('accepts a normal name', () {
      expect(Validators.name('Sarah Johnson'), isNull);
    });
  });
}
