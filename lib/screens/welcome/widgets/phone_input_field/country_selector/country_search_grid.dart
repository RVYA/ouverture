part of '../phone_input_field.dart';


class CountrySearchGrid extends StatefulWidget {
  const CountrySearchGrid({
    required this.initialCountry,
    required this.onSelection,
  });

  final String initialCountry;
  final void Function(String) onSelection;

  @override
  _CountrySearchGridState createState() => _CountrySearchGridState();
}


class _CountrySearchGridState extends State<CountrySearchGrid> {
  List<String> filteredCountryCodes = List<String>.empty();


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        /* Search Bar */
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              cursorColor: Colors.red,
              decoration: kGetInputDecorationFor(
                brightness: Brightness.light,
                labelText: kWelcomeCountrySelectorInputFieldLabel,
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r"[a-z]", unicode: true)),
                LengthLimitingTextInputFormatter(15),
              ],
              keyboardType: TextInputType.name,
              onChanged: (String input) {
                  setState(
                    () {
                      this.filteredCountryCodes = (input.isNotEmpty)?
                          List<String>.of(
                            CountryCodes.filterCountryCodesAgainst(query: input),
                            growable: false,
                          )
                            : List<String>.empty();
                    }
                  );
                },
              style: kGetBodyStyleFor(),
            ),
          ),
        ),

        /* Country Flags List */
        Flexible(
          flex: 9,
          child: RepaintBoundary(
            child: ListView.builder(
              itemCount: filteredCountryCodes.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext currentContext, int index) {
                final String countryCode = filteredCountryCodes[index];

                return TextButton(
                  autofocus: (widget.initialCountry == countryCode),
                  child: Text(
                    "${_countryCodeToRegionalIndicator(countryCode)} "
                    "${CountryCodes.getDialCodeOf(countryCode: countryCode)}",
                    style: kGetButtonStyleFor(),
                  ),
                  onPressed: () {
                    widget.onSelection(countryCode);
                    Navigator.pop(currentContext);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}