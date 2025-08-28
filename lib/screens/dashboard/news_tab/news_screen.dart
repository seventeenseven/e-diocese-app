// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:ediocese_app/components/custom_dialog.dart';
import 'package:ediocese_app/components/loader.dart';
import 'package:ediocese_app/constants/colors.dart';
import 'package:ediocese_app/main.dart';
import 'package:ediocese_app/models/schemas/news/news.dart';
import 'package:ediocese_app/screens/dashboard/news_tab/new_details_screen.dart';
import 'package:ediocese_app/services/all_api.dart';
import 'package:flutter/material.dart';
import 'package:ediocese_app/components/tab_app_bar.dart';
import 'package:velocity_x/velocity_x.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  NewsScreenState createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    getNews();
    super.initState();
  }

  AllApi allApi = container<AllApi>();

  List<News> news = [];
  bool gettingNews = false;

  void getNews() async {
    setState(() {
      gettingNews = true;
    });

    try {
      final res = await allApi.getNews();
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
                    RichText(
                      key: const Key('rich-text'),
                      text: TextSpan(
                          // style: const TextStyle(fontSize: 15.0),
                          children: <TextSpan>[
                            TextSpan(
                                text: onlyNew.description.length >= 60
                                    ? '${onlyNew.description.substring(0, 60).toLowerCase()}...'
                                    : onlyNew.description.toLowerCase(),
                                style: const TextStyle(color: Colors.black)),
                            if (onlyNew.description.length >= 60)
                              const TextSpan(
                                  text: '  Voir plus',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 164, 162, 162),
                                  ))
                          ]),
                    ),
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
              (e, index) => _buildNewsItem(e),
            )
            .toList()
        : [const Text("Pas d'actualités")];
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
          titleProp: 'Actualités',
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
