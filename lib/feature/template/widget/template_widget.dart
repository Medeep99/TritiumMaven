import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maven/common/dialog/list_dialog.dart';
import 'package:maven/common/dialog/show_bottom_sheet_dialog.dart';
import 'package:maven/feature/template/bloc/template/template_bloc.dart';

import '../../../database/model/template.dart';
import '../../../theme/widget/inherited_theme_widget.dart';
import '../screen/template_detail_screen.dart';

class TemplateWidget extends StatefulWidget {
  const TemplateWidget({
    Key? key,
    required this.template,
  }) : super(key: key);

  final Template template;

  @override
  State<TemplateWidget> createState() => _TemplateWidgetState();
}

class _TemplateWidgetState extends State<TemplateWidget> {
  final double _borderRadius = 16;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TemplateDetailScreen(
                  template: widget.template,
                ),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_borderRadius),
              color: T(context).color.surface,
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.template.name,
                  style: T(context).textStyle.titleLarge,
                  maxLines: 2,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.template.exerciseBundles.length,
                    itemBuilder: (context, index) {
                      return Text(
                        '\u2022 ${widget.template.exerciseBundles[index].exercise.name}',
                        style: T(context).textStyle.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: () {
              showBottomSheetDialog(
                context: context,
                child: ListDialog(
                  children: [
                    ListTile(
                      onTap: () {
                        context.read<TemplateBloc>().add(TemplateDelete(
                              template: widget.template,
                            ));
                        Navigator.pop(context);
                      },
                      leading: Icon(
                        Icons.delete,
                        color: T(context).color.error,
                      ),
                      title: Text(
                        'Delete',
                        style: TextStyle(
                          color: T(context).color.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.more_horiz,
            ),
          ),
        ),
      ],
    );
  }
}
