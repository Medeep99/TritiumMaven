import 'color_options.dart';
import 'padding_options.dart';
import 'text_style_options.dart';

class ThemeOptions {
  const ThemeOptions({
    required ColorOptions color,
  }) : _colorOptions = color;

  final ColorOptions _colorOptions;

  ColorOptions get color {
    return ColorOptions(
      primary: _colorOptions.primary,
      onPrimary: _colorOptions.onPrimary,
      primaryContainer: _colorOptions.primaryContainer,
      onPrimaryContainer: _colorOptions.onPrimaryContainer,
      secondary: _colorOptions.secondary,
      onSecondary: _colorOptions.onSecondary,
      secondaryContainer: _colorOptions.secondaryContainer,
      onSecondaryContainer: _colorOptions.onSecondaryContainer,
      background: _colorOptions.background,
      surface: _colorOptions.surface,
      onSurface: _colorOptions.onSurface,
      outline: _colorOptions.outline,
      outlineVariant: _colorOptions.outlineVariant,
      onBackground: _colorOptions.onBackground,
      onSurfaceVariant: _colorOptions.onSurfaceVariant,
      success: _colorOptions.success,
      onSuccess: _colorOptions.onSuccess,
      successContainer: _colorOptions.successContainer,
      onSuccessContainer: _colorOptions.onSuccessContainer,
      error: _colorOptions.error,
      onError: _colorOptions.onError,
      errorContainer: _colorOptions.errorContainer,
      onErrorContainer: _colorOptions.onErrorContainer,
      shadow: _colorOptions.shadow,
      warmup: _colorOptions.warmup,
      drop: _colorOptions.drop,
      cooldown: _colorOptions.cooldown,
    );
  }

  TextStyleOptions get textStyle {
    return TextStyleOptions();
  }

  PaddingOptions get padding {
    return const PaddingOptions(
      page: 20,
    );
  }
}
