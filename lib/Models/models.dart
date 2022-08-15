class NewsModel {
  late String newsHead;
  late String newsDesp;
  late String newsImg;
  late String newsUrl;
  late String newsContent;

  NewsModel(
      {this.newsHead = "HEADLINE",
      this.newsDesp = "DESCRIPTION",
      this.newsUrl = "LINK URL",
      this.newsImg = "IMAGE",
      this.newsContent = "CONTENT"});

  factory NewsModel.fromMap(Map news) {
    return NewsModel(
        newsHead: news["title"] ?? " ",
        newsDesp: news["description"] ?? " ",
        newsImg:
            news["urlToImage"] ?? "https://wallpaperaccess.com/full/38119.jpg",
        newsUrl: news["url"],
        newsContent: news["content"] ?? " ");
  }
}
