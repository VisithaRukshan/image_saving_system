import 'dart:convert';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:image_saving_system/data_models/image.dart';
import 'package:image_saving_system/services/api.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  final _api = Api();
  List<Image> imageList = [];
  final Image _imageDataModel = Image();
  Map<String, bool> selectedItems = {};

  init() async {
    setBusy(true);
    imageList = await _getAllImagesApiCall();
    setBusy(false);
  }

  void onAddPressed() async {
    setBusy(true);
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;

    Uint8List bytes = await file.readAsBytes();
    _imageDataModel.image = base64Encode(bytes);
    _imageDataModel.name = file.name;

      String response = await _postImagesAPiCall();

    await _getAllImagesApiCall();
    setBusy(false);
    notifyListeners();
  }

  Uint8List imageView(int index) {
    return base64Decode(imageList[index].image!);
  }

  void onLongPressed(int? index) {
    if (imageList[index!].isSelected == false) {
      imageList[index].isSelected = true;
    } else {
      imageList[index].isSelected = false;
    }

    if (selectedItems.containsKey(imageList[index].id.toString())) {
      selectedItems.update(imageList[index].id.toString(), (value) => imageList[index].isSelected);
    } else {
      selectedItems.putIfAbsent(imageList[index].id.toString(), () => imageList[index].isSelected);
    }


    notifyListeners();
  }

  Future<bool> onPressedDelete() async {
    var list = selectedItems.entries.where((element) => element.value == true).toList();
    if (list.isNotEmpty) {
      setBusy(true);
      list.forEach((element) async {
         await _api.deleteImages(int.parse(element.key));
      });
       await _getAllImagesApiCall();
      setBusy(false);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  //API call Controllers
  Future<List<Image>> _getAllImagesApiCall() async {
    return await _api.getImageList();
  }

  Future<String> _postImagesAPiCall() async {
    String jsonBody = jsonEncode(_imageDataModel.toMap());
    return await _api.postImages(jsonBody);
  }
}
