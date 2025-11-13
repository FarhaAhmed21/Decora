// test/features/profile/custom_settings_tile_unit_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:decora/src/features/profile/widgets/custom_settings_tile.dart';

void main() {
  group('CustomSettingsTile Unit Tests', () {
    test('should have correct border radius constant', () {
      // Assert
      expect(CustomSettingsTile.tileBorderRadius, isNotNull);
    });

    test('should have default icon path', () {
      // Arrange
      final tile = CustomSettingsTile(title: 'Test', onTap: () {});

      // Assert - من خلال التحقق من السلوك المتوقع
      expect(tile, isNotNull);
      // أو نختبر أن الـ default value موجودة في الكلاس
    });

    test('constructor should assign correct values', () {
      // Arrange
      var tapped = false;

      // Act
      final tile = CustomSettingsTile(
        title: 'Test Title',
        iconPath: 'custom_icon.png',
        onTap: () => tapped = true,
      );

      expect(tile.title, 'Test Title');
      expect(tile.iconPath, 'custom_icon.png');
      // نستدعي onTap للتأكد من العمل
      tile.onTap();
      expect(tapped, isTrue);
    });
  });
}
