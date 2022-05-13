import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

/// 所有选择器的子项组件

class TDItemWidget extends StatefulWidget {
  final String content;
  final FixedExtentScrollController fixedExtentScrollController;
  final int index;
  final double itemHeight;
  final ItemDistanceCalculator? itemDistanceCalculator;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? textColor;
  final Color? lightTextColor;

  const TDItemWidget(
      {required this.fixedExtentScrollController,
      required this.index,
      required this.content,
      required this.itemHeight,
      this.itemDistanceCalculator,
      this.fontWeight,
      this.textColor,
      this.lightTextColor,
      this.fontSize,
      Key? key})
      : super(key: key);

  @override
  _TDItemWidgetState createState() => _TDItemWidgetState();
}

class _TDItemWidgetState extends State<TDItemWidget> {
  /// 子项监听滚动，从而刷新自身的颜色
  VoidCallback? listener;
  ItemDistanceCalculator? _itemDistanceCalculator;

  @override
  void initState() {
    super.initState();
    listener = () => setState(() {});
    _itemDistanceCalculator == widget.itemDistanceCalculator;

    /// 子项注册滚动监听
    widget.fixedExtentScrollController.addListener(listener!);
  }

  @override
  Widget build(BuildContext context) {
    /// 子项此时离中心的距离
    /// 不要使用widget.fixedExtentScrollController.selectedItem
    /// 其中selectedItem会报错，原因是一开始minScrollExtent为空
    double distance =
        (widget.fixedExtentScrollController.offset / widget.itemHeight -
                widget.index)
            .abs()
            .toDouble();
    _itemDistanceCalculator ??= ItemDistanceCalculator(
        fontWeight: widget.fontWeight,
        fontSize: widget.fontSize,
        textColor: widget.textColor);
    return TDText(widget.content,
        customStyle: TextStyle(
          fontWeight: _itemDistanceCalculator!.calculateFontWeight(context, distance),
          fontSize: _itemDistanceCalculator!.calculateFont(context, distance),
          color: _itemDistanceCalculator!.calculateColor(context, distance)
        ));
  }

  @override
  void dispose() {
    /// 在销毁前完成监听注销
    widget.fixedExtentScrollController.removeListener(listener!);
    super.dispose();
  }
}

class ItemDistanceCalculator {
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? textColor;
  final Color? lightColor;

  ItemDistanceCalculator({this.fontSize, this.textColor, this.fontWeight, this.lightColor});

  Color calculateColor(BuildContext context, double distance) {
    /// 线性插值
    if (distance < 0.5) {
      return textColor ?? TDTheme.of(context).fontGyColor1;
    } else {
      return lightColor ?? TDTheme.of(context).fontGyColor4;
    }
  }

  FontWeight calculateFontWeight(BuildContext context, double distance) {
    return fontWeight ?? FontWeight.w400;
  }

  double? calculateFont(BuildContext context, double distance) {
    return fontSize ?? TDTheme.of(context).fontM!.size;
  }
}
