// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'category.dart';
import 'Models/models.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  List<NewsModel> newsModelList = <NewsModel>[];
  List<NewsModel> newsModelListCarousel = <NewsModel>[];
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
  getNewsByQuery() async {
    var url = Uri.parse(
        // "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=abd5334967ab4404be574d0b39e25d44");

        "https://newsapi.org/v2/top-headlines?country=in&apiKey=abd5334967ab4404be574d0b39e25d44");
    var response = await get(url);
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        try {
          NewsModel newsQueryModel = new NewsModel();
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
  }

  getNewsofIndia() async {
    var url =
        "https://newsapi.org/v2/top-headlines?sources=techcrunch&pageSize=10&apiKey=abd5334967ab4404be574d0b39e25d44";
    // "https://newsapi.org/v2/top-headlines?country=in&apiKey=abd5334967ab4404be574d0b39e25d44";
    var response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        try {
          NewsModel newsQueryModel = new NewsModel();
          newsQueryModel = NewsModel.fromMap(element);
          newsModelListCarousel.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });
        } catch (e) {
          print(e);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getNewsByQuery();
    getNewsofIndia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("NewsApp"),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                //Search Wala Container

                padding: EdgeInsets.all(2),
                margin: EdgeInsets.only(left: 12),

                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if ((searchController.text).replaceAll(" ", "") == "") {
                          print("Blank search");
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryNews(
                                      Query: searchController.text)));
                        }
                      },
                      child: Container(
                        child: Icon(
                          Icons.search,
                          color: Colors.blueAccent,
                        ),
                        margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CategoryNews(Query: value)));
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Search"),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                  height: 40,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: navBarItem.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CategoryNews(
                                        Query: navBarItem[index])));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(navBarItem[index],
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        );
                      })),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: isLoading
                    ? Container(
                        height: 150,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : CarouselSlider(
                        options: CarouselOptions(
                          enableInfiniteScroll: false,
                          enlargeCenterPage: true,
                          autoPlay: true,
                        ),
                        items: newsModelList.map((instance) {
                          return Builder(
                            builder: (BuildContext context) {
                              try {
                                return Container(
                                  child: Card(
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            instance.newsImg,
                                            fit: BoxFit.fill,
                                            height: double.infinity,
                                          ),
                                        ),
                                        Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    gradient:
                                                        LinearGradient(colors: [
                                                      Colors.black12
                                                          .withOpacity(0),
                                                      Colors.black,
                                                    ])),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          instance.newsHead
                                                                      .length >
                                                                  45
                                                              ? "${instance.newsHead.substring(0, 50)}...."
                                                              : instance
                                                                  .newsHead,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                )))
                                      ],
                                    ),
                                  ),
                                );
                              } catch (e) {
                                print(e);
                                return Container();
                              }
                            },
                          );
                        }).toList(),
                      ),
              ),
              Container(
                margin: EdgeInsetsDirectional.only(start: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            "LATEST NEWS",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
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
                          return Container(
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
              // )
            ],
          ),
        ),
      ),
    );
  }

  // final List items = ["HELLO MAN", "NAMAS STAY", "DIRTY FELLOW"];
}
