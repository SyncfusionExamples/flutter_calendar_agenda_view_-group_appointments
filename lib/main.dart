import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() => runApp(const CustomAgendaItem());

class CustomAgendaItem extends StatelessWidget {
  const CustomAgendaItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomAgendaHeight(),
    );
  }
}

class CustomAgendaHeight extends StatefulWidget {
  const CustomAgendaHeight({super.key});

  @override
  State<StatefulWidget> createState() => ScheduleExample();
}

class ScheduleExample extends State<CustomAgendaHeight> {
  late List<AppointmentGroup> appointmentGroups;
  List<AppointmentGroup> selectedAppointmentGroups = [];

  @override
  void initState() {
    super.initState();
    appointmentGroups = getAppointmentGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: SfCalendar(
              view: CalendarView.month,
              onTap: (CalendarTapDetails details) {
                if (details.targetElement == CalendarElement.calendarCell) {
                  _showAppointmentsForDate(details.date!);
                }
              },
              dataSource: _DataSource(appointmentGroups),
            ),
          ),
          Expanded(
            child: selectedAppointmentGroups.isNotEmpty
                ? ListView.builder(
                    itemCount: _getItemCount(),
                    itemBuilder: (BuildContext context, int index) {
                      final groupInfo = _getGroupInfo(index);
                      if (groupInfo.isHeader) {
                        return _buildHeader(groupInfo.group!);
                      } else {
                        final appointment = groupInfo.appointment!;
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 4.0),
                          padding: const EdgeInsets.all(8.0),
                          color: appointment.color,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                appointment.subject,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                '${appointment.startTime.hour}:${appointment.startTime.minute.toString().padLeft(2, '0')}'
                                ' - '
                                '${appointment.endTime.hour}:${appointment.endTime.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  )
                : const Center(child: Text('No appointments')),
          ),
        ],
      ),
    );
  }

  int _getItemCount() {
    int count = 0;
    for (var group in selectedAppointmentGroups) {
      count += group.appointments.length + 1;
    }
    return count;
  }

  GroupInfo _getGroupInfo(int index) {
    int currentIndex = 0;
    for (var group in selectedAppointmentGroups) {
      if (index == currentIndex) {
        return GroupInfo(isHeader: true, group: group);
      }
      currentIndex += 1;
      if (index < currentIndex + group.appointments.length) {
        return GroupInfo(
            isHeader: false,
            appointment: group.appointments[index - currentIndex]);
      }
      currentIndex += group.appointments.length;
    }
    throw RangeError.index(index, selectedAppointmentGroups);
  }

  Widget _buildHeader(AppointmentGroup group) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: const Color.fromARGB(192, 0, 0, 0),
      child: Text(
        group.groupName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showAppointmentsForDate(DateTime date) {
    setState(
      () {
        selectedAppointmentGroups = appointmentGroups
            .map((group) => AppointmentGroup(
                  group.groupName,
                  group.appointments.where((appointment) {
                    return appointment.startTime.year == date.year &&
                        appointment.startTime.month == date.month &&
                        appointment.startTime.day == date.day;
                  }).toList(),
                ))
            .where((group) => group.appointments.isNotEmpty)
            .toList();
      },
    );
  }

  List<AppointmentGroup> getAppointmentGroups() {
    final List<Appointment> appointments = <Appointment>[
      Appointment(
        startTime: DateTime(2024, 7, 13, 5),
        endTime: DateTime(2024, 7, 13, 6),
        subject: 'Support Update',
      ),
      Appointment(
        startTime: DateTime(2024, 7, 13, 5),
        endTime: DateTime(2024, 7, 13, 6),
        subject: 'Business Meeting',
      ),
      Appointment(
        startTime: DateTime(2024, 7, 12, 3),
        endTime: DateTime(2024, 7, 12, 4),
        subject: 'Support Update',
      ),
      Appointment(
        startTime: DateTime(2024, 7, 12, 1),
        endTime: DateTime(2024, 7, 12, 2),
        subject: 'Birthday Update',
      ),
      Appointment(
        startTime: DateTime(2024, 7, 12, 10),
        endTime: DateTime(2024, 7, 12, 12),
        subject: 'Business Meeting',
      ),
      Appointment(
        startTime: DateTime(2024, 7, 12, 10),
        endTime: DateTime(2024, 7, 12, 12),
        subject: 'Support Update',
      ),
      Appointment(
        startTime: DateTime(2024, 7, 12, 7),
        endTime: DateTime(2024, 7, 12, 8),
        subject: 'Support Update',
      ),
      Appointment(
        startTime: DateTime(2024, 7, 12, 5),
        endTime: DateTime(2024, 7, 12, 6),
        subject: 'Business Meeting',
      ),
      Appointment(
        startTime: DateTime(2024, 7, 13, 1),
        endTime: DateTime(2024, 7, 13, 2),
        subject: 'Business Meeting',
      ),
      Appointment(
        startTime: DateTime(2024, 7, 13, 10),
        endTime: DateTime(2024, 7, 13, 11),
        subject: 'Birthday Update',
      ),
      Appointment(
        startTime: DateTime(2024, 7, 13, 1),
        endTime: DateTime(2024, 7, 13, 2),
        subject: 'Birthday Update',
      ),
    ];

    List<Appointment> supportMeetings = [];
    List<Appointment> businessMeetings = [];
    List<Appointment> birthdays = [];

    for (var appointment in appointments) {
      if (appointment.subject.contains('Support')) {
        supportMeetings.add(appointment);
      } else if (appointment.subject.contains('Business')) {
        businessMeetings.add(appointment);
      } else {
        birthdays.add(appointment);
      }
    }

    supportMeetings.sort((a, b) => a.startTime.compareTo(b.startTime));
    businessMeetings.sort((a, b) => a.startTime.compareTo(b.startTime));
    birthdays.sort((a, b) => a.startTime.compareTo(b.startTime));

    return [
      AppointmentGroup('Support Meetings', supportMeetings),
      AppointmentGroup('Business Meetings', businessMeetings),
      AppointmentGroup('General Meetings', birthdays),
    ];
  }
}

class AppointmentGroup {
  final String groupName;
  final List<Appointment> appointments;

  AppointmentGroup(this.groupName, this.appointments);
}

class GroupInfo {
  final bool isHeader;
  final AppointmentGroup? group;
  final Appointment? appointment;

  GroupInfo({required this.isHeader, this.group, this.appointment});
}

class _DataSource extends CalendarDataSource {
  final List<AppointmentGroup> appointmentGroups;

  _DataSource(this.appointmentGroups) {
    appointments = appointmentGroups
        .expand((group) => group.appointments)
        .toList(growable: false);
  }
}
