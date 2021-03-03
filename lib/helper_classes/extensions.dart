import 'dart:ui' as ui show RRect, Radius, Color;


extension DeflateOnlyFor on ui.RRect {
  ui.RRect deflateOnlyFor(
    double delta, {
    bool doDeflateLeft = false,
    bool doDeflateTop = false,
    bool doDeflateRight = false,
    bool doDeflateBottom = false,
  }) {
    final ui.Radius deltaRadius = ui.Radius.circular(delta);

    return ui.RRect.fromLTRBAndCorners(
        (doDeflateLeft)? (this.left + delta) : this.left,
        (doDeflateTop)? (this.top + delta) : this.top,
        (doDeflateRight)? (this.right - delta) : this.right,
        (doDeflateBottom)? (this.bottom - delta) : this.bottom,
        topLeft: this.tlRadius - deltaRadius,
        topRight: this.trRadius - deltaRadius,
        bottomLeft: this.blRadius - deltaRadius,
        bottomRight: this.brRadius - deltaRadius,
      );
  }
}


extension IsTransparent on ui.Color {
  bool get isTransparent => (this == const ui.Color(0x00000000));
}