import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LinkifyText extends StatelessWidget {
  const LinkifyText({
    super.key,
    required this.text,
    this.onOpenLink,
    this.style = const TextStyle(
      color: Colors.black,
    ),
    this.linkStyle = const TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
    ),
  });
  final String text;
  final void Function(String)? onOpenLink;
  final TextStyle linkStyle;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        children: extractText(text),
      ),
    );
  }

  List<TextSpan> extractText(String rawString) {
    List<TextSpan> textSpan = [];

    final urlRegExp = RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");

    getLink(String linkString) {
      textSpan.add(
        TextSpan(
          text: linkString,
          style: linkStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              onOpenLink!(linkString);
            },
        ),
      );
      return linkString;
    }

    getNormalText(String normalText) {
      textSpan.add(
        TextSpan(
          text: normalText,
          style: const TextStyle(color: Colors.black),
        ),
      );
      return normalText;
    }

    rawString.splitMapJoin(
      urlRegExp,
      onMatch: (m) => getLink("${m.group(0)}"),
      onNonMatch: (n) => getNormalText(n.substring(0)),
    );

    return textSpan;
  }
}
