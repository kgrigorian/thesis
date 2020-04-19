import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_mobile_client/core/bloc/media_library_bloc.dart';
import 'package:music_mobile_client/widgets/track_list_item_widget.dart';

import '../main.dart';

class LibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      body: SingleChildScrollView(
        child: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
            child: BlocBuilder<MediaLibraryBloc, MediaLibraryState>(
              builder: (context, state) {
                if (state is LoadedMediaState) {
                  return Column(
                    children: <Widget>[
                      /*   SizedBox(height: 32.0),
              Text(
                'Collections',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 38.0),
              ),
              SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  AlbumCard('assets/images/blue.jpg', 'Extremely loud'),
                  SizedBox(
                    width: 16.0,
                  ),
                  AlbumCard('assets/images/pink.jpg', 'Calm & relaxing'),
                ],
              ),
              SizedBox(
                height: 32.0,
              ),
              Row(
                children: <Widget>[
                  AlbumCard('assets/images/orange.jpg', 'Extremely loud'),
                  SizedBox(
                    width: 16.0,
                  ),
                  AlbumCard('assets/images/yellow.jpg', 'Old Soul'),
                ], */
                      // ),
                      /*   SizedBox(
                height: 32.0,
              ), */
                      Text(
                        'All tracks',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 38.0),
                      ),
                      SizedBox(height: 16.0),
                      for (var mediaItem in state.mediaItems)
                        TrackListItem(mediaItem)
                    ],
                  );
                }

                return Container();
              },
            )),
      ),
    );
  }
}
