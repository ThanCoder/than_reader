import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/extensions/context_extensions.dart';

class TagManagerScreen extends StatefulWidget {
  final List<String> tags;
  final List<String> allTags;
  const TagManagerScreen({
    super.key,
    required this.tags,
    required this.allTags,
  });

  @override
  State<TagManagerScreen> createState() => _TagManagerScreenState();
}

class _TagManagerScreenState extends State<TagManagerScreen> {
  List<String> tags = [];
  List<String> allTags = [];

  @override
  void initState() {
    tags = widget.tags;
    allTags = widget.allTags;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        context.pop<List<String>>(tags);
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Tags Manager")),
        body: TScrollableColumn(
          children: [
            // _headerWdiget,
            Text("Your Tags"),
            _resultTagsWidget,
            Text('All Tags'),
            _allTagsWidget,
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddDialog,
          child: Icon(Icons.add_circle),
        ),
      ),
    );
  }

  // Widget get _headerWdiget {
  //   return TSearchField();
  // }

  Widget get _resultTagsWidget {
    return Wrap(
      spacing: 3,
      runSpacing: 3,
      children: List.generate(tags.length, (index) => resultItem(tags[index])),
    );
  }

  Widget resultItem(String tag) {
    final exists = tags.contains(tag);
    return TChip(
      avatar: exists ? Icon(Icons.check) : null,
      title: Text(tag),
      onClick: exists
          ? null
          : () {
              tags.add(tag);
              setState(() {});
            },
      onDelete: !exists
          ? null
          : () {
              tags.remove(tag);
              setState(() {});
            },
    );
  }

  Widget get _allTagsWidget {
    return Wrap(
      spacing: 3,
      runSpacing: 3,
      children: List.generate(
        allTags.length,
        (index) => allItem(allTags[index]),
      ),
    );
  }

  Widget allItem(String tag) {
    final exists = tags.contains(tag);
    return TChip(
      avatar: exists ? Icon(Icons.check) : null,
      title: Text(tag),
      onClick: exists
          ? null
          : () {
              tags.add(tag);
              setState(() {});
            },
    );
  }

  void _showAddDialog() {
    showTReanmeDialog(
      context,
      text: '',
      submitText: 'New Tag',
      onCheckIsError: (text) {
        if (tags.contains(text.trim())) return 'Already Exists';

        return null;
      },
      onSubmit: (text) {
        if (!allTags.contains(text)) {
          allTags.add(text.trim());
        }
        tags.add(text.trim());
        setState(() {});
      },
    );
  }
}
