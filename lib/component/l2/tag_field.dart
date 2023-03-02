import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../../service/const_design.dart';
import '../l1/tag.dart';

class TagField extends StatefulWidget {
  final List<String> samples;
  final List<String> initialTags;
  final int maxTagNumber;
  final int maxTagLength;
  final bool viewTitle;
  final void Function(List<String>)? onChanged;

  const TagField({
    super.key,
    required this.samples,
    required this.maxTagNumber,
    this.initialTags = const [],
    this.maxTagLength = 10,
    this.viewTitle = true,
    this.onChanged,
  });

  @override
  State<TagField> createState() => TagFieldState();
}

class TagFieldState extends State<TagField> {
  late double _distanceToField;
  late TextfieldTagsController tagsController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    tagsController.dispose();
  }

  @override
  void initState() {
    super.initState();
    tagsController = TextfieldTagsController();
    if (widget.onChanged != null) {
      tagsController
          .addListener(() => widget.onChanged!(tagsController.getTags ?? []));
    }
  }

  String? validator(String tag) {
    if (tagsController.getTags!.length > widget.maxTagNumber - 1) {
      return 'タグは最大${widget.maxTagNumber}個です';
    }
    if (tag.length > widget.maxTagLength) {
      return 'タグは最大${widget.maxTagLength}文字です';
    }
    if (tagsController.getTags!.contains(tag)) {
      return '追加済みです';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.viewTitle
            ? const Text('タグ', style: TextStyle(fontSize: 12))
            : const SizedBox(),
        TextFieldTags(
          textfieldTagsController: tagsController,
          initialTags: widget.initialTags,
          textSeparators: const [' ', ','],
          letterCase: LetterCase.normal,
          validator: validator,
          inputfieldBuilder: inputFieldBuilder,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: (widget.samples
                  .map(
                    (text) => Tag(
                      text: text,
                      onTap: () => tagsController.addTag = text,
                    ),
                  )
                  .toList())),
        )
      ],
    );
  }

  Widget Function(
    BuildContext context,
    ScrollController sc,
    List<String> tags,
    void Function(String p1) onTagDelete,
  ) inputFieldBuilder(
      BuildContext context,
      TextEditingController tec,
      FocusNode fn,
      String? error,
      void Function(String)? onChanged,
      void Function(String)? onSubmitted) {
    return ((BuildContext context, dynamic sc, List<String> tags,
        void Function(String) onTagDelete) {
      return TextField(
        controller: tec,
        focusNode: fn,
        decoration: InputDecoration(
          isDense: true,
          hintText: tagsController.hasTags ? '' : "タグを入力...",
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
                                tagColor: ConstDesign.validTagColor,
                              ))
                          .toList()))
              : null,
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      );
    });
  }
}
