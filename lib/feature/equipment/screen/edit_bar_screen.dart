import 'package:Maven/common/dialog/show_bottom_sheet_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/dialog/text_input_dialog.dart';
import '../../../common/widget/m_button.dart';
import '../../../database/model/bar.dart';
import '../../../theme/m_themes.dart';
import '../bloc/equipment/equipment_bloc.dart';

class EditBarScreen extends StatefulWidget {
  const EditBarScreen({Key? key,
    required this.bar,
  }) : super(key: key);

  final Bar bar;

  @override
  State<EditBarScreen> createState() => _EditBarScreenState();
}

class _EditBarScreenState extends State<EditBarScreen> {
  late Bar _bar;

  @override
  void initState() {
    _bar = widget.bar;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Bar'),
        actions: [
          MButton(
            onPressed: (){
              context.read<EquipmentBloc>().add(BarUpdate(bar: _bar));
              Navigator.pop(context);
            },
            width: 75,
            child: Text(
              'Save',
              style: mt(context).textStyle.body1,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 200,
            child: Image.asset('assets/icons8-barbell-512.png'),
          ),
          ListTile(
            onTap: () => showBottomSheetDialog(
              context: context,
              child: TextInputDialog(
                title: 'Enter Bar Name',
                initialValue: _bar.name,
                keyboardType: TextInputType.name,
                onValueSubmit: (value) {
                  setState(() {
                    _bar = _bar.copyWith(name: value);
                  });
                },
              ),
              onClose: (){},
            ),
            title: Text(
              'Name',
              style: mt(context).textStyle.body1,
            ),
            subtitle: Text(
              _bar.name,
              style: mt(context).textStyle.subtitle1,
            ),
          ),
          ListTile(
            onTap: () => showBottomSheetDialog(
              context: context,
              child: TextInputDialog(
                title: 'Weight',
                initialValue: _bar.weight.toString(),
                onValueSubmit: (value) {
                  setState(() {
                    _bar = _bar.copyWith(weight: double.tryParse(value) ?? _bar.weight);
                  });
                },
              ),
              onClose: (){},
            ),
            title: Text(
              'Weight',
              style: mt(context).textStyle.body1,
            ),
            subtitle: Text(
              _bar.weight.toString(),
              style: mt(context).textStyle.subtitle1,
            ),
          ),
        ],
      ),
    );
  }
}
