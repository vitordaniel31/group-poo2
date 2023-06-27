import 'package:chargames/author/author.dart';
import 'package:chargames/dashboard/view/dashboard_page.dart';
import 'package:chargames/detail/view/detail_page.dart';
import 'package:chargames/l10n/l10n.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color(0xFF8A2BE2)),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF8A2BE2),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardPage(),
        '/detail': (context) => const DetailPage(),
        '/authors': (context) => const AuthorPage(),
      },
    );
  }
}
