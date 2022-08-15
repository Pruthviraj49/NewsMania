// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'Models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

// ignore: must_be_immutable
class CategoryNews extends StatefulWidget {
  String Query;
  CategoryNews({Key? key, required this.Query}) : super(key: key);

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<NewsModel> newsModelList = <NewsModel>[];
  List<String> navBarItem = [
    "World",
    "Business",
    "Science",
    "Technology",
    "Health",
    "Sports",
    "Entertainment"
  ];

  bool isLoading = true;
  getNewsByQuery(String query) async {
    var url = " ";
    if (query == "Business") {
      url =
          "https://newsapi.org/v2/top-headlines?country=in&category=business&pageSize=50&apiKey=abd5334967ab4404be574d0b39e25d44";
    } else if (query == "World") {
      url =
          "https://newsapi.org/v2/top-headlines?country=us&pageSize=50&apiKey=abd5334967ab4404be574d0b39e25d44";
      // "https://newsapi.org/v2/everything?q=$query&from=2022-06-15&sortBy=publishedAt&apiKey=abd5334967ab4404be574d0b39e25d44";
    } else if (query == "Technology") {
      url =
          "https://newsapi.org/v2/top-headlines?sources=techcrunch&pageSize=50&apiKey=abd5334967ab4404be574d0b39e25d44";
    } else if (query == "Sports") {
      url =
          "https://newsapi.org/v2/top-headlines?country=in&category=sports&pageSize=50&apiKey=abd5334967ab4404be574d0b39e25d44";
    } else if (query == "Entertainment") {
      url =
          "https://newsapi.org/v2/top-headlines?country=in&category=entertainment&pageSize=50&apiKey=abd5334967ab4404be574d0b39e25d44";
    } else if (query == "Science") {
      url =
          "https://newsapi.org/v2/top-headlines?country=in&category=science&pageSize=50&apiKey=abd5334967ab4404be574d0b39e25d44";
    } else if (query == "Health") {
      url =
          "https://newsapi.org/v2/top-headlines?country=in&category=health&pageSize=50&apiKey=abd5334967ab4404be574d0b39e25d44";
    }

    var response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    // Future.delayed(const Duration(seconds: 1),(){
    setState(() {
      data["articles"].forEach((element) {
        try {
          NewsModel newsQueryModel = NewsModel();
          newsQueryModel = NewsModel.fromMap(element);
          newsModelList.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });
        } catch (e) {
          print(e);
        }
      });
    });
    // });
  }

  void initState() {
    super.initState();
    getNewsByQuery(widget.Query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NewsMania"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsetsDirectional.only(start: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.Query,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            isLoading
                ? Container(
                    height: 500,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: newsModelList.length,
                    itemBuilder: (context, index) {
                      try {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                elevation: 1.0,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        newsModelList[index].newsImg,
                                        fit: BoxFit.fill,
                                        height: 250,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.black12
                                                          .withOpacity(0),
                                                      Colors.black
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment
                                                        .bottomCenter)),
                                            padding: EdgeInsets.fromLTRB(
                                                15, 15, 10, 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  newsModelList[index]
                                                              .newsHead
                                                              .length >
                                                          45
                                                      ? "${newsModelList[index].newsHead.substring(0, 45)}...."
                                                      : newsModelList[index]
                                                          .newsHead,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  newsModelList[index]
                                                              .newsDesp
                                                              .length >
                                                          45
                                                      ? "${newsModelList[index].newsDesp.substring(0, 45)}...."
                                                      : newsModelList[index]
                                                          .newsDesp,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                )
                                              ],
                                            )))
                                  ],
                                )),
                          ),
                        );
                      } catch (e) {
                        print(e);
                        return Container();
                      }
                    }),
            // Container(
            //   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       ElevatedButton(
            //           onPressed: () {},
            //           child: Text(
            //             "SHOW MORE",
            //             style: TextStyle(color: Colors.white, fontSize: 12),
            //           )),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
