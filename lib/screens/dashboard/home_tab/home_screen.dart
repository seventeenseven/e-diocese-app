// ignore_for_file: import_of_legacy_library_into_null_safe, non_constant_identifier_names, slash_for_doc_comments

import 'dart:io';

import 'package:ediocese_app/components/custom_button.dart';
import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/constants/img_urls.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/activite/activite.dart';
import 'package:ediocese_app/models/schemas/church/church.dart';
import 'package:ediocese_app/models/schemas/news/news.dart';
import 'package:ediocese_app/models/schemas/reading_day/reading_day.dart';
import 'package:ediocese_app/models/schemas/video/video.dart';
import 'package:ediocese_app/screens/dashboard/activity_tab/activity_details_screen.dart';
import 'package:ediocese_app/screens/dashboard/bottom_tab_navigator.dart';
import 'package:ediocese_app/screens/dashboard/home_tab/church_details_screen.dart';
import 'package:ediocese_app/screens/dashboard/home_tab/church_screen.dart';
import 'package:ediocese_app/screens/dashboard/home_tab/prayer_intentions_screen.dart';
import 'package:ediocese_app/screens/dashboard/home_tab/reading_screen.dart';
import 'package:ediocese_app/screens/dashboard/home_tab/videos_details_screen.dart';
import 'package:ediocese_app/screens/dashboard/home_tab/videos_screen.dart';
import 'package:ediocese_app/screens/dashboard/news_tab/new_details_screen.dart';
import 'package:ediocese_app/services/all_api.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getReading();
    getCurrentLocation();
    getActivites();
    getNews();
    getVideos();
    super.initState();
  }

  AllApi allApi = container<AllApi>();

  List<Church> churchs = [];
  bool gettingChurch = false;

  List<Activite> activites = [];
  bool gettingActivites = false;

  List<News> news = [];
  bool gettingNews = false;

  List<ReadingDay> readings = [];
  bool gettingReadings = false;

  List<Video> videos = [];
  bool gettingVideos = false;

  double? latitude;
  double? longitude;

  String userId = "";

  void getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
    getChurch(position.latitude, position.longitude);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showDialog(
            "Permissions refusées ! Veuillez acceptez les permissions avnt de continuer");
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showDialog(
          "Les autorisations de localisation sont définitivement refusées, nous ne pouvons pas demander d'autorisations");
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void getChurch(double userLatitude, double userLongitude) async {
    setState(() {
      gettingChurch = true;
    });

    try {
      final res = await allApi.getChurchNear(
          limit: 10, userLongitude: userLongitude, userLatitude: userLatitude);
      if (res.success == true) {
        setState(() {
          gettingChurch = false;
          churchs = res.churchs;
        });
        print('length ${res.churchs.length}');
      }
    } catch (error) {
      setState(() {
        gettingChurch = false;
      });
      _showDialog(error.toString());
    }
  }

  void getActivites() async {
    setState(() {
      gettingActivites = true;
    });

    try {
      final res = await allApi.getActivites(limit: 10, order: true);
      if (res.success == true) {
        setState(() {
          gettingActivites = false;
          activites = res.activites;
        });
      }
    } catch (error) {
      setState(() {
        gettingActivites = false;
      });
      _showDialog(error.toString());
    }
  }

  void getNews() async {
    setState(() {
      gettingNews = true;
    });

    try {
      final res = await allApi.getNews(limit: 10, order: true);
      if (res.success == true) {
        setState(() {
          gettingNews = false;
          news = res.news;
        });
      }
    } catch (error) {
      setState(() {
        gettingNews = false;
      });
      _showDialog(error.toString());
    }
  }

  void getVideos() async {
    setState(() {
      gettingVideos = true;
    });

    try {
      final res = await allApi.getVideos(limit: 10);
      print("videoslength ${res.videos.length}");
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

  void getReading() async {
    setState(() {
      gettingReadings = true;
    });

    final prefs = await SharedPreferences.getInstance();

    try {
      final getUserId = prefs.getString('userId');
      if ((Platform.isIOS &&
              getUserId != null &&
              getUserId != '637689ec1058d65964fb4436') ||
          Platform.isAndroid) {
        _togglePrayMenu(true);
      }
      final res = await allApi.getReadingsDay();

      if (res.success == true) {
        setState(() {
          gettingReadings = false;
          userId = getUserId ?? "";
          readings = res.readingsDay;
        });
      }
    } catch (error) {
      setState(() {
        gettingReadings = false;
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

  void _togglePrayMenu(bool show) async {
    final BottomTabNavigatorState? bottomTabNavigator =
        context.findAncestorStateOfType<BottomTabNavigatorState>();
    if (bottomTabNavigator != null && show) {
      bottomTabNavigator.showPrayMenu();
    } else if (bottomTabNavigator != null && !show) {
      bottomTabNavigator.hidePrayMenu();
    }
  }

  List<Widget> _buildChurchList() {
    return churchs.isNotEmpty
        ? churchs
            .mapIndexed(
              (e, index) => _buildChurchItem(e),
            )
            .toList()
        : [const Text("Pas d'église à proximité")];
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              video.titre.length >= 22
                  ? '${video.titre.substring(0, 22).toLowerCase()}...'
                  : video.titre.toLowerCase(),
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              video.description.length >= 20
                  ? '${video.description.substring(0, 20).toLowerCase()}...'
                  : video.description.toLowerCase(),
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 12.0),
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

  Widget _buildActiviteItem(Activite activite) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivityDetailsScreen(
                activiteId: activite.id,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.network(
              activite.image,
              fit: BoxFit.cover,
              height: 80.0,
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              activite.titre.length >= 12
                  ? '${activite.titre.substring(0, 12).toLowerCase()}...'
                  : activite.titre.toLowerCase(),
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              activite.description.length >= 18
                  ? '${activite.description.substring(0, 18).toLowerCase()}...'
                  : activite.description.toLowerCase(),
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActivitesList() {
    return activites.isNotEmpty
        ? activites
            .mapIndexed(
              (e, index) => _buildActiviteItem(e),
            )
            .toList()
        : [const Text("Pas d'activités")];
  }

  Widget _buildNewsItem(News onlyNews) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailsScreen(
                newsId: onlyNews.id,
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              onlyNews.image,
              fit: BoxFit.cover,
              height: 80.0,
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              onlyNews.titre.length >= 12
                  ? '${onlyNews.titre.substring(0, 12).toLowerCase()}...'
                  : onlyNews.titre,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              onlyNews.description.length >= 18
                  ? '${onlyNews.description.substring(0, 18).toLowerCase()}...'
                  : onlyNews.description.toLowerCase(),
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNewsList() {
    return news.isNotEmpty
        ? news
            .mapIndexed(
              (e, index) => _buildNewsItem(e),
            )
            .toList()
        : [const Text("Pas d'actualités")];
  }

  void _setActiveBottomTabItem(int index) {
    final BottomTabNavigatorState? bottomTabNavigator =
    context.findAncestorStateOfType<BottomTabNavigatorState>();
    return bottomTabNavigator!.onItemTapped(index);
  }

  PreferredSize CustomHomeTabAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF8D6E63), // Taupe moyen
                Color(0xFF5D4037), // Brun chaud
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: Row(
              children: <Widget>[
                Image.asset(
                  dioceseLogo,
                  fit: BoxFit.contain,
                  height: 40.0,
                ),
                const SizedBox(width: 15.0),
                const Text(
                  "Bienvenue sur e-Diocese",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
      appBar: CustomHomeTabAppBar(context),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF9F5F0), // Beige clair
              Color(0xFFF0EAE4), // Beige légèrement plus foncé
            ],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              getReading();
              getChurch(latitude ?? 0.0, longitude ?? 0.0);
              getActivites();
              getNews();
              getVideos();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Section Lecture du jour
                  _buildSectionTitle("Lecture du jour"),
                  const SizedBox(height: 12.0),
                  gettingReadings
                      ? _buildLoader(context)
                      : _buildReadingItem(readings),
                  const SizedBox(height: 30.0),

                  // Section Églises à proximité
                  _buildSectionHeader(
                    title: "Églises à proximité",
                    onSeeMore: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChurchScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 12.0),
                  SizedBox(
                    height: 185.0,
                    child: _buildHorizontalList<Church>(
                      items: gettingChurch ? [] : churchs,
                      builder: _buildChurchItem,
                      isLoading: gettingChurch,
                    ),
                  ),
                  const SizedBox(height: 30.0),

                  // Section Activités prochaines
                  _buildSectionHeader(
                    title: "Activités prochaines",
                    onSeeMore: () => _setActiveBottomTabItem(1),
                  ),
                  const SizedBox(height: 12.0),
                  SizedBox(
                    height: 185.0,
                    child: _buildHorizontalList<Activite>(
                      items: gettingActivites ? [] : activites,
                      builder: _buildActiviteItem,
                      isLoading: gettingActivites,
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Bouton Intention de prière (conditionnel)
                  if ((Platform.isIOS && userId != '637689ec1058d65964fb4436') || Platform.isAndroid)
                    CustomButton(
                      contextProp: context,
                      paddingVertical: 16.0,
                      onPressedProp: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PrayerIntentionsScreen()),
                        );
                      },
                      color: const Color(0xFF8D6E63), // Couleur taupe
                      textColor: Colors.white,
                      icon: const Icon(
                        FontAwesomeIcons.handsPraying,
                        size: 18.0,
                        color: Colors.white,
                      ),
                      textProp: "Envoyer une intention de prière",
                    ),
                  const SizedBox(height: 30.0),

                  // Section Actualités
                  _buildSectionHeader(
                    title: "Actualités",
                    onSeeMore: () => _setActiveBottomTabItem(2),
                  ),
                  const SizedBox(height: 12.0),
                  SizedBox(
                    height: 185.0,
                    child: _buildHorizontalList<News>(
                      items: gettingNews ? [] : news,
                      builder: _buildNewsItem,
                      isLoading: gettingNews,
                    ),
                  ),
                  const SizedBox(height: 30.0),

                  // Section Vidéos
                  _buildSectionHeader(
                    title: "Vidéos",
                    onSeeMore: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VideosScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 12.0),
                  SizedBox(
                    height: 145.0,
                    child: _buildHorizontalList<Video>(
                      items: gettingVideos ? [] : videos,
                      builder: _buildVideosItem,
                      isLoading: gettingVideos,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper pour construire un titre de section
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFF5D4037), // Brun chaud
        fontSize: 18.0,
        fontFamily: 'Poppins',
      ),
    );
  }

  // Helper pour l'en-tête de section avec "Voir plus"
  Widget _buildSectionHeader({required String title, required VoidCallback onSeeMore}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionTitle(title),
        InkWell(
          onTap: onSeeMore,
          child: const Text(
            "Voir plus",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF8D6E63), // Taupe moyen
              fontSize: 15.0,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  // Helper pour construire une liste horizontale
  Widget _buildHorizontalList<T>({
    required List<T> items,
    required Widget Function(T) builder,
    bool isLoading = false,
  }) {
    if (isLoading) {
      return _buildLoader(context);
    }
    if (items.isEmpty) {
      return const Center(
        child: Text(
          "Aucun élément à afficher",
          style: TextStyle(color: Color(0xFF7D6E63)),
        ),
      );
    }
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(width: 12.0),
      itemBuilder: (context, index) => builder(items[index]),
    );
  }

  // Mise à jour des éléments avec le nouveau design
  Widget _buildChurchItem(Church church) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChurchDetailsScreen(churchId: church.id)),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: Image.network(
                church.image,
                fit: BoxFit.cover,
                height: 120.0,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    church.nom,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5D4037), // Brun chaud
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    church.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF7D6E63), // Taupe
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mise à jour de l'élément de lecture du jour
  Widget _buildReadingItem(List<ReadingDay> readingsDayItems) {
    if (readingsDayItems.isEmpty) {
      return const Center(child: Text("Pas de lecture du jour"));
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            readingsDayItems[0].versets,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D4037), // Brun chaud
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            readingsDayItems[0].contenu,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF7D6E63), // Taupe
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 16.0),
          CustomButton(
            contextProp: context,
            onPressedProp: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReadingScreen()),
              );
            },
            color: const Color(0xFF8D6E63), // Taupe moyen
            textColor: Colors.white,
            textProp: "Lire la suite",
            paddingVertical: 8.0,
            borderRadius: 8.0,
          ),
        ],
      ),
    );
  }

// Mettre à jour de la même manière :
// - _buildActiviteItem
// - _buildNewsItem
// - _buildVideosItem
// avec la même structure de carte
}
