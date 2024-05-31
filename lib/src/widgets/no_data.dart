import 'package:flutter/material.dart';

class NoData extends StatefulWidget {
  final String text;

  const NoData({super.key, this.text = 'No hay información'});

  @override
  _NoDataState createState() => _NoDataState();
}

class _NoDataState extends State<NoData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image.asset('assets/img/no-items.png'),
          Text(widget.text),
        ],
      ),
    );
  }
}
