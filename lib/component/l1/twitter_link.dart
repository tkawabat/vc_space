import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../entity/user_entity.dart';
import '../../service/twitter_service.dart';

class TwitterLink extends StatelessWidget {
  final UserEntity user;

  const TwitterLink({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openTwitter(user.twitterId),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const FaIcon(FontAwesomeIcons.twitter, color: Colors.blue, size: 18),
          Text(user.twitterId),
        ],
      ),
    );
  }
}
