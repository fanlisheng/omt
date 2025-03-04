// 职位选择页面

import 'package:flutter/material.dart';
import 'package:omt/bean/common/id_name_value.dart';

import '../../../utils/color_utils.dart';

class UserPositionSelectionPage extends StatefulWidget {
  final List<IdNameValue> positions;

  UserPositionSelectionPage({required this.positions});

  @override
  _UserPositionSelectionPageState createState() =>
      _UserPositionSelectionPageState();
}

class _UserPositionSelectionPageState extends State<UserPositionSelectionPage> {
  int? _selectedId; // 记录当前选中的职位 ID

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 20,),
      const Text(
        "请选择职位",
        style: TextStyle(
            fontSize: 18,
            color: ColorUtils.colorBlack),
      ),
      const SizedBox(height: 20,),
      Expanded(child: ListView.builder(
        itemCount: widget.positions.length,
        itemBuilder: (context, index) {
          final position = widget.positions[index];
          final int id = position.id ?? 0;
          final String name = position.name ?? "";
          final bool isSelected = _selectedId == id;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedId = id; // 点击时选中当前行，取消其他选中
              });
              // 可选：返回选中的职位
              Navigator.pop(context, position);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey, // 选中时边框蓝色
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(3.0),
              ),
              child: Text(
                name,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.black, // 选中时文字蓝色
                  fontSize: 14.0,
                ),
              ),
            ),
          );
        },
      ),),
      SizedBox(height: 150),
    ],);
  }
}
