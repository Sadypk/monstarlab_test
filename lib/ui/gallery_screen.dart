import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:monstarlab_test/controllers/gallery_controller.dart';
import 'package:monstarlab_test/theme/app_colors.dart';
import 'package:monstarlab_test/theme/app_text_styles.dart';
import 'package:monstarlab_test/ui/image_full_screen.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({Key? key}) : super(key: key);

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  int crossAxisCount = 4;
  GalleryController galleryController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent){
        galleryController.nextPage();
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Obx(()=>
        SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.darkGrey,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Trending',
                    style: AppTextStyles.sectionHeader,
                  ).paddingSymmetric(vertical: 15),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        MasonryGridView.count(
                          controller: scrollController,
                          crossAxisCount: 2,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: ()=> Get.to(ImageFullScreen(image: galleryController.list[index])),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CachedNetworkImage(
                                  imageUrl: galleryController.list[index].urls!.regular!,
                                  placeholder: (context, url) => Container(
                                    height: 150,
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: galleryController.list.length,
                        ),
                        if(galleryController.isLoading.value) Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: 80,
                            width: Get.width,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}
