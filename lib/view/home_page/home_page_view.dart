import 'package:flutter/material.dart';
import 'package:image_saving_system/view/home_page/home_page_view_model.dart';
import 'package:image_saving_system/view/image_view/image_viewer_view.dart';
import 'package:image_saving_system/widgets/alert.dart';
import 'package:stacked/stacked.dart';

class HomeView extends ViewModelBuilderWidget<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      body: SafeArea(
        child: viewModel.isBusy
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Image Viewer',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () async {
                              bool result = await viewModel.onPressedDelete();

                              if (result) {
                                showAlertDialog(context, 'Done !', 'Successfully deleted');
                              } else {
                                showAlertDialog(context, 'Warning !', 'Please select atlease one');
                              }
                            },
                            icon: const Icon(
                              Icons.delete_rounded,
                              size: 32,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                          itemCount: viewModel.imageList.length,
                          itemBuilder: (context, index) {
                            final image = viewModel.imageList[index];
                            return GridTile(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: image.isSelected ? Colors.red : Colors.white,
                                    width: 4,
                                  )),
                                  child: GestureDetector(
                                    child: Image.memory(
                                      viewModel.imageView(index),
                                      fit: BoxFit.cover,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ImageViewerView(viewModel.imageView(index), image.name!),
                                          ));
                                    },
                                    onLongPress: () {
                                      viewModel.onLongPressed(index);
                                    },
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => viewModel.onAddPressed(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        )),
        backgroundColor: Colors.black,
      ),
    );
  }

  showAlertDialog(BuildContext context, String title, String? body) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(body ?? ''),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.init();
}
