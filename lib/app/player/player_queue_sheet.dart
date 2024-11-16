import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:tubesync/app/playlist/media_entry_builder.dart';
import 'package:tubesync/provider/player_provider.dart';

class PlayerQueueSheet extends StatelessWidget {
  const PlayerQueueSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 12),
            Text(
              "Playlist (${context.read<PlayerProvider>().playlist.medias.length})",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Spacer(),
            SizedBox(width: 12),
            ...actions(context),
            SizedBox(width: 12),
          ],
        ),
        SizedBox(height: 12),
        Expanded(
          child: ListenableBuilder(
            listenable: context.read<PlayerProvider>().playlist,
            builder: (_, __) {
              final playlist = context.read<PlayerProvider>().playlist;
              return ValueListenableBuilder(
                valueListenable: context.read<PlayerProvider>().nowPlaying,
                builder: (context, nowPlaying, _) => ListView.builder(
                  itemCount: playlist.medias.length,
                  itemBuilder: (context, index) => MediaEntryBuilder(
                    playlist.medias[index],
                    selected: playlist.medias[index] == nowPlaying,
                    trailing: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(Icons.drag_handle_rounded),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> actions(BuildContext context) {
    return [
      IconButton(
        onPressed: context.read<PlayerProvider>().playlist.shuffle,
        icon: Icon(Icons.shuffle_rounded),
      ),
      StreamBuilder(
        stream: context.read<PlayerProvider>().player.loopModeStream,
        initialData: context.read<PlayerProvider>().player.loopMode,
        builder: (context, snapshot) => IconButton(
          onPressed: context.read<PlayerProvider>().toggleLoopMode,
          icon: Icon(
            switch (snapshot.requireData) {
              LoopMode.off => Icons.repeat_rounded,
              LoopMode.one => Icons.repeat_one_rounded,
              LoopMode.all => Icons.repeat_on_rounded,
            },
          ),
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.more_vert_rounded),
      ),
    ];
  }
}
