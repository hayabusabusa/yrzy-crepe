import 'package:flutter/material.dart';

class CRPSlider extends StatefulWidget {
  final double value;
  final double max;
  final void Function(double)? onChanged;

  const CRPSlider({ 
    Key? key,
    this.value = 0,
    this.max = 1.0,
    this.onChanged,
  }) : assert(value > 0), 
       assert(value < max),
       super(key: key);

  @override
  _CRPSliderState createState() => _CRPSliderState();
}

class _CRPSliderState extends State<CRPSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    // NOTE: スライダーを右から左に動かすようにしたいので
    // 初期値の指定がない場合 or 0 の場合は現在値を最大値に設定する.
    _currentValue = widget.value == 0 ? widget.max : widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Slider(
        value: _currentValue,
        divisions: widget.max.toInt(),
        max: widget.max,
        onChanged: (value) {
          final onChanged = widget.onChanged;
          if (onChanged != null) {
            // NOTE: 右から左に動かしているので、最大値から現在値を引いた位置をコールバックに返す.
            final _value = widget.max - value;
            onChanged(_value);
          }
          setState(() {
            _currentValue = value;
          });
        }
      ),
    );
  }
}