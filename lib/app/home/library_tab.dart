import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_sync/app/playlist/import_playlist_dialog.dart';
import 'package:tube_sync/app/playlist/playlist_entry_builder.dart';
import 'package:tube_sync/app/playlist/playlist_tab.dart';
import 'package:tube_sync/provider/library_provider.dart';
import 'package:tube_sync/provider/playlist_provider.dart';

class LibraryTab extends StatelessWidget {
  const LibraryTab({super.key, required this.notifier});

  final ValueNotifier<Widget?> notifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      body: Consumer<LibraryProvider>(
        builder: (context, library, _) => RefreshIndicator(
          onRefresh: library.refresh,
          child: ListView.builder(
            itemCount: library.entries.length,
            itemBuilder: (context, index) {
              final playlist = library.entries[index];
              return PlaylistEntryBuilder(playlist, onTap: () {
                notifier.value = ChangeNotifierProvider<PlaylistProvider>(
                  create: (_) => PlaylistProvider(playlist),
                  child: PlaylistTab(notifier: notifier),
                );
              });
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          useRootNavigator: true,
          builder: (_) => ChangeNotifierProvider.value(
            value: context.watch<LibraryProvider>(),
            child: const ImportPlaylistDialog(),
          ),
        ),
        label: const Text("Import"),
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }
}
