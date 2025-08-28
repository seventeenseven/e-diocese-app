// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/news/news.dart';
import 'package:ediocese_app/models/schemas/news_favoris/news_favoris.dart';
import 'package:ediocese_app/screens/dashboard/news_tab/new_details_screen.dart';
import 'package:ediocese_app/services/favoris_api.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:velocity_x/velocity_x.dart';

class NewsFavorisScreen extends StatefulWidget {
  const NewsFavorisScreen({super.key});

  @override
  NewsFavorisScreenState createState() => NewsFavorisScreenState();
}

class NewsFavorisScreenState extends State<NewsFavorisScreen> {
  @override
  void initState() {
    getNews();
    super.initState();
  }

  FavorisApi favorisApi = container<FavorisApi>();

  List<NewsFavoris> news = [];
  bool gettingNews = false;

  void getNews() async {
    setState(() {
      gettingNews = true;
    });

    try {
      final res = await favorisApi.getNewsFavoris();
      if (res.success == true) {
        setState(() {
          gettingNews = false;
          news = res.newsFavoris;
        });
      }
    } catch (error) {
      setState(() {
        gettingNews = false;
      });
      _showDialog(error.toString());
    }
  }

  Widget _buildNewsItem(News onlyNew) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailsScreen(
                  newsId: onlyNew.id,
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
              Image.network(
                onlyNew.image,
                height: 94.0,
                width: MediaQuery.of(context).size.width * 0.280,
                fit: BoxFit.cover,
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
                      onlyNew.titre,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      onlyNew.sousTitre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(onlyNew.description),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  List<Widget> _buildNewsList() {
    return news.isNotEmpty
        ? news
            .mapIndexed(
              (e, index) => _buildNewsItem(e.news),
            )
            .toList()
        : [const Text("Pas d'actualités favoris")];
  }

  SizedBox _buildLoader(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 2.1 + 37 + 20,
      child: Center(
        child: Loader(),
      ),
    );
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
          titleProp: 'Actualités Favoris',
          titleColor: Colors.white,
          context: context,
          backgroundColor: colorBlueLittleDark),
      body: SafeArea(
          child: Container(
        color: colorGreyShadeLight,
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
                            const SizedBox(
                              height: 15.0,
                            ),
                            Column(
                              children: gettingNews
                                  ? [_buildLoader(context)]
                                  : _buildNewsList(),
                            )
                          ],
                        ),
                      ),
                    ),
                    onRefresh: () async {
                      getNews();
                    }))
          ],
        ),
      )),
    );
  }
}
