import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monstarlab_test/data/unsplash_image_model.dart';
import 'package:monstarlab_test/theme/app_colors.dart';
import 'package:monstarlab_test/theme/app_text_styles.dart';

class ImageFullScreen extends StatefulWidget {
  final UnsplashImage image;

  const ImageFullScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<ImageFullScreen> createState() => _ImageFullScreenState();
}

class _ImageFullScreenState extends State<ImageFullScreen> {
  RxBool showOptions = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints){
              return SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: ()=> showOptions.value = !showOptions.value,
                      child: Center(
                        child: InteractiveViewer(
                          scaleEnabled: true,
                          child: CachedNetworkImage(
                            imageUrl: widget.image.urls!.regular!,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Obx(()=>
                          AnimatedOpacity(
                            opacity: showOptions.value? 1:0,
                            duration: const Duration(microseconds: 500),
                            child: PopupMenuButton(
                              child: Icon(
                                Icons.more_vert,
                                color: AppColors.white,
                              ),
                              itemBuilder: (context) => <PopupMenuItem>[
                                const PopupMenuItem(child: Text('Download'))
                              ],
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              );
            }
        ),
      ),
    );
  }
}
