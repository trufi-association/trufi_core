import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trufi_core/localization/app_localization.dart';
import 'package:trufi_core/pages/about/about.dart';
import 'package:trufi_core/pages/feedback/feedback.dart';
import 'package:trufi_core/pages/saved_places/saved_places.dart';
import 'package:trufi_core/pages/tickets/tickets_page.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IconButton(
        onPressed: () {
          _showMenuOptions(context);
        },
        icon: const Icon(Icons.menu),
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.white),
          elevation: WidgetStatePropertyAll(2.0),
          shadowColor: WidgetStatePropertyAll(Colors.black87),
        ),
      ),
    );
  }

  void _showMenuOptions(BuildContext context) {
    final localization = AppLocalization.of(context);
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: theme.colorScheme.surface,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: Image.network(
                      'https://www.trufi-association.org/wp-content/uploads/2021/11/Delhi-autorickshaw-CC-BY-NC-ND-ai_enlarged-tweaked-1800x1200px.jpg',
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      color: Colors.black.withOpacity(0.35),
                    ),
                  ),
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            'https://trufi.app/wp-content/uploads/2019/02/48.png',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Trufi Transit',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.search, color: theme.colorScheme.onSurface),
                title: Text(
                  'Buscar rutas',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(
                  Icons.bookmark,
                  color: theme.colorScheme.onSurface,
                ),
                title: Text(
                  localization.translate(LocalizationKey.yourPlacesMenu),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                onTap: () async {
                  await SavedPlacesPage.navigate(context);
                },
              ),
              ListTile(
                leading: Icon(
                  CupertinoIcons.tickets,
                  color: theme.colorScheme.onSurface,
                ),
                title: Text(
                  'Tickets management',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                onTap: () async {
                  await TicketsPage.navigate(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.feedback_outlined,
                  color: theme.colorScheme.onSurface,
                ),
                title: Text(
                  localization.translate(LocalizationKey.feedbackMenu),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                onTap: () => FeedbackPage.navigate(
                  context,
                  urlFeedback: 'https://www.trufi-association.org/',
                ),
              ),
              ListTile(
                leading: Icon(Icons.info, color: theme.colorScheme.onSurface),
                title: Text(
                  localization.translate(LocalizationKey.aboutUsMenu),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                onTap: () => AboutPage.navigate(
                  context,
                  appName: 'Kigali Movility',
                  cityName: 'Kigali',
                  urlRepository:
                      'https://github.com/trufi-association/trufi_core',
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
