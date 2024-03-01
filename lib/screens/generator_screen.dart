import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_generator/data/categories_data.dart';
import 'package:hobby_generator/riverpod/bookmark_provider.dart';
import 'package:hobby_generator/riverpod/hobby_state.dart';
import 'package:hobby_generator/screens/widgets/button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class GeneratorScreen extends ConsumerWidget {
  const GeneratorScreen({super.key});

  final String hobbyName = '';
  final String hobbyLink = '';
  final String hobbyCategory = '';
  final bool isLoading = false;
  final bool isLoaded = false;
  void _getHobby(String categoryPath, WidgetRef ref) {
    ref.read(hobbyNotifierProvider.notifier).fetchHobby(categoryPath);
  }

  Future<void> launchInBrowser(String urlString) async {
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      log('Could not launch $urlString');
    }
  }

  Future<void> launchURL(String urlString) async {
    final Uri? url = Uri.tryParse(urlString);
    if (url == null) {
      log('Invalid URL: $urlString');
      return;
    }

    bool launched = await canLaunchUrl(url);
    if (launched) {
      await launchUrl(url);
      log('Successfully launched URL: $urlString');
    } else {
      log('Could not launch URL: $urlString');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hobbyState = ref.watch(hobbyNotifierProvider);
    bool isFavorite = false;
    if (hobbyState.hobby != null) {
      isFavorite = ref
          .watch(favoritesProvider)
          .any((hobby) => hobby.name == hobbyState.hobby!.name);
    }

    return Scaffold(
      backgroundColor: Colors.amber,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hobbyState.isLoading) ...[
                  const CircularProgressIndicator(),
                ] else if (hobbyState.hobby != null) ...[
                  Text(
                    hobbyState.hobby!.name,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    hobbyState.hobby!.category,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  IconButton(
                    onPressed: () {
                      if (isFavorite) {
                        ref
                            .read(favoritesProvider.notifier)
                            .removeFavorite(hobbyState.hobby!);
                      } else {
                        ref
                            .read(favoritesProvider.notifier)
                            .addFavorite(hobbyState.hobby!);
                      }
                    },
                    icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 60),
                  ),
                  const SizedBox(height: 20),
                  ButtonWidget(
                      onPressed: () => launchInBrowser(hobbyState.hobby!.link),
                      buttonText: "More Information"),
                  const SizedBox(height: 20),
                  ButtonWidget(
                      onPressed: () =>
                          ref.read(hobbyNotifierProvider.notifier).clearHobby(),
                      buttonText: "Create New Hobby"),
                ] else ...[
                  // Welcome message and category selection buttons are shown initially
                  const Text(
                    "Welcome to hobby generator!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Choose a category for your new hobby!",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ...categoryList
                      .map(
                        (category) => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _getHobby(category.path, ref),
                            child: Text('${category.name} Hobbies'),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
