import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:trufi_core/localization/app_localization.dart';
import 'package:trufi_core/localization/language_bloc.dart';
import 'package:trufi_core/default_theme.dart';
import 'package:trufi_core/pages/about/about.dart';
import 'package:trufi_core/pages/feedback/feedback.dart';
import 'package:trufi_core/pages/home/widgets/app_drawer.dart';
import 'package:trufi_core/pages/saved_places/saved_places.dart';
import 'package:trufi_core/pages/tickets/tickets_page.dart';
import 'package:trufi_core/screens/route_navigation/route_navigation.dart';

/// Main Trufi App widget with GoRouter configuration
class TrufiApp extends StatelessWidget {
  const TrufiApp({
    super.key,
    this.title = 'Trufi App',
    this.appName = 'Trufi Transit',
    this.cityName,
    this.urlRepository = 'https://github.com/trufi-association/trufi_core',
    this.urlFeedback = 'https://www.trufi-association.org/',
    this.exploreFaresUrl,
    this.drawer,
    this.customRouterConfig,
    this.supportedLocales = const [
      Locale('en', 'US'),
      Locale('es', 'ES'),
      Locale('pt', 'PT'),
      Locale('pt', 'BR'),
      Locale('de', 'DE'),
      Locale('fr', 'FR'),
    ],
    this.showTicketsInDrawer = true,
    this.drawerHeaderImageUrl,
    this.drawerLogoUrl,
  });

  final String title;
  final String appName;
  final String? cityName;
  final String urlRepository;
  final String urlFeedback;
  final String? exploreFaresUrl;
  final Widget? drawer;
  final GoRouter? customRouterConfig;
  final List<Locale> supportedLocales;
  final bool showTicketsInDrawer;
  final String? drawerHeaderImageUrl;
  final String? drawerLogoUrl;

  @override
  Widget build(BuildContext context) {
    final router = customRouterConfig ?? _buildDefaultRouter();

    return ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalization.localizationsDelegates,
        debugShowCheckedModeBanner: false,
        title: title,
        supportedLocales: supportedLocales,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
      ),
    );
  }

  GoRouter _buildDefaultRouter() {
    return GoRouter(
      debugLogDiagnostics: true,
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) {
            return Scaffold(
              drawer: drawer ??
                  AppDrawer(
                    appName: appName,
                    showTickets: showTicketsInDrawer,
                    headerImageUrl: drawerHeaderImageUrl ??
                        'https://www.trufi-association.org/wp-content/uploads/2021/11/Delhi-autorickshaw-CC-BY-NC-ND-ai_enlarged-tweaked-1800x1200px.jpg',
                    logoUrl: drawerLogoUrl ??
                        'https://trufi.app/wp-content/uploads/2019/02/48.png',
                  ),
              body: const RouteNavigationScreen(),
            );
          },
        ),
        GoRoute(
          path: AboutPage.route,
          name: 'about',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, String>?;
            return CustomTransitionPage(
              key: state.pageKey,
              child: AboutPage(
                appName: extra?['appName'] ?? appName,
                cityName: extra?['cityName'] ?? cityName ?? appName,
                urlRepository: extra?['urlRepository'] ?? urlRepository,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  )),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: FeedbackPage.route,
          name: 'feedback',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, String>?;
            return CustomTransitionPage(
              key: state.pageKey,
              child: FeedbackPage(
                urlFeedback: extra?['urlFeedback'] ?? urlFeedback,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  )),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: SavedPlacesPage.route,
          name: 'saved-places',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const SavedPlacesPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  )),
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          path: TicketsPage.route,
          name: 'tickets',
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, String>?;
            return CustomTransitionPage(
              key: state.pageKey,
              child: TicketsPage(
                exploreFaresUrl: extra?['exploreFaresUrl'] ?? exploreFaresUrl,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  )),
                  child: child,
                );
              },
            );
          },
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              Text(
                '404 - Page not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text('The page "${state.uri}" does not exist.'),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home),
                label: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
