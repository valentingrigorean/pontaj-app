import 'package:flutter/material.dart';

class SmartAutocomplete extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<String> suggestions;
  final String label;
  final String? hint;
  final void Function(String) onSelected;
  final TextInputAction? textInputAction;

  const SmartAutocomplete({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.suggestions,
    required this.label,
    this.hint,
    required this.onSelected,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return suggestions;
        }
        return suggestions.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: onSelected,
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController fieldController,
        FocusNode fieldFocusNode,
        VoidCallback onFieldSubmitted,
      ) {
        // Sync external controller with internal one
        if (controller.text != fieldController.text) {
          fieldController.text = controller.text;
        }

        fieldController.addListener(() {
          if (controller.text != fieldController.text) {
            controller.text = fieldController.text;
          }
        });

        return TextField(
          controller: fieldController,
          focusNode: fieldFocusNode,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
            prefixIcon: Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
            suffixIcon: suggestions.isNotEmpty
                ? Icon(Icons.arrow_drop_down, color: Colors.grey[600])
                : null,
          ),
          textInputAction: textInputAction,
        );
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<String> onSelected,
        Iterable<String> options,
      ) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200, maxWidth: 400),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: options.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return ListTile(
                    title: Text(option),
                    onTap: () {
                      onSelected(option);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
