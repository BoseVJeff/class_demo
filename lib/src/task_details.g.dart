// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskDetails _$TaskDetailsFromJson(Map<String, dynamic> json) => TaskDetails(
  hoursSpent: (json['hoursSpent'] as num).toInt(),
  technologiesUsed: (json['technologiesUsed'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  taskId: json['taskId'] as String,
  title: json['title'] as String,
  status: json['status'] as String,
  details: TaskDetails.fromJson(json['details'] as Map<String, dynamic>),
);

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
  projectId: json['projectId'] as String,
  name: json['name'] as String,
  startDate: json['startDate'] as String,
  tasks: (json['tasks'] as List<dynamic>)
      .map((e) => Task.fromJson(e as Map<String, dynamic>))
      .toList(),
);

ManagerContact _$ManagerContactFromJson(Map<String, dynamic> json) =>
    ManagerContact(
      email: json['email'] as String,
      phone: json['phone'] as String,
    );

Manager _$ManagerFromJson(Map<String, dynamic> json) => Manager(
  id: json['id'] as String,
  name: json['name'] as String,
  contact: ManagerContact.fromJson(json['contact'] as Map<String, dynamic>),
);

Department _$DepartmentFromJson(Map<String, dynamic> json) => Department(
  id: json['id'] as String,
  name: json['name'] as String,
  manager: Manager.fromJson(json['manager'] as Map<String, dynamic>),
);

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
  id: json['id'] as String,
  name: json['name'] as String,
  position: json['position'] as String,
  department: Department.fromJson(json['department'] as Map<String, dynamic>),
);
