import 'package:material_ui/material_ui.dart';

import 'astro_terms.dart';
import 'gen/app_localizations.dart';

export 'astro_terms.dart';
export 'gen/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  AstroTerms get terms => AstroTerms.of(this);
}
