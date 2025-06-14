import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mns_final/Constants/constants.dart';
import 'package:mns_final/common/common.dart';
import 'package:mns_final/features/tweet/controller/tweet_controller.dart';
import 'package:mns_final/features/tweet/widget/tweet_card.dart';
import 'package:mns_final/models/tweet_model.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(getTweetsProvider)
        .when(data: (tweets) {
          return ref.watch(getLatestTweetProvider).when(
            data: (data) {
              if (data.events.contains('databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create')) {
                // You can handle the event here if needed
                tweets.insert(0, Tweet.fromMap(data.payload));
              }
              return ListView.builder(
                itemCount: tweets.length,
                itemBuilder: (context, index) {
                  final tweet = tweets[index];
                  return TweetCard(
                    tweet: tweet,
                  );
                },
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () {
              return ListView.builder(
                itemCount: tweets.length,
                itemBuilder: (context, index) {
                  final tweet = tweets[index];
                  return TweetCard(
                    tweet: tweet,
                  );
                },
              );
            },
          );
        }, error: (error, stackTrace) => ErrorText(error: error.toString()), loading: () => const Loader());
  }
}
