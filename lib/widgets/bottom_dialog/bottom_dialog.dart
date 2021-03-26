import 'package:flutter/material.dart';
import 'package:ouverture/values/colours.dart';
import 'package:ouverture/values/text_styles.dart';
import 'package:ouverture/widgets/bottom_dialog/non_uniform_rrectangle_border.dart';


const double
  _kSheetBorderWidth  = 2.5,
  _kSheetBorderRadius = 24; //dp. Material Design's default.

const BoxBorder
    _kSheetBorderShape = const NonUniformRRectangleBorder(
        width: _kSheetBorderWidth, color: kOnBackground,
        radii: BorderRadius.vertical(top: Radius.circular(_kSheetBorderRadius)),
        hasTop: true,
        hasLeft: true,
        hasRight: true,
        hasBottom: false,
      );

///
/// Use "showBottomDialog<T>" static function to build a BottomDialog,
/// and pass constructor parameters to the function. Type "T" is also the type
/// of the value the "Future" that Modal Bottom Sheet returns when it is closed.
/// 
class BottomDialog extends StatelessWidget {
  const BottomDialog._({
    required this.child,
    this.innerPadding = const EdgeInsets.all(8.0),
    required this.title,
  });

  final Widget child;
  final EdgeInsetsGeometry? innerPadding;
  final String title;


  static Future<T?> showBottomDialog<T>(
    BuildContext buildContext, {
    required Widget child,
    EdgeInsetsGeometry? innerPadding,
    required String title,
  }) {
    return showModalBottomSheet<T>(
      context: buildContext,
      builder: (BuildContext context)
        => Padding(
            padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                     ),
            child: BottomDialog._(
                    child: child,
                    innerPadding: innerPadding,
                    title: title
                   ),
          ),
      isScrollControlled: true,
      shape: _kSheetBorderShape,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(  // Makes all other constructors "const".
        border: _kSheetBorderShape,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_kSheetBorderRadius)
        ),
        //boxShadow: <BoxShadow>[BoxShadow()],
        color: kBackground,
      ),
      padding: innerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          /* Title */
          Flexible(
            child: Text(title, style: kGetMenuTitleStyleFor()),
            flex: 1,
          ),

          /* Child */
          Flexible(
            flex: 9,
            child: child
          ),
        ],
      )
    );
  }
}

