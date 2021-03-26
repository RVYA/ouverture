part of "phone_input_field.dart";


class PhoneInputFieldButton extends StatelessWidget {
  PhoneInputFieldButton({
    this.iconPadding = const EdgeInsets.all(22.5),
    required this.onPressed,
  });

  final EdgeInsetsGeometry iconPadding;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        shape: const ArcBorder(
          startAngle: 0, sweepAngle: (math.pi / 180) * 330,
          side: const BorderSide(color: kBackground, width: 1.5,),
        ),
      ),
      child: OutlinedButton(
        child: const Icon(Icons.phone,),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: iconPadding,
          primary: kBackground,
          shape: CircleBorder(),
          //side: BorderSide(color: kBackground.withAlpha(175), width: 1.5,),
          tapTargetSize: MaterialTapTargetSize.padded,
          visualDensity: VisualDensity.comfortable,
        ),
      ),
    );
  }
}