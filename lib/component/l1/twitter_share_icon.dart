import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../service/url_service.dart';
import 'button.dart';

class TwitterShareIcon extends StatelessWidget {
  final String text;
  final String url;
  final List<String> hashtags;
  final String via;
  final String related;

  const TwitterShareIcon(
      {super.key,
      required this.text,
      this.url = "",
      this.hashtags = const [],
      this.via = "",
      this.related = ""});

  void _tweet() async {
    final tags = [
      ...hashtags,
      'きてね',
    ];
    final urlBase = dotenv.get('URL_BASE');
    final Map<String, dynamic> tweetQuery = {
      "text": text,
      "url": urlBase + url,
      "hashtags": tags.join(","),
      "via": via,
      "related": related,
    };

    final Uri tweetScheme =
        Uri(scheme: "twitter", host: "post", queryParameters: tweetQuery);

    final Uri tweetIntentUrl =
        Uri.https("twitter.com", "/intent/tweet", tweetQuery);

    final appUrl = tweetScheme.toString();
    if (await UrlService().canLaunchUrl(appUrl)) {
      UrlService().launchUri(appUrl);
    } else {
      UrlService().launchUri(tweetIntentUrl.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
      ),
      onPressed: () => _tweet(),
      icon: const FaIcon(
        FontAwesomeIcons.twitter,
        color: Colors.blue,
        size: 18,
      ),
      label: const Text('Share', style: TextStyle(color: Colors.blue)),
    );
  }
}
