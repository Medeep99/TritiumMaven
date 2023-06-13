import 'package:floor/floor.dart';

import 'folder.dart';
import 'template.dart';

@Entity(
  tableName: 'template_tracker',
  foreignKeys: [
    ForeignKey(
      childColumns: ['id'],
      parentColumns: ['id'],
      entity: Template,
      onDelete: ForeignKeyAction.cascade,
    ),
    ForeignKey(
      childColumns: ['folder_id'],
      parentColumns: ['folder_id'],
      entity: Folder,
    ),
  ],
)
class TemplateTracker {
  const TemplateTracker({
    this.templateTrackerId,
    this.completed = false,
    required this.templateId,
    required this.folderId,
  });

  @PrimaryKey(autoGenerate: true)
  @ColumnInfo(name: 'template_tracker_id')
  final int? templateTrackerId;

  @ColumnInfo(name: 'completed')
  final bool completed;

  @ColumnInfo(name: 'id')
  final int templateId;

  @ColumnInfo(name: 'folder_id')
  final int folderId;

  TemplateTracker copyWith({
    int? templateTrackerId,
    bool? completed,
    int? templateId,
    int? folderId,
  }) {
    return TemplateTracker(
      templateTrackerId: templateTrackerId ?? this.templateTrackerId,
      completed: completed ?? this.completed,
      templateId: templateId ?? this.templateId,
      folderId: folderId ?? this.folderId,
    );
  }
}