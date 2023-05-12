import 'dart:convert';

import 'package:advanced_flutter_firebase_authentication/core/helper/text_helper.dart';
import 'package:advanced_flutter_firebase_authentication/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'country_model.dart';
part 'helpers.dart';

class CountryPicker extends StatefulWidget {
  const CountryPicker({
    required this.countryCodes,
    super.key,
  });

  final List<Country> countryCodes;

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  TextEditingController searchController = TextEditingController();
  List<Country> filteredCountries = [];

  @override
  void initState() {
    super.initState();
    filteredCountries = widget.countryCodes;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search Box
          CustomTextField(
            controller: searchController,
            hintText: 'Search by country name...',
            borderRadius: 8,
            borderColor: Colors.transparent,
            keyboardType: TextInputType.text,
            fillColor: const Color(0xFF28293D),
            contentPadding: const EdgeInsets.symmetric(),
            prefix: Icon(
              Icons.search_rounded,
              color: Colors.white.withOpacity(0.5),
            ),
            onChanged: (value) {
              setState(() {
                filteredCountries = widget.countryCodes
                    .where((country) => country.name
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList();
              });
            },
          ),
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 138),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredCountries.length,
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (_, index) => GestureDetector(
                onTap: () {
                  print(
                      'Country Code: ${filteredCountries[index].countryCode}');
                },
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        countryCodeToEmoji(filteredCountries[index].phoneCode),
                        style: const TextStyle(fontSize: 30),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            filteredCountries[index].name,
                            style: TextHelper.countryPickerTextStyle,
                          ),
                        ),
                      ),
                      Text(
                        '+' '${filteredCountries[index].countryCode}',
                        style: TextHelper.countryPickerTextStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
