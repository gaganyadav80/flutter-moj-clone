import 'package:edverhub_video_editor/ui/pages/edit_video/edit_video_models.dart';
import 'package:edverhub_video_editor/ui/pages/edit_video/filters.dart';
import 'package:flutter/material.dart';

import 'edit_video_screen.dart';

class FiltersModalSheet extends StatefulWidget {
  const FiltersModalSheet({Key key, this.editVideoScreenState}) : super(key: key);

  final EditVideoScreenState editVideoScreenState;

  @override
  _FiltersModalSheetState createState() => _FiltersModalSheetState();
}

class _FiltersModalSheetState extends State<FiltersModalSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: FILTERS.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              widget.editVideoScreenState.setState(() {
                // if (index == 0)
                currentFilterColor = FILTERS[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (index == 0)
                      ? CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50.0,
                          child: CircleAvatar(
                            radius: 49.0,
                            backgroundColor: Colors.black,
                            child: Center(
                              child: Icon(
                                Icons.block_flipped,
                                color: Colors.white,
                                size: 32.0,
                              ),
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: ColorFiltered(
                              colorFilter:
                                  FILTERS[index].filterMatrix == null ? ColorFilter.mode(FILTERS[index].filterColor, FILTERS[index].blendMode) : ColorFilter.matrix(FILTERS[index].filterMatrix),
                              child: Image.network(
                                "https://image.shutterstock.com/image-photo/closeup-portrait-sensual-spring-lady-260nw-1071172997.jpg",
                                fit: BoxFit.fitWidth,
                                height: 100.0,
                                width: 100.0,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: 10.0),
                  Text(
                    FILTERS[index].filterName,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TextModalSheet extends StatefulWidget {
  TextModalSheet({Key key, this.textController, this.editVideoScreenState}) : super(key: key);

  final TextEditingController textController;
  final EditVideoScreenState editVideoScreenState;

  @override
  _TextModalSheetState createState() => _TextModalSheetState();
}

class _TextModalSheetState extends State<TextModalSheet> {
  final FocusNode textNode = FocusNode();

  @override
  void dispose() {
    textNode.unfocus();
    textNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.only(top: 40.0, left: 20.0),
              child: InkWell(
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 32.0,
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.only(top: 40.0, right: 20.0),
              child: InkWell(
                child: Icon(
                  Icons.done_rounded,
                  color: Colors.white,
                  size: 32.0,
                ),
                onTap: () {
                  final UniqueKey textKey = UniqueKey();
                  textModelList.add(DraggableTextModel(
                    textModel: TextModel(
                      widget.textController.text,
                      Offset(
                        widget.textController.text.length > 18
                            ? (MediaQuery.of(context).size.width / 4) - 45.0
                            : widget.textController.text.length > 10
                                ? (MediaQuery.of(context).size.width / 2) - 75.0
                                : (MediaQuery.of(context).size.width / 2) - 35.0,
                        (MediaQuery.of(context).size.height / 2) - 50.0,
                      ),
                    ),
                    key: textKey,
                    editVideoScreenState: widget.editVideoScreenState,
                  ));
                  // widget.editVideoScreenState.setState(() {

                  // });
                  Navigator.pop(context);
                  widget.textController.clear();
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width - 100,
              constraints: BoxConstraints(maxHeight: 200.0),
              child: TextField(
                controller: widget.textController,
                focusNode: textNode,
                autofocus: true,
                style: TextStyle(color: Colors.white, fontSize: 32.0),
                textAlign: TextAlign.center,
                cursorColor: Colors.white,
                enableInteractiveSelection: true,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter text here...",
                  hintStyle: TextStyle(color: Colors.grey[800], fontSize: 32.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
