import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_details.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.none)
class TaskDetails extends Equatable {
  final int hoursSpent;
  final List<String> technologiesUsed;

  const TaskDetails({required this.hoursSpent, required this.technologiesUsed});

  factory TaskDetails.fromJson(Map<String, dynamic> json) =>
      _$TaskDetailsFromJson(json);

  @override
  // TODO: implement props
  List<Object?> get props => [hoursSpent, technologiesUsed];
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.none)
class Task extends Equatable {
  final String taskId;
  final String title;
  final String status;
  final TaskDetails details;

  const Task({
    required this.taskId,
    required this.title,
    required this.status,
    required this.details,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  @override
  // TODO: implement props
  List<Object?> get props => [taskId, title, status, details];
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.none)
class Project extends Equatable {
  final String projectId;
  final String name;
  final String startDate;
  final List<Task> tasks;

  const Project({
    required this.projectId,
    required this.name,
    required this.startDate,
    required this.tasks,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  @override
  // TODO: implement props
  List<Object?> get props => [projectId, name, startDate, tasks];
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.none)
class ManagerContact extends Equatable {
  final String email;
  final String phone;

  const ManagerContact({required this.email, required this.phone});

  factory ManagerContact.fromJson(Map<String, dynamic> json) =>
      _$ManagerContactFromJson(json);

  @override
  // TODO: implement props
  List<Object?> get props => [email, phone];
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.none)
class Manager extends Equatable {
  final String id;
  final String name;
  final ManagerContact contact;

  const Manager({required this.id, required this.name, required this.contact});

  factory Manager.fromJson(Map<String, dynamic> json) =>
      _$ManagerFromJson(json);

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, contact];
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.none)
class Department extends Equatable {
  final String id;
  final String name;
  final Manager manager;

  const Department({
    required this.id,
    required this.name,
    required this.manager,
  });

  factory Department.fromJson(Map<String, dynamic> json) =>
      _$DepartmentFromJson(json);

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, manager];
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.none)
class Employee extends Equatable {
  final String id;
  final String name;
  final String position;
  final Department department;

  const Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.department,
  });

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  @override
  List<Object?> get props => [id, name, position, department];
}
