import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class SearchAthletes extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String? initialValue;

  const SearchAthletes({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<SearchAthletes> createState() => _SearchAthletesState();
}

class _SearchAthletesState extends State<SearchAthletes> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');

    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void didUpdateWidget(covariant SearchAthletes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != null &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue!;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90.0),
      child: TextField(
        controller: _controller,
        cursorColor: const Color(0XFFb0c32e),
        style: principalFont.medium().copyWith(color: Colors.white),
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
