import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:vc_space/component/l1/tag.dart';

class TagField extends StatefulWidget {
  final List<String> samples;

  const TagField({super.key, required this.samples});

  @override
  State<TagField> createState() => _TagField();
}

class _TagField extends State<TagField> {
  late double _distanceToField;
  late TextfieldTagsController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextfieldTagsController();
  }

  String? validator(String tag) {
    if (_controller.getTags!.contains(tag)) {
      return '追加済みです';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFieldTags(
          textfieldTagsController: _controller,
          initialTags: const [],
          textSeparators: const [' ', ','],
          letterCase: LetterCase.normal,
          validator: validator,
          inputfieldBuilder: builder,
        ),
        Wrap(
            spacing: 2.0,
            children: (widget.samples
                .map(
                  (text) => Tag(
                    text: text,
                    onTap: () => {_controller.addTag = text},
                  ),
                )
                .toList())),
      ],
    );
  }

  Widget Function(BuildContext context, ScrollController sc, List<String> tags,
          void Function(String p1) onTagDelete)
      builder(
          BuildContext context,
          TextEditingController tec,
          FocusNode fn,
          String? error,
          void Function(String)? onChanged,
          void Function(String)? onSubmitted) {
    return ((BuildContext context, dynamic sc, List<String> tags,
        void Function(String) onTagDelete) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          controller: tec,
          focusNode: fn,
          decoration: InputDecoration(
            isDense: true,
            hintText: _controller.hasTags ? '' : "タグを入力...",
            errorText: error,
            prefixIconConstraints:
                BoxConstraints(maxWidth: _distanceToField * 0.74),
            prefixIcon: tags.isNotEmpty
                ? SingleChildScrollView(
                    controller: sc,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: tags
                            .map((String text) => Tag(
                                  text: text,
                                  onTap: () => onTagDelete(text),
                                  tagColor: Colors.lightGreen,
                                ))
                            .toList()))
                : null,
          ),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        ),
      );
    });
  }
}
