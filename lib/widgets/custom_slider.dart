import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final double min, max, value;
  final Function onChanged;
  CustomSlider({this.min, this.max, this.value, this.onChanged});
  @override
  Widget build(BuildContext context) {
    void seekToRelativePosition(Offset globalPosition, bool isDragging) {
      print("globalposition $globalPosition");
      if (globalPosition != null) {
        final RenderBox box = context.findRenderObject();
        final Offset tapPos = box.globalToLocal(globalPosition);
        final double relative = tapPos.dx / box.size.width;
        print("relateive $relative");
        onChanged(relative, isDragging);
      } else
        onChanged(-1.0, isDragging);
    }

    var h = 8.0;
    var v = this.value / (this.max - this.min);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.hasBoundedWidth != true) return Container();
      return GestureDetector(
        
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          seekToRelativePosition(details.globalPosition, true);
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          seekToRelativePosition(null, false);
        },
        onTapDown: (TapDownDetails details) {
          seekToRelativePosition(details.globalPosition, false);
        },
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Theme.of(context).colorScheme.primary,
              ),
              width: constraints.biggest.width,
              height: h,
            ),
            Container(
              width: v * constraints.biggest.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Theme.of(context).colorScheme.secondaryVariant,
              ),
              height: h,
              child: Container(),
            ),
          ],
        ),
      );
    });
  }
}
