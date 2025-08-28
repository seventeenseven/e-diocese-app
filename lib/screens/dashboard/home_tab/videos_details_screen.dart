// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/constants/img_urls.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/video/video.dart';
import 'package:ediocese_app/services/all_api.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart' as share_link;

class VideosDetailsScreen extends StatefulWidget {
  const VideosDetailsScreen({super.key, required this.video});
  final Video video;

  @override
  VideosDetailsScreenState createState() => VideosDetailsScreenState();
}

class VideosDetailsScreenState extends State<VideosDetailsScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.video.url)
      ..initialize().then((_) {
        setState(() {});
      });
    _initializeVideoPlayerFuture = _controller.initialize();
    getVideo();
    getSimilarVideos();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  List<Video> videosSimilar = [];
  bool gettingSimilarVideos = false;

  Video? video;
  bool gettingVideo = false;

  AllApi allApi = container<AllApi>();

  void getSimilarVideos() async {
    setState(() {
      gettingSimilarVideos = true;
    });

    try {
      final res = await allApi.getVideosSimilar(videoId: widget.video.id);
      if (res.success == true) {
        setState(() {
          gettingSimilarVideos = false;
          videosSimilar = res.videos;
        });
      }
    } catch (error) {
      setState(() {
        gettingSimilarVideos = false;
      });
      _showDialog(error.toString());
    }
  }

  void getVideo() async {
    setState(() {
      gettingVideo = true;
    });

    try {
      final res = await allApi.getOnlyVideo(widget.video.id);
      if (res.success == true) {
        setState(() {
          gettingVideo = false;
          video = res.video;
        });
      }
    } catch (error) {
      setState(() {
        gettingVideo = false;
      });
      _showDialog(error.toString());
    }
  }

  void _showDialog(String errorMessage) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(contextProp: context, messageProp: errorMessage);
      },
    );
  }

  void addToFavoris(String video) async {
    try {
      final res = await allApi.addVideoToFavoris(video);
      if (res.success == true) {
        getVideo();
        if (res.errorMessage == null) {
          _showMessage("La vidéo a bien été ajoutée à vos favoris");
        } else {
          _showMessage("La vidéo a bien été retirée de vos favoris");
        }
      }
    } catch (error) {
      if (error.toString().toLowerCase().contains('nosuchmethoderror')) {
        return;
      }
      _showDialog(error.toString());
    }
  }

  _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      behavior: SnackBarBehavior.floating,
    ));
  }

  Widget _buildVideoItem(Video video) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideosDetailsScreen(
                  video: video,
                ),
              ));
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.only(bottom: 15.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                FontAwesomeIcons.video,
                size: 35.0,
                color: colorBlueLittleDark,
              ),
              const SizedBox(
                width: 10.0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      video.titre,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(video.description),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  List<Widget> _buildVideosList() {
    return videosSimilar.isNotEmpty
        ? videosSimilar
            .mapIndexed(
              (e, index) => _buildVideoItem(e),
            )
            .toList()
        : [const Text("Pas d'autres vidéos")];
  }

  SizedBox _buildLoader(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 2.1 + 37 + 20,
      child: Center(
        child: Loader(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
          titleProp: '',
          context: context,
          showBackButton: true,
          actionsProp: <Widget>[
            InkWell(
              onTap: () {
                addToFavoris(video != null ? video!.id : widget.video.id);
              },
              child: video != null && video!.favoris == true
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 13.0),
                      child: const Icon(
                        Icons.save_rounded,
                        color: Colors.grey,
                        size: 32.0,
                      ),
                    )
                  : Image.asset(save),
            ),
            InkWell(
              onTap: () {
                share_link.Share.share(video != null ? video!.url : '',
                    subject: video != null ? video!.titre : '');
              },
              child: const Icon(Icons.link, color: colorGrey),
            ),
            const SizedBox(
              width: 10.0,
            ),
          ]),
      body: SafeArea(
          child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: RefreshIndicator(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            gettingVideo
                                ? _buildLoader(context)
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        video != null ? video!.titre : '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: FutureBuilder(
                                          future: _initializeVideoPlayerFuture,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return AspectRatio(
                                                aspectRatio: _controller
                                                    .value.aspectRatio,
                                                child: VideoPlayer(_controller),
                                              );
                                            } else {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Center(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (_controller.value.isPlaying) {
                                                _controller.pause();
                                              } else {
                                                _controller.play();
                                              }
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: colorBlueLittleDark,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0)),
                                            padding: const EdgeInsets.all(10.0),
                                            child: Icon(
                                              _controller.value.isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      const Text(
                                        "Description: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.0,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(video != null
                                          ? video!.description
                                          : ''),
                                    ],
                                  ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Autres vidéos".toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17.0),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Column(
                              children: gettingSimilarVideos
                                  ? [_buildLoader(context)]
                                  : _buildVideosList(),
                            )
                          ],
                        ),
                      ),
                    ),
                    onRefresh: () async {
                      getVideo();
                      getSimilarVideos();
                    }))
          ],
        ),
      )),
    );
  }
}
