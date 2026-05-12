import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  static final selectedStyle = TextButton.styleFrom(
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
  );
  final void Function(String) changeFilter;
  final String selectedFilter;

  const FilterBar({
    super.key,
    required this.changeFilter,
    required this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => changeFilter("wszystkie"),
          child: Text("Wszystkie"),
          style: selectedFilter == "wszystkie" ? selectedStyle : null,
        ),
        TextButton(
          onPressed: () => changeFilter("wykonane"),
          child: Text("Wykonane"),
          style: selectedFilter == "wykonane" ? selectedStyle : null,
        ),
        TextButton(
          onPressed: () => changeFilter("do zrobienia"),
          child: Text("Do Zrobienia"),
          style: selectedFilter == "do zrobienia" ? selectedStyle : null,
        ),
      ],
    );
  }
}