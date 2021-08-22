import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:openscan/core/data/database_helper.dart';
import 'package:openscan/core/models.dart';
import 'package:openscan/logic/cubit/directory_cubit.dart';

import '../../screens/view_document.dart';
import '../delete_dialog.dart';

class ImageCard extends StatefulWidget {
  final DirectoryOS directoryOS;
  final ImageOS imageOS;

  // final Function fileEditCallback;
  final Function selectCallback;
  // final Function imageViewerCallback;

  const ImageCard({
    this.directoryOS,
    this.imageOS,
    // this.fileEditCallback,
    this.selectCallback,
    // this.imageViewerCallback,
  });

  @override
  _ImageCardState createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  DatabaseHelper database = DatabaseHelper();

  selectionOnPressed() {
    setState(() {
      selectedImageIndex[widget.imageOS.idx - 1] = true;
    });
    widget.selectCallback();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        MaterialButton(
          elevation: 20,
          color: Theme.of(context).primaryColor,
          onPressed: () {
            (enableSelect) ? selectionOnPressed() : null;
          },
          child: FocusedMenuHolder(
            menuWidth: size.width * 0.45,
            onPressed: () {
              (enableSelect) ? selectionOnPressed() : null;
            },
            menuItems: [
              FocusedMenuItem(
                title: Text(
                  'Crop',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  BlocProvider.of<DirectoryCubit>(context).cropImage(
                    context,
                    imageOS: widget.imageOS,
                  );

                  // Directory cacheDir = await getTemporaryDirectory();
                  // File image = await imageCropper(
                  //   context,
                  //   File(widget.imageOS.imgPath),
                  // );
                  // if (image != null) {
                  //   File temp = File(widget.imageOS.imgPath.substring(
                  //           0, widget.imageOS.imgPath.lastIndexOf("/")) +
                  //       '/' +
                  //       DateTime.now().toString() +
                  //       '.jpg');
                  //   image.copySync(temp.path);
                  //   File(widget.imageOS.imgPath).deleteSync();
                  //   widget.imageOS.imgPath = temp.path;
                  // }
                  // database.updateImagePath(
                  //   tableName: widget.directoryOS.dirName,
                  //   image: widget.imageOS,
                  // );
                  // if (widget.imageOS.idx == 1) {
                  //   database.updateFirstImagePath(
                  //     imagePath: widget.imageOS.imgPath,
                  //     dirPath: widget.directoryOS.dirPath,
                  //   );
                  // }
                  // widget.fileEditCallback();
                },
                trailingIcon: Icon(
                  Icons.crop,
                  color: Colors.black,
                ),
              ),
              FocusedMenuItem(
                title: Text('Delete'),
                trailingIcon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return DeleteDialog(
                        deleteOnPressed: () {
                          File(widget.imageOS.imgPath).deleteSync();
                          database.deleteImage(
                            imgPath: widget.imageOS.imgPath,
                            tableName: widget.directoryOS.dirName,
                          );
                          try {
                            Directory(widget.directoryOS.dirPath)
                                .deleteSync(recursive: false);
                            database.deleteDirectory(
                                dirPath: widget.directoryOS.dirPath);
                            Navigator.pop(context);
                          } catch (e) {
                            // widget.fileEditCallback();
                          }
                          widget.selectCallback();
                          Navigator.pop(context);
                        },
                        cancelOnPressed: () => Navigator.pop(context),
                      );
                    },
                  );
                },
                backgroundColor: Colors.redAccent,
              ),
            ],
            child: Container(
              child: Image.file(File(widget.imageOS.imgPath)),
              height: size.height * 0.25,
              width: size.width * 0.395,
            ),
          ),
        ),
        // (selectedImageIndex[widget.imageOS.idx - 1] && enableSelect)
        //     ? Positioned.fill(
        //         child: GestureDetector(
        //           onTap: () {
        //             setState(() {
        //               selectedImageIndex[widget.imageOS.idx - 1] = false;
        //             });
        //             widget.selectCallback();
        //           },
        //           child: Container(
        //             foregroundDecoration: BoxDecoration(
        //               border: Border.all(
        //                 width: 3,
        //                 color: secondaryColor,
        //               ),
        //             ),
        //             color: secondaryColor.withOpacity(0.3),
        //           ),
        //         ),
        //       )
        //     : Container(
        //         width: 0.001,
        //         height: 0.001,
        //       ),
        (enableReorder)
            ? Positioned.fill(
                child: Container(
                  color: Colors.transparent,
                ),
              )
            : Container(
                width: 0.001,
                height: 0.001,
              ),
      ],
    );
  }
}
