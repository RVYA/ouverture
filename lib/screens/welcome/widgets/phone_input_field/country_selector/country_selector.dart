part of '../phone_input_field.dart';


class CountrySelector extends StatefulWidget {
  const CountrySelector({
    @required this.initialCountry,
    this.textPadding = const EdgeInsets.all(22.5),
    @required this.onSelection,
  });

  final String initialCountry;
  final EdgeInsets textPadding;
  final void Function(String) onSelection;

  @override
  _CountrySelectorState createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  String country;


  @override
  void initState() {
    super.initState();

    country = _countryCodeToRegionalIndicator(widget.initialCountry);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(country,),
      onPressed: () {
        BottomDialog.showBottomDialog(
          context,
          title: kWelcomeCountrySelectorTitle,
          child: CountrySearchGrid(
            initialCountry: widget.initialCountry,
            onSelection: (String choosenCountryCode) {
              widget.onSelection(choosenCountryCode);
              setState(() => country = _countryCodeToRegionalIndicator(choosenCountryCode));
            },
          ),
        );
      },
      style: TextButton.styleFrom(
        padding: widget.textPadding,
        primary: kBackground,
        shape: CircleBorder(),
        //side: BorderSide(color: kBackground.withAlpha(175), width: 1.5,),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: _kSignInScreenTextStyle,
        visualDensity: VisualDensity.standard,
      ),
    );
  }
}