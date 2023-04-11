import 'dart:ui';

import 'package:Maven/theme/m_theme_scheme.dart';
import 'package:Maven/theme/maven_theme_options.dart';

import '../widget/active_exercise_set_theme.dart';
import '../widget/m_bottom_navigation_bar_theme.dart';
import '../widget/m_dialog_theme.dart';
import '../widget/m_flat_button_theme.dart';
import '../widget/m_icon_theme.dart';
import '../widget/m_popup_menu_theme.dart';
import '../widget/m_text_field_theme.dart';
import '../widget/m_text_theme.dart';
import '../widget/template_card_theme.dart';
import '../widget/template_folder_theme.dart';
import '../widget/text_style_theme.dart';

class DarkTheme extends MavenTheme {
  static const Color backgroundColor = Color(0xff121212);
  static const Color textColor = Color(0xffffffff);
  static const Color textDarkColor = Color(0xFF646464);
  static const Color accentColor = Color(0xFF2196F3);

  DarkTheme() : super(
    id: 'dark',
    description: 'A nice thing ',
    options: MavenThemeOptions(
      sidePadding: 20,
      accentColor: accentColor,
      borderColor: const Color(0xFF333333),
      backgroundColor: const Color(0xff121212),
      foregroundColor: const Color(0xFF000000),
      t: TextStyleTheme(
        heading1: textColor,
        heading2: textColor,
        body1: textColor,
        body2: accentColor,
        subtitle1: textDarkColor,
        subtitle2: accentColor,
      ),
      text: MTextTheme(
        primaryColor: const Color(0xFFFFFFFF),
        secondaryColor: const Color(0xFF646464),
        accentColor: const Color(0xFF2196F3),
        whiteColor: const Color(0xFFFFFFFF),
        errorColor: const Color(0xFFDD614A),
      ),
      bottomNavigationBar: MBottomNavigationBarTheme(
        backgroundColor: const Color(0xFF121212),
        selectedItemColor: const Color(0xFF2196F3),
        unselectedItemColor: const Color(0xFF676767),
        shadowColor: const Color(0xFF0C0C0C),
      ),
      icon: MIconTheme(
        primaryColor: const Color(0xFFFFFFFF),
        secondaryColor: const Color(0xFFB6B6B6),
        tertiaryColor: const Color(0xFF797979),
        accentColor: const Color(0xFF2196F3),
        errorColor: const Color(0xFFDD614A),
        completeColor: const Color(0xFF0BDA51),
      ),
      templateFolder: TemplateFolderTheme(
          borderColor: const Color(0xFF333333),
          dragShadowColor: const Color(0xFF838383),
          backgroundColor: const Color(0xFF121212)
      ),
      popupMenu: MPopupMenuTheme(
          backgroundColor: const Color(0xFF000000)
      ),
      dialog: MDialogTheme(
          backgroundColor: const Color(0xFF000000)
      ),
      textField: MTextFieldTheme(
        borderColor: const Color(0xFF333333),
        errorOutlineColor: const Color(0xFFDD614A),
        hintColor: const Color(0xff434343),
        primaryOutlineColor: const Color(0xFF333333),
        backgroundColor: const Color(0xFF2E2E2E),
      ),
      templateCard: TemplateCardTheme(
        backgroundColor: const Color(0xFF121212),
        borderColor: const Color(0xFF333333),
      ),
      flatButton: MFlatButtonTheme(
          completeColor: const Color(0xFF2DCD70),
          errorColor: const Color(0xFFFEABB2)
      ),
      activeExerciseSet: ActiveExerciseSetTheme(
        completeColor: const Color(0xFF003000),
      ),
      sliverNavigationBarBackgroundColor: const Color(0xFF121212),
      handleBarColor: const Color(0xFF505050),
    ),
  );
}