// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/constants/img_urls.dart';
import 'package:ediocese_app/locator.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/screens/dashboard/pray_tab/pray_screen.dart';
import 'package:ediocese_app/screens/dashboard/profile_tab/about_screen.dart';
import 'package:ediocese_app/screens/dashboard/profile_tab/activites_participate_screen.dart';
import 'package:ediocese_app/screens/dashboard/profile_tab/activity_favoris_screen.dart';
import 'package:ediocese_app/screens/dashboard/profile_tab/cgu_screen.dart';
import 'package:ediocese_app/screens/dashboard/profile_tab/church_favoris_screen.dart';
import 'package:ediocese_app/screens/dashboard/profile_tab/delete_account_screen.dart';
import 'package:ediocese_app/screens/dashboard/profile_tab/news_favoris_screen.dart';
import 'package:ediocese_app/screens/dashboard/profile_tab/profile_details_screen.dart';
import 'package:ediocese_app/screens/dashboard/profile_tab/videos_favoris_screen.dart';
import 'package:ediocese_app/screens/onboarding/login_screen.dart';
import 'package:ediocese_app/screens/onboarding/registration_screen.dart';
import 'package:ediocese_app/services/all_api.dart';
import 'package:ediocese_app/services/authentication_api.dart';
import 'package:ediocese_app/services/favoris_api.dart';
import 'package:ediocese_app/services/navigation_service.dart';
import 'package:ediocese_app/services/safe_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart' as share_link;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    _checkLoginStatus();
    super.initState();
  }
  _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    setState(() {
      isLoggedIn = token != null && token.isNotEmpty;
    });

    if (isLoggedIn) {
      _getUserInfos();
      getInfos();
    }
  }
  final NavigationService _navigationService = locator<NavigationService>();

  AuthenticationApi authenticationApi = container<AuthenticationApi>();
  AllApi allApi = container<AllApi>();
  FavorisApi favorisApi = container<FavorisApi>();

  String firstName = "";
  String lastName = "";
  String userId = "";

  int activitiesParticipate = 0;
  int churchesFavorites = 0;
  int activitiesFavorites = 0;
  int newsFavorites = 0;
  int videosFavorites = 0;

  getInfos() async {
    Future.delayed(const Duration(seconds: 1), () {
      getActivitesParticipate();
      getChurch();
      getActivites();
      getNews();
      getVideos();
    });
  }

  _getUserInfos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName') ?? "";
      lastName = prefs.getString('lastName') ?? "";
      userId = prefs.getString('userId') ?? "";
    });
  }

  _logout() async {
    final prefs = await SharedPreferences.getInstance();
    final SafeSecureStorage storage = container<SafeSecureStorage>();

    // final bool? googleLogged = prefs.getBool('googleLogged');
    // final bool? facebookLogged = prefs.getBool('facebookLogged');

    // if (googleLogged == true) {
    //   await GoogleSignInApi.logout();
    // }

    // if (facebookLogged == true) {
    //   await FacebookAuth.instance.logOut();
    // }

    await authenticationApi.logout();

    await storage.delete(key: 'token');
    await prefs.clear();

    await _navigationService.navigateTo(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void getActivitesParticipate() async {
    try {
      final res = await allApi.actitivitiesParticipate();
      if (res.success == true) {
        setState(() {
          activitiesParticipate = res.activities.length;
        });
      }
    } catch (error) {
      _showDialog(error.toString());
    }
  }

  void getChurch() async {
    try {
      final res = await favorisApi.getChurchFavoris();
      if (res.success == true) {
        setState(() {
          churchesFavorites = res.favoris.length;
        });
      }
    } catch (error) {
      _showDialog(error.toString());
    }
  }

  void getActivites({bool order = false}) async {
    try {
      final res = await favorisApi.getActiviteFavoris();
      if (res.success == true) {
        setState(() {
          activitiesFavorites = res.activiteFavoris.length;
        });
      }
    } catch (error) {
      _showDialog(error.toString());
    }
  }

  void getNews() async {
    try {
      final res = await favorisApi.getNewsFavoris();
      if (res.success == true) {
        setState(() {
          newsFavorites = res.newsFavoris.length;
        });
      }
    } catch (error) {
      _showDialog(error.toString());
    }
  }

  void getVideos() async {
    try {
      final res = await favorisApi.getVideosFavoris();
      if (res.success == true) {
        setState(() {
          videosFavorites = res.videosFavoris.length;
        });
      }
    } catch (error) {
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

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    if (isLoggedIn) {
                      await _getUserInfos();
                      getInfos();
                    }
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Header avec image de fond
                        Container(
                          padding: const EdgeInsets.all(35.0),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(dioceseBg),
                                  fit: BoxFit.cover
                              )
                          ),
                          child: Column(
                            children: [
                              Image.asset(dioceseLogo, height: 70),
                              const SizedBox(height: 10),
                              if (isLoggedIn) Text(
                                "$firstName $lastName",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Section principale
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SECTION COMPTE
                              const Text(
                                "Paramètres du compte",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: colorBlueLittleDark
                                ),
                              ),
                              const SizedBox(height: 15),

                              if (!isLoggedIn) ...[
                                _buildLoginOption(),
                                const SizedBox(height: 15),
                                _buildRegisterOption(),
                                const Divider(),
                              ],

                              if (isLoggedIn) ...[
                                _buildProfileOption(),
                                if (Platform.isIOS || Platform.isAndroid) ...[
                                  const SizedBox(height: 10),
                                  const Divider(),
                                  const SizedBox(height: 13),
                                  _buildPrayerOption(),
                                ],
                              ],

                              // SECTION FAVORIS (seulement si connecté)
                              if (isLoggedIn) ...[
                                const SizedBox(height: 20),
                                const Text(
                                  "Mes favoris",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: colorBlueLittleDark
                                  ),
                                ),
                                const SizedBox(height: 15),
                                _buildParticipationOption(),
                                const SizedBox(height: 10),
                                const Divider(),
                                _buildChurchOption(),
                                const SizedBox(height: 10),
                                const Divider(),
                                _buildActivitiesOption(),
                                const SizedBox(height: 10),
                                const Divider(),
                                _buildNewsOption(),
                                const SizedBox(height: 10),
                                const Divider(),
                                _buildVideosOption(),
                              ],

                              // SECTION PARTAGE
                              const SizedBox(height: 20),
                              _buildShareOption(),
                              const SizedBox(height: 10),
                              const Divider(),

                              // SECTION À PROPOS
                              _buildAboutOption(),
                              const SizedBox(height: 10),
                              const Divider(),
                              _buildTermsOption(),

                              // SECTION DÉCONNEXION (seulement si connecté)
                              if (isLoggedIn) ...[
                                const SizedBox(height: 20),
                                _buildLogoutOption(),
                                const SizedBox(height: 10),
                                const Divider(),
                                _buildDeleteAccountOption(),
                              ]
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widgets modulaires pour chaque option
  Widget _buildLoginOption() => InkWell(
    onTap: () => _navigationService.navigateTo(
        MaterialPageRoute(builder: (context) => const LoginScreen())
    ),
    child: const Text(
      "Se connecter",
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
    ),
  );

  Widget _buildRegisterOption() => InkWell(
    onTap: () => _navigationService.navigateTo(
        MaterialPageRoute(builder: (context) => const RegistrationScreen())
    ),
    child: const Text(
      "S'inscrire",
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
    ),
  );

  Widget _buildProfileOption() => InkWell(
    onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileDetailsScreen())
    ),
    child: const Text(
      "Mon profil",
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
    ),
  );

  Widget _buildPrayerOption() => InkWell(
    onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PrayScreen())
    ),
    child: const Text(
      "Mes intentions de prières",
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
    ),
  );

  Widget _buildParticipationOption() => InkWell(
    onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ActivitesParticipateScreen())
    ),
    child: Text(
      "Je participe ($activitiesParticipate)",
      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
    ),
  );

  Widget _buildChurchOption() => InkWell(
    onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChurchFavorisScreen())
    ),
    child: Text(
      "Églises ($churchesFavorites)",
      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
    ),
  );

  Widget _buildActivitiesOption() => InkWell(
    onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ActivityFavorisScreen())
    ),
    child: Text(
      "Activités ($activitiesFavorites)",
      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
    ),
  );

  Widget _buildNewsOption() => InkWell(
    onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NewsFavorisScreen())
    ),
    child: Text(
      "Actualités ($newsFavorites)",
      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
    ),
  );

  Widget _buildVideosOption() => InkWell(
    onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VideosFavorisScreen())
    ),
    child: Text(
      "Vidéos ($videosFavorites)",
      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
    ),
  );

  Widget _buildShareOption() => InkWell(
    onTap: () => share_link.Share.share(
        "Téléchargez l'application Ediocèse : https://onelink.to/yhv4x5",
        subject: "Télécharger Ediocèse"
    ),
    child: const Text(
      "Partager l'application",
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
    ),
  );

  Widget _buildAboutOption() => InkWell(
    onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AboutScreen())
    ),
    child: const Text(
      "A propos de E-Diocese",
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
    ),
  );

  Widget _buildTermsOption() => InkWell(
    onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CguScreen())
    ),
    child: const Text(
      "Conditions d'utilisations",
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
    ),
  );

  Widget _buildLogoutOption() => InkWell(
    onTap: _logout,
    child: const Text(
      "Déconnexion",
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
    ),
  );

  Widget _buildDeleteAccountOption() => InkWell(
    onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DeleteAccountScreen())
    ),
    child: const Text(
      "Supprimer mon compte",
      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
    ),
  );
}

