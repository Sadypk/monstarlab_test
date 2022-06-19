import 'package:get/get.dart';
import 'package:monstarlab_test/data/unsplash_image_model.dart';
import 'package:monstarlab_test/repository/image_repository.dart';

class GalleryController extends GetxController{
  ImageRepository imageRepository = Get.find();
  RxBool isLoading = true.obs;
  RxList<UnsplashImage> list = <UnsplashImage>[].obs;
  RxInt currentPage = 0.obs;

  @override
  void onInit() {
    fetchImages();
    super.onInit();
  }

  void fetchImages() async{
    isLoading.value = true;
    list.addAll(await imageRepository.get(currentPage.value));
    isLoading.value = false;
  }

  void nextPage(){
    if(!isLoading.value){
      currentPage.value++;
      fetchImages();
    }
  }
}