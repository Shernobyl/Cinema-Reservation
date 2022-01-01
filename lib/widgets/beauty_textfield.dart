import 'package:flutter/material.dart';
import 'package:movies_app_flutter/utils/constants.dart';

class BeautyTextfield extends StatefulWidget {
  final BorderRadius cornerRadius;
  final double width, height, wordSpacing;
  final Color backgroundColor, accentColor, textColor;
  final String placeholder;
  final Icon prefixIcon;
  final TextInputType inputType;
  final EdgeInsets margin;
  final Duration duration;
  final TextBaseline textBaseline;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final bool autofocus, autocorrect, enabled, obscureText, isShadow;
  final FocusNode focusNode;
  final int maxLength, minLines, maxLines;
  final ValueChanged<String> onChanged, onSubmitted;
  final GestureTapCallback onTap;
  final TextEditingController controller;

  const BeautyTextfield(
      {required this.width,
      required this.height,
      required this.prefixIcon,
      required this.inputType,
      required this.controller,
      this.duration = const Duration(milliseconds: 500),
      this.margin = const EdgeInsets.all(10),
      this.obscureText = false,
      this.backgroundColor = const Color(0xff111823),
      this.cornerRadius = const BorderRadius.all(Radius.circular(10)),
      this.textColor = const Color(0xff5c5bb0),
      this.accentColor = Colors.white,
      this.placeholder = "Placeholder",
      this.isShadow = true,
      required this.wordSpacing,
      required this.textBaseline,
      required this.fontStyle,
      required this.fontWeight,
      this.autofocus = false,
      this.autocorrect = false,
      required this.focusNode,
      this.enabled = true,
      required this.maxLength,
      required this.maxLines,
      required this.minLines,
      required this.onChanged,
      required this.onTap,
      required this.onSubmitted})
      : assert(width != null),
        assert(height != null),
        assert(prefixIcon != null),
        assert(inputType != null);

  @override
  _BeautyTextfieldState createState() => _BeautyTextfieldState();
}

class _BeautyTextfieldState extends State<BeautyTextfield> {
  bool isFocus = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          boxShadow: widget.isShadow
              ? [BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: 1)]
              : [BoxShadow(spreadRadius: 0, blurRadius: 0)],
          borderRadius: widget.cornerRadius,
          color: isFocus ? widget.accentColor : widget.backgroundColor),
      child: Stack(
        children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Icon(
                    widget.prefixIcon.icon,
                    color:
                        isFocus ? widget.backgroundColor : widget.accentColor,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: EdgeInsets.only(right: 50, top: 3),
                    child: TextField(
                      controller: widget.controller,
                      cursorWidth: 2,
                      obscureText: widget.obscureText,
                      keyboardType: widget.inputType,
                      style: TextStyle(
                        fontStyle: widget.fontStyle,
                        fontWeight: widget.fontWeight,
                        wordSpacing: widget.wordSpacing,
                        textBaseline: widget.textBaseline,
                        fontSize: 18,
                        letterSpacing: 2,
                        color: widget.textColor,
                      ),
                      autofocus: widget.autofocus,
                      autocorrect: widget.autocorrect,
                      focusNode: widget.focusNode,
                      enabled: widget.enabled,
                      maxLength: widget.maxLength,
                      maxLines: widget.maxLines,
                      minLines: widget.minLines,
                      onChanged: widget.onChanged,
                      onTap: () {
                        setState(() {
                          isFocus = true;
                        });
                        if (widget.onTap != null) {
                          widget.onTap();
                        }
                      },
                      onSubmitted: (t) {
                        setState(() {
                          isFocus = false;
                        });
                        widget.onSubmitted(t);
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: kBackgroundShadowColor),
                          hintText: widget.placeholder,
                          border: InputBorder.none),
                      cursorColor:
                          isFocus ? Colors.white70 : widget.backgroundColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      duration: widget.duration,
    );
  }
}
