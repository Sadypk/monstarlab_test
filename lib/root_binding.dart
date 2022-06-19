import 'package:get/get.dart';
import 'package:monstarlab_test/controllers/gallery_controller.dart';
import 'package:monstarlab_test/repository/image_repository.dart';

class RootBinding implements Bindings{
  @override
  void dependencies() {
    // Controllers
    Get.lazyPut<GalleryController>(() => GalleryController());

    // Repositories
    Get.lazyPut<ImageRepository>(() => ImageRepository());
  }

}