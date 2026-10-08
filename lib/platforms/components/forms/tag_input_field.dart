import 'package:flutter/material.dart';

class TagInputField extends StatefulWidget {
  const TagInputField({
    super.key,
    required this.allTags,
    required this.selectedTags,
    required this.onChanged,
  });

  final List<String> allTags;
  final List<String> selectedTags;
  final ValueChanged<List<String>> onChanged;

  @override
  State<TagInputField> createState() => _TagInputFieldState();
}

class _TagInputFieldState extends State<TagInputField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  late List<String> _selectedTags;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _focusNode = FocusNode();

    _selectedTags = [...widget.selectedTags];
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<String> _options(String query) {
    final q = query.trim().toLowerCase();

    return widget.allTags
        .where(
          (tag) =>
              !_selectedTags.contains(tag) &&
              (q.isEmpty || tag.toLowerCase().contains(q)),
        )
        .toList();
  }

  void _selectTag(String tag) {
    if (_selectedTags.contains(tag)) return;

    setState(() {
      _selectedTags.add(tag);
      _controller.clear();
    });

    widget.onChanged([..._selectedTags]);

    _focusNode.requestFocus();
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });

    widget.onChanged([..._selectedTags]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final tag in _selectedTags)
              InputChip(label: Text(tag), onDeleted: () => _removeTag(tag)),
          ],
        ),

        const SizedBox(height: 8),

        RawAutocomplete<String>(
          textEditingController: _controller,
          focusNode: _focusNode,

          optionsBuilder: (value) {
            return _options(value.text);
          },

          onSelected: _selectTag,

          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: const InputDecoration(
                hintText: 'Search tags...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            );
          },

          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                    maxHeight: 250,
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final tag = options.elementAt(index);

                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.label_outline),
                        title: Text(tag),
                        onTap: () => onSelected(tag),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
