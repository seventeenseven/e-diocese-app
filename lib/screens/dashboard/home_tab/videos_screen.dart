// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/video/video.dart';
import 'package:ediocese_app/screens/dashboard/home_tab/videos_details_screen.dart';
import 'package:ediocese_app/services/all_api.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  VideosScreenState createState() => VideosScreenState();
}

class VideosScreenState extends State<VideosScreen> {
  @override
  void initState() {
    getVideos();
    super.initState();
  }

  List<Video> videos = [];
  bool gettingVideos = false;

  AllApi allApi = container<AllApi>();

  void getVideos() async {
    setState(() {
      gettingVideos = true;
    });

    try {
      final res = await allApi.getVideos();
      if (res.success == true) {
        setState(() {
          gettingVideos = false;
          videos = res.videos;
        });
      }
    } catch (error) {
      setState(() {
        gettingVideos = false;
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

  Widget _buildVideosItem(Video video) {
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
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.3,
        margin: const EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          children: <Widget>[
            const Icon(
              FontAwesomeIcons.video,
              size: 35.0,
              color: colorBlueLittleDark,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              video.titre,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
            ),
            const SizedBox(
              height: 5.0,
            ),

            // Image.network(
            //   video.url,
            //   fit: BoxFit.contain,
            //   height: 80.0,
            //   // width: 100.0,
            // ),

            RichText(
              key: const Key('rich-text'),
              text: TextSpan(
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: video.description.length >= 15
                          ? '${video.description.substring(0, 15).toLowerCase()}...'
                          : video.description.toLowerCase(),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    if (video.description.length >= 15)
                      const TextSpan(
                          text: '  Voir plus',
                          style: TextStyle(
                            color: Color.fromARGB(255, 164, 162, 162),
                          ))
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildVideosList() {
    return videos.isNotEmpty
        ? videos
            .mapIndexed(
              (e, index) => _buildVideosItem(e),
            )
            .toList()
        : [const Text("Pas de vidéos")];
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
        titleProp: 'Vidéos',
        titleColor: Colors.white,
        backButtonColor: Colors.white,
        context: context,
        backgroundColor: colorBlueLittleDark,
        showBackButton: true,
      ),
      body: SafeArea(
          child: Container(
        color: colorGreyShadeLight,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Expanded(
                child: RefreshIndicator(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 15.0,
                            ),
                            Wrap(
                              runSpacing: 10.0,
                              spacing: 15.0,
                              children: gettingVideos
                                  ? [_buildLoader(context)]
                                  : _buildVideosList(),
                            )
                          ],
                        ),
                      ),
                    ),
                    onRefresh: () async {}))
          ],
        ),
      )),
    );
  }
}
