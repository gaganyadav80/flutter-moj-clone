import 'package:flutter/material.dart';

import 'edit_video_screen.dart';

List<DraggableTextWidget> textModelList = [];

// class FilterModel {
//   final Color filterColor;
//   final BlendMode blendMode;
//   final List<double> filterMatrix;
//   final String filterName;

//   FilterModel(this.filterName, this.filterColor, this.blendMode, this.filterMatrix);
// }

class TextModel {
  String text;
  Offset textOffset;

  TextModel(this.text, this.textOffset);

  void changeText(String str) => text = str;
  void changeOffset(Offset offset) => textOffset = offset;
}

class DraggableTextWidget extends StatefulWidget {
  const DraggableTextWidget({Key key, @required this.textModel, this.editVideoScreenState}) : super(key: key);

  final TextModel textModel;
  final EditVideoScreenState editVideoScreenState;

  @override
  _DraggableTextWidgetState createState() => _DraggableTextWidgetState();
}

class _DraggableTextWidgetState extends State<DraggableTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      childWhenDragging: Container(),
      feedback: Material(
        borderRadius: BorderRadius.circular(8.0),
        child: _buildChild(context),
      ),
      child: _buildChild(context),
      data: widget.textModel.text,
      onDraggableCanceled: (velocity, offset) {
        widget.editVideoScreenState.setState(() {
          widget.textModel.changeOffset(offset);
        });
      },
    );
  }

  Container _buildChild(BuildContext context) => Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 100,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          widget.textModel.text,
          style: TextStyle(
            fontSize: widget.textModel.text.length > 50
                ? 16.0
                : widget.textModel.text.length > 25
                    ? 22.0
                    : 28.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
}
