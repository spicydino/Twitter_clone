import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mns_final/apis/tweet_api.dart';
import 'package:mns_final/core/core.dart';

import '../../../apis/storage_api.dart';
import '../../../core/utils.dart';
import '../../../models/tweet_model.dart';
import '../../auth/controller/auth_controller.dart';

final tweetControllerProvider =
    StateNotifierProvider<TweetController, bool>((ref) {
  return TweetController(tweetApi: ref.watch(tweetAPIProvider), ref: ref, storageAPI: ref.watch(storageAPIProvider));
});

final getTweetsProvider = FutureProvider((ref) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

final getLatestTweetProvider = StreamProvider((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  return tweetAPI.getLatestTweet();
});


class TweetController extends StateNotifier<bool> {
  final TweetApi _tweetApi;
  final StorageAPI _storageAPI;
  final Ref _ref;
  TweetController({required TweetApi tweetApi, required Ref ref,required StorageAPI storageAPI})
      : _ref = ref,
        _tweetApi = tweetApi,
        _storageAPI = storageAPI,
        super(false);

        Future <List<Tweet>> getTweets() async {
          final tweetList = await _tweetApi.getTweets();
          return tweetList.map((tweet) {
            return Tweet.fromMap(tweet.data);
          }).toList();
        }
  void shareTweet({
    required String text,
    required List<XFile> images,
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, "text cannot be empty");
      return;
    }

    if (images.isEmpty) {
      _shareImageTweet(text: text, images: images, context: context);
    } else {
      _shareTextTweet(text: text, context: context);
    }
  }

  void _shareImageTweet({
    required String text,
    required List<XFile> images,
    required BuildContext context,
  }) async{
    state = true; // Set loading state
    final hashtags = _getHashtagsFromText(text);
    final link = _getLinkFromText(text);
    final user = _ref.read(CurrentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadImage(images.cast<File>());
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: imageLinks,
      uid: user.uid, // Replace with actual user ID
      tweetType: TweetType.image, // Assuming TweetType is an enum
      tweetedAt: DateTime.now(),
      likes: [],
      commentIds: [],
      id: '', // Replace with actual tweet ID
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: '',
    );
    final res = await _tweetApi.shareTweet(tweet);
    state = false; // Reset loading state
    res.fold(
      (l) {
        state = false; // Reset loading state
        showSnackBar(context, l.message);
      },
      (r) {
        state = false; // Reset loading state
        showSnackBar(context, "Tweet shared successfully");
      },
    );
  }

  void _shareTextTweet({
    required String text,
    required BuildContext context,
  }) async {
    state = true; // Set loading state
    final hashtags = _getHashtagsFromText(text);
    final link = _getLinkFromText(text);
    final user = _ref.read(CurrentUserDetailsProvider).value!;
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: [],
      uid: user.uid, // Replace with actual user ID
      tweetType: TweetType.text, // Assuming TweetType is an enum
      tweetedAt: DateTime.now(),
      likes: [],
      commentIds: [],
      id: '', // Replace with actual tweet ID
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: '',
    );
    final res = await _tweetApi.shareTweet(tweet);
    state = false; // Reset loading state
    res.fold(
      (l) {
        state = false; // Reset loading state
        showSnackBar(context, l.message);
      },
      (r) {
        state = false; // Reset loading state
        showSnackBar(context, "Tweet shared successfully");
      },
    );
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('http://') || word.startsWith('https://')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }
}
