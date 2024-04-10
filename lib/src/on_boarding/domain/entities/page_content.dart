import 'package:course_app/core/res/media_res.dart';

class PageContent {
  const PageContent({
    required this.title,
    required this.image,
    required this.content,
  });
  const PageContent.first()
      : this(
          image: MediaRes.vectorscasualReading,
          title: 'Brand new curriculum',
          content: 'this is cool app to apply clean arch',
        );
  const PageContent.second()
      : this(
          image: MediaRes.vectorscasualLife,
          title: 'Brand new curriculum 2 ',
          content: "here we go  again let's do something wrong ",
        );
  const PageContent.thired()
      : this(
          image: MediaRes.vectorsbluePotPlant,
          title: "let's go baby we will do great job ",
          content:
              'this will be great project to practice clean arch and bloc ',
        );
  final String title;
  final String image;
  final String content;
}
