import 'package:flutter/material.dart';

import '../../theme/m_themes.dart';
import '../widget/m_button.dart';

/// Dialog that prompts the user to enter some text.
///
/// To be used with [showBottomSheetDialog].
class TextInputDialog extends StatefulWidget {
  /// Creates a text input dialog
  const TextInputDialog({Key? key,
    required this.title,
    this.hintText = '',
    required this.initialValue,
    this.keyboardType = TextInputType.number,
    this.onValueChanged,
    this.onValueSubmit,
  }) : super(key: key);

  /// The bold text displayed at the top of the dialog.
  final String title;

  /// The text which is filled in the [TextFormField] at the start.
  final String hintText;
  final String initialValue;
  final TextInputType keyboardType;
  final ValueChanged<String>? onValueChanged;
  final ValueChanged<String>? onValueSubmit;

  @override
  State<TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  late TextEditingController _textEditingController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _textEditingController = TextEditingController(text: widget.initialValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: mt(context).color.primary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 30),
          Form(
            key: _formKey,
            child: TextFormField(
              onChanged: (value) {
                if(widget.onValueChanged == null) return;
                if(value.isEmpty) value = 0.toString();
                widget.onValueChanged!(value);
              },
              validator: (value) {
                if(value == null || value.isEmpty) return "The input cannot be empty.";
                return null;
              },
              controller: _textEditingController,
              keyboardType: widget.keyboardType,
              style: mt(context).textStyle.body1,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: mt(context).textStyle.subtitle1,
                errorStyle: TextStyle(
                  color: mt(context).textField.errorOutlineColor,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    width: 3,
                    style: BorderStyle.solid,
                    color: mt(context).color.secondary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    width: 3,
                    style: BorderStyle.solid,
                    color: mt(context).color.primary,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(
                    width: 3,
                    style: BorderStyle.solid,
                    color: mt(context).textField.errorOutlineColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              MButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                backgroundColor: mt(context).color.background,
                borderColor: mt(context).color.secondary,
                borderRadius: 12,
                height: 50,
                child: Text(
                  'Cancel',
                  style: mt(context).textStyle.body1,
                ),
              ),
              const SizedBox(width: 15,),
              MButton(
                onPressed: (){
                  if (_formKey.currentState!.validate()) {
                    if(widget.onValueSubmit != null) {
                      widget.onValueSubmit!(_textEditingController.text);
                    }
                    Navigator.pop(context);
                  }
                },
                backgroundColor: mt(context).color.primary,
                borderRadius: 12,
                height: 50,
                child: Text(
                  'Submit',
                  style: TextStyle(
                      color: mt(context).color.neutral,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
