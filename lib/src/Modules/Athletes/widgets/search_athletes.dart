import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class SearchAthletes extends StatelessWidget {
  const SearchAthletes({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90.0),
      child: TextField(
        cursorColor: const Color(0XFFb0c32e),
        style: principalFont.medium(),
        decoration: const InputDecoration(
          prefix: Text('   '),
          contentPadding: EdgeInsets.all(1),
          suffixIcon: Icon(
            Icons.search,
            color: Color(0XFFb0c32e),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Color(0XFFb0c32e),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Color(0XFFb0c32e),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Color(0XFFb0c32e),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
