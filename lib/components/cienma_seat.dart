import 'package:flutter/material.dart';

import 'package:movies_app_flutter/utils/constants.dart';

class CienmaSeat extends StatefulWidget {
  bool isReserved;

  bool isSelected;
  int index;
  Function(int) onSelectParam;

  CienmaSeat(
      {Key? key,
      this.isSelected = false,
      this.isReserved = false,
      this.index = 0,
      required this.onSelectParam})
      : super(key: key);

  @override
  _CienmaSeatState createState() => _CienmaSeatState();
}

class _CienmaSeatState extends State<CienmaSeat> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setState(() {
          !widget.isReserved ? widget.isSelected = !widget.isSelected : null;
          widget.onSelectParam(widget.index);
        });
      },
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
          width: MediaQuery.of(context).size.width / 25,
          height: MediaQuery.of(context).size.width / 25,
          decoration: BoxDecoration(
              color: widget.isSelected
                  ? kMainOrangeColor
                  : widget.isReserved
                      ? Colors.white
                      : null,
              border: !widget.isSelected && !widget.isReserved
                  ? Border.all(color: Colors.white, width: 1.0)
                  : null,
              borderRadius: BorderRadius.circular(5.0))),
    );
  }
}
