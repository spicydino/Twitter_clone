import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mns_final/Constants/assets_constants.dart';
import 'package:mns_final/common/common.dart';
import 'package:mns_final/core/utils.dart';
import 'package:mns_final/features/auth/controller/auth_controller.dart';
import 'package:mns_final/theme/pallete.dart';

import '../controller/tweet_controller.dart';

class CreateTweetScreen extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const CreateTweetScreen());
  const CreateTweetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetScreen> {
  final tweetTextController = TextEditingController();
  List<XFile>? images = [];

  @override
  void dispose() {
    tweetTextController.dispose();
    super.dispose();
  }

  void _shareTweet() {
    ref.read(tweetControllerProvider.notifier).shareTweet(
          text: tweetTextController.text,
          images: images ?? [],
          context: context,
        );
    Navigator.pop(context);
  }

  void onPicImages() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(CurrentUserDetailsProvider);
    final isLoading = ref.watch(tweetControllerProvider);

    // Loading or error state
    if (currentUserAsync.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (currentUserAsync.hasError || currentUserAsync.value == null) {
      return const Scaffold(
        body: Center(
          child: Text("User not found, please login again."),
        ),
      );
    }

    final currentUser = currentUserAsync.value!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        actions: [
          RoundedSmallButton(
            onTap: _shareTweet,
            label: "Tweet",
            backgroundColor: Pallete.blueColor,
            textColor: Pallete.whiteColor,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(currentUser.profilePic),
                    radius: 30,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: tweetTextController,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        hintText: "What's happening?",
                        hintStyle: TextStyle(color: Pallete.greyColor),
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                  ),
                ],
              ),
              if (images != null && images!.isNotEmpty)
                CarouselSlider(
                  items: images!.map((file) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Image.file(File(file.path)),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 400,
                    enableInfiniteScroll: false,
                  ),
                ),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Pallete.whiteColor,
          border: Border(
            top: BorderSide(
              color: Pallete.greyColor.withOpacity(0.2),
              width: 0.3,
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: GestureDetector(
                onTap: onPicImages,
                child: SvgPicture.asset(
                  AssetsConstants.galleryIcon,
                  color: Pallete.blueColor,
                  height: 35,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: SvgPicture.asset(
                AssetsConstants.gifIcon,
                color: Pallete.blueColor,
                height: 35,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(left: 15, right: 15),
              child: SvgPicture.asset(
                AssetsConstants.emojiIcon,
                color: Pallete.blueColor,
                height: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
