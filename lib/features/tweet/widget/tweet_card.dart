import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:mns_final/core/core.dart';
import 'package:mns_final/features/auth/controller/auth_controller.dart';
import 'package:mns_final/features/tweet/controller/tweet_controller.dart';
import 'package:mns_final/features/tweet/widget/carousel_image.dart';
import 'package:mns_final/features/tweet/widget/hashtags_text.dart';
import 'package:mns_final/features/tweet/widget/tweet_icon_button.dart';
import 'package:mns_final/models/tweet_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../Constants/constants.dart';
import '../../../common/common.dart';
import '../../../theme/theme.dart';

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard({super.key,required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(UserDetailsProvider(tweet.uid)).when(data: (user) {
      return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
                radius: 30,
                
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                //retweeted 
              
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 
                      5),
                      child: Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19
                        ),
                      ),
                    ),
                    Text(
                      '@${user.name} .  ${timeago.format(tweet.tweetedAt,locale: 'en_short')}',
                      style: const TextStyle(
                        color: Pallete.greyColor,
                        fontSize: 17
                      ),
                    ),
              
                  ],
                ),
                //replied to 
                HashtagText(text: tweet.text),
                if(tweet.tweetType == TweetType.image)
                  CarouselImage(imageLinks: tweet.imageLinks),
                if(tweet.link.isNotEmpty)...[
                  const SizedBox(height: 10,),
                  AnyLinkPreview(link: 'http://${tweet.link}',displayDirection: UIDirection.uiDirectionHorizontal,),
                ],
                Container(
                  margin: EdgeInsets.only(top: 10,right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                      TweetIconButton(
                        pathName: AssetsConstants.viewsIcon,
                        text: tweet.commentIds.length + tweet.reshareCount + tweet.likes.length > 0
                            ? (tweet.commentIds.length + tweet.reshareCount + tweet.likes.length).toString()
                            : '0',
                        onTap: () {
                          //ref.read(tweetControllerProvider.notifier).viewTweet(tweet);
                        },
                        
                      ),
                      TweetIconButton(
                        pathName: AssetsConstants.commentIcon,
                        text: tweet.commentIds.length.toString(),
                        onTap: () {
                          //ref.read(tweetControllerProvider.notifier).likeTweet(tweet);
                        },
                      ),
                      TweetIconButton(
                        pathName: AssetsConstants.retweetIcon,
                        text: tweet.reshareCount.toString(),
                        onTap: () {
                          //ref.read(tweetControllerProvider.notifier).shareTweet(tweet);
                        },
                      ),
                      LikeButton(
                        size: 25,
                        isLiked: tweet.likes.contains(ref.watch(CurrentUserDetailsProvider).value!.uid),
                        likeBuilder: (isLiked) {
                          return isLiked
                          ? 
                            SvgPicture.asset(
                            AssetsConstants.likeFilledIcon, 
                            color: Pallete.redColor,                          
                            height: 25,
                            )
                          : SvgPicture.asset(
                            AssetsConstants.likeOutlinedIcon,
                            color: Pallete.greyColor,
                            height: 25,
                          );
                        },
                        likeCount: tweet.likes.length,
                        countBuilder: (likeCount, isLiked, text) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Text(text,style: TextStyle(
                              color: isLiked ? Pallete.redColor : Pallete.greyColor,
                              fontSize: 16,
                            ),
                            ),
                          );
                        },
                        
                      ),
                      
                      IconButton(onPressed: (){}, icon: const Icon(Icons.share_outlined,color: Pallete.greyColor,size: 25,)),
                      
                    ],
                  )

                ),
                const SizedBox(height: 10,),
              ],),

            )
          ],
        ),
        const Divider(
          color: Pallete.greyColor,
          thickness: 0.5,
        ),
      ],
    );
    },
     error: (error, stackTrace) => ErrorText(error: error.toString()), loading: () => const Loader()
    );
     
  }
}