import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:monstarlab_test/data/unsplash_image_model.dart';
import 'package:monstarlab_test/theme/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ImageFullScreen extends StatefulWidget {
  final UnsplashImage image;

  const ImageFullScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<ImageFullScreen> createState() => _ImageFullScreenState();
}

class _ImageFullScreenState extends State<ImageFullScreen> {
  RxBool showOptions = true.obs;
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    int name = random.nextInt(10000);
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
                                PopupMenuItem(
                                  child: const Text('Download'),
                                  onTap: () async{
                                    if(await Permission.storage.status.isGranted){
                                      var response = await Dio().get(
                                          widget.image.urls!.regular!,
                                          options: Options(responseType: ResponseType.bytes));
                                      await ImageGallerySaver.saveImage(
                                          Uint8List.fromList(response.data),
                                          quality: 60,
                                          name: "$name");
                                    }else {
                                      await Permission.storage.request().then((value)async{
                                        var response = await Dio().get(
                                            widget.image.urls!.regular!,
                                            options: Options(responseType: ResponseType.bytes));
                                        await ImageGallerySaver.saveImage(
                                            Uint8List.fromList(response.data),
                                            quality: 60,
                                            name: "$name");
                                      });
                                    }
                                  },
                                ),
                                PopupMenuItem(
                                  child: const Text('Share'),
                                  onTap: () async{
                                    var response = await http.get(Uri.parse(widget.image.urls!.regular!));
                                    final bytes = response.bodyBytes;

                                    final temp = await getTemporaryDirectory();
                                    final path = '${temp.path}/image.jpg';
                                    File(path).writeAsBytesSync(bytes);

                                    await Share.share('Sharing');
                                  },
                                )
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
