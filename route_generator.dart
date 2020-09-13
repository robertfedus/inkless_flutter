/*
 * Created on Fri Aug 21 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:Inkless/operator/home/student_button.dart';
import 'package:flutter/material.dart';
import './main.dart';
import './auth/welcome.dart';
import './auth/register.dart';
import './auth/login.dart';

import './operator/home/operator_home.dart';
import './operator/home/class_students_list.dart';
import './operator/home/student_information.dart';
import './operator/home/register_student.dart';
import './operator/home/add_class.dart';
import './operator/messages/operator_messages.dart';
import './operator/teachers/operator_teachers.dart';
import './operator/teachers/teacher_information.dart';
import './operator/teachers/register_teacher.dart';
import './operator/timetable/operator_timetable.dart';
import './operator/timetable/day.dart';
import './operator/timetable/add_hour.dart';
import './operator/settings/operator_settings.dart';
import './operator/settings/operator_account_settings.dart';

import './teacher/home/teacher_home.dart';
import './teacher/home/class_students_list.dart';
import './teacher/home/student_information.dart';
import './teacher/home/mark_information.dart';
import './teacher/home/add_mark.dart';
import './teacher/home/student_absences.dart';
import './teacher/home/absence_information.dart';
import './teacher/home/add_absence.dart';
import './teacher/home/send_message.dart';
import './teacher/messages/teacher_messages.dart';
import './teacher/timetable/teacher_timetable.dart';
import './teacher/timetable/day.dart';
import './teacher/settings/teacher_account_settings.dart';
import './teacher/settings/teacher_settings.dart';
import './teacher/master_class/master_class.dart';
import './teacher/master_class/student_subjects.dart';
import './teacher/master_class/student_information.dart';
import './teacher/tests/teacher_tests.dart';
import './teacher/tests/add_test.dart';

import './global/settings/change_password.dart';
import './global/settings/change_email.dart';
import './global/settings/enter_email_code.dart';
import './global/settings/help_and_support.dart';
import './global/settings/about_us.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    // Navigator.of(context).pushNamed('/second',
    //                           arguments: 'Hello from first page');
    // final args reprezinta in acest caz 'Hello from first page'

    switch (settings.name) {
      // Global routes:
      case '/change_password':
        return MaterialPageRoute(builder: (_) => ChangePassword());
        break;
      case '/about_us':
        return MaterialPageRoute(builder: (_) => AboutUs());
        break;
      case '/change_email':
        return MaterialPageRoute(builder: (_) => ChangeEmail());
        break;
      case '/enter_email_code':
        if (args is Map) {
          return MaterialPageRoute(
              builder: (_) => EnterEmailCode(email: args['email']));
        }
        return _errorRoute();
        break;
      case '/help_and_support':
        return MaterialPageRoute(builder: (_) => HelpAndSupport());
        break;
      case '/':
        return MaterialPageRoute(builder: (_) => Welcome());
        break;
      case '/register':
        return MaterialPageRoute(builder: (_) => Register());
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());

      // Operator routes:
      case '/operator_home':
        return MaterialPageRoute(builder: (_) => OperatorHome());
      case '/operator_class_students_list':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => ClassStudentsList(
              classLetter: args['letter'],
              classGrade: args['classGrade'],
              publicId: args['public_id'],
            ),
          );
        }
        return _errorRoute();
        break;
      case '/operator_student_information':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => StudentInformation(
              name: args['name'],
              username: args['username'],
              publicId: args['publicId'],
            ),
          );
        }
        return _errorRoute();
        break;
      case '/operator_register_student':
        if (args is Map) {
          return MaterialPageRoute(
              builder: (_) =>
                  RegisterStudent(classPublicId: args['classPublicId']));
        }
        break;
      case '/operator_add_class':
        return MaterialPageRoute(builder: (_) => AddClass());
        break;
      case '/operator_messages':
        return MaterialPageRoute(builder: (_) => OperatorMessages());
        break;
      case '/operator_teachers':
        return MaterialPageRoute(builder: (_) => OperatorTeachers());
        break;
      case '/operator_teacher_information':
        if (args is Map) {
          return MaterialPageRoute(
              builder: (_) => TeacherInformation(
                  name: args['name'], username: args['username']));
        }
        break;
      case '/operator_register_teacher':
        return MaterialPageRoute(builder: (_) => RegisterTeacher());
        break;
      case '/operator_timetable':
        return MaterialPageRoute(builder: (_) => OperatorTimetable());
        break;
      case '/operator_timetable_day':
        if (args is Map) {
          return MaterialPageRoute(
              builder: (_) => OperatorTimetableDay(
                  day: args['day'], dayIndex: args['dayIndex']));
        }
        break;
      case '/operator_timetable_add_hour':
        if (args is Map) {
          return MaterialPageRoute(
              builder: (_) => AddHour(dayIndex: args['dayIndex']));
        }
        break;
      case '/operator_settings':
        return MaterialPageRoute(builder: (_) => OperatorSettings());
        break;
      case '/operator_account_settings':
        return MaterialPageRoute(builder: (_) => OperatorAccountSettings());
        break;

      // Teacher routes:
      case '/teacher_home':
        return MaterialPageRoute(builder: (_) => TeacherHome());
      case '/teacher_class_students_list':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => TeacherClassStudentsList(
              classLetter: args['letter'],
              classGrade: args['classGrade'],
              publicId: args['public_id'],
              subjectPublicId: args['subjectPublicId'],
            ),
          );
        }
        return _errorRoute();
        break;
      case '/teacher_student_information':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => TeacherStudentInformation(
              name: args['name'],
              username: args['username'],
              userPublicId: args['publicId'],
              subjectPublicId: args['subjectPublicId'],
            ),
          );
        }
        return _errorRoute();
        break;
      case '/teacher_mark_information':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => MarkInformation(
              value: args['value'],
              message: args['message'],
              thesis: args['thesis'],
              date: args['date'],
              markPublicId: args['markPublicId'],
            ),
          );
        }
        return _errorRoute();
        break;
      case '/teacher_add_mark':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => AddMark(
                studentPublicId: args['studentPublicId'],
                subjectPublicId: args['subjectPublicId']),
          );
        }
        break;

      case '/teacher_student_absences':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => TeacherStudentAbsences(
              name: args['name'],
              username: args['username'],
              userPublicId: args['studentPublicId'],
              subjectPublicId: args['subjectPublicId'],
              master: args['master'],
            ),
          );
        }
        break;
      case '/teacher_absence_information':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => AbsenceInformation(
              motivated: args['motivated'],
              message: args['message'],
              date: args['date'],
              absencePublicId: args['absencePublicId'],
              master: args['master'],
            ),
          );
        }
        return _errorRoute();
        break;
      case '/teacher_add_absence':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => AddAbsence(
                studentPublicId: args['studentPublicId'],
                subjectPublicId: args['subjectPublicId']),
          );
        }
        break;
      case '/teacher_send_message':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => SendMessage(
              studentPublicId: args['studentPublicId'],
            ),
          );
        }
        break;
      case '/teacher_messages':
        return MaterialPageRoute(builder: (_) => TeacherMessages());
        break;
      case '/teacher_tests':
        return MaterialPageRoute(builder: (_) => TeacherTests());
        break;
      case '/teacher_add_test':
        return MaterialPageRoute(builder: (_) => AddTest());
        break;
      case '/teacher_timetable':
        return MaterialPageRoute(builder: (_) => TeacherTimetable());
        break;

      case '/teacher_timetable_day':
        if (args is Map) {
          return MaterialPageRoute(
              builder: (_) => TeacherTimetableDay(
                  day: args['day'], dayIndex: args['dayIndex']));
        }
        break;
      case '/teacher_master_class':
        return MaterialPageRoute(builder: (_) => MasterClass());
        break;
      case '/teacher_student_subjects':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => TeacherStudentSubjects(
              userPublicId: args['userPublicId'],
            ),
          );
        }
        break;
      case '/teacher_master_student_information':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => MasterStudentInformation(
              userPublicId: args['userPublicId'],
              subjectPublicId: args['subjectPublicId'],
            ),
          );
        }
        return _errorRoute();
        break;
      case '/teacher_settings':
        return MaterialPageRoute(builder: (_) => TeacherSettings());
        break;
      case '/teacher_account_settings':
        return MaterialPageRoute(builder: (_) => TeacherAccountSettings());
        break;

      //
      //
      // Default
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
