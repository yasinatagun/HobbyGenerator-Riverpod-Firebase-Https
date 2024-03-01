import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_generator/riverpod/bookmark_provider.dart';
import 'package:hobby_generator/util/utils.dart'; // Import your bookmarks provider

class BookmarkScreen extends ConsumerWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the list of bookmarked hobbies from the provider
    final bookmarks = ref.watch(favoritesProvider);

    // Check if there are any bookmarks
    if (bookmarks.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("No bookmarks added."),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: const Text("Bookmarks"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: bookmarks.length,
          itemBuilder: (context, index) {
            final hobby = bookmarks[index];
            return Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(capitalize(hobby.name), style: const TextStyle(fontWeight:FontWeight.bold,),),
                          Text(capitalize(hobby.category), style: const TextStyle(fontWeight:FontWeight.w500,)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Assuming you have a method in your FavoritesNotifier to remove a hobby
                          ref
                              .read(favoritesProvider.notifier)
                              .removeFavorite(hobby);
                        },
                      ),
                    ],
                  ),
                )
        
                // Optionally, add a trailing widget to remove the item from bookmarks
                );
          },
        ),
      ),
    );
  }
}
