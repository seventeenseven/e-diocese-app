// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/constants/img_urls.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/news/news.dart';
import 'package:ediocese_app/services/all_api.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:share_plus/share_plus.dart' as share_link;

class NewsDetailsScreen extends StatefulWidget {
  const NewsDetailsScreen({super.key, required this.newsId});
  final String newsId;

  @override
  NewsDetailsScreenState createState() => NewsDetailsScreenState();
}

class NewsDetailsScreenState extends State<NewsDetailsScreen> {
  @override
  void initState() {
    getNews();
    getSimilarNews();
    super.initState();
  }

  AllApi allApi = container<AllApi>();

  List<News> newsSimilar = [];
  bool gettingSimilarNews = false;

  News? news;
  bool gettingNews = false;

  void getSimilarNews() async {
    setState(() {
      gettingSimilarNews = true;
    });

    try {
      final res = await allApi.getNewsSimilar(newsId: widget.newsId);
      if (res.success == true) {
        setState(() {
          gettingSimilarNews = false;
          newsSimilar = res.news;
        });
      }
    } catch (error) {
      setState(() {
        gettingSimilarNews = false;
      });
      _showDialog(error.toString());
    }
  }

  void getNews() async {
    setState(() {
      gettingNews = true;
    });

    try {
      final res = await allApi.getOnlyNews(widget.newsId);
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

  void addToFavoris(String newsId) async {
    try {
      final res = await allApi.addToNewsFavoris(newsId);
      if (res.success == true) {
        getNews();
        if (res.errorMessage == null) {
          _showMessage("L'article a bien été ajoutée à vos favoris");
        } else {
          _showMessage("L'article a bien été retirée de vos favoris");
        }
      }
    } catch (error) {
      if (error.toString().toLowerCase().contains('nosuchmethoderror')) {
        return;
      }
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

  _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      behavior: SnackBarBehavior.floating,
    ));
  }

  Widget _buildNewItem(News onlyNew) {
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
                height: 100.0,
                width: MediaQuery.of(context).size.width * 0.280,
                fit: BoxFit.fill,
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
    return newsSimilar.isNotEmpty
        ? newsSimilar
            .mapIndexed(
              (e, index) => _buildNewItem(e),
            )
            .toList()
        : [const Text("Pas d'autres articles")];
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
                addToFavoris(news != null ? news!.id : widget.newsId);
              },
              child: news != null && news!.favoris == true
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
                share_link.Share.share(news != null ? news!.description : '',
                    subject: news != null ? news!.titre : '');
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
                            gettingNews
                                ? _buildLoader(context)
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        news != null ? news!.titre : '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        news != null ? news!.sousTitre : '',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(14.0),
                                        child: Image.network(
                                          news!.image,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 250.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      const Text(
                                        "Description :",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.0,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(news != null
                                          ? news!.description
                                          : ''),
                                    ],
                                  ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Autres articles".toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17.0),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Column(
                              children: gettingSimilarNews
                                  ? [_buildLoader(context)]
                                  : _buildNewsList(),
                            )
                          ],
                        ),
                      ),
                    ),
                    onRefresh: () async {
                      getNews();
                      getSimilarNews();
                    }))
          ],
        ),
      )),
    );
  }
}
