import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/consts/utils.dart';
import 'package:online_college/model/leave_application_model.dart';
import 'package:online_college/providers/leave_application_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/v4.dart';

bottomSheetForLeaveApplication({
  bool isEdit = false,
  LeaveApplicationModel? leaveApplicationModel,
  required BuildContext context,
}) {
  bool isLoading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime dateTimeStart = DateTime.now();
  DateTime dateTimeEnd = DateTime.now().add(const Duration(days: 1));
  String lid = '';

  if (leaveApplicationModel != null) {
    lid = leaveApplicationModel.lid;
    titleController.text = leaveApplicationModel.title;
    descriptionController.text = leaveApplicationModel.description;
    dateTimeStart = DateTime.parse(leaveApplicationModel.startDate);
    dateTimeEnd = DateTime.parse(leaveApplicationModel.endDate);
  } else {
    lid = const UuidV4().generate().toString();
  }

  showModalBottomSheet(
    enableDrag: true,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, set) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 380,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/background 2.png'),
              ),
            ),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF2855AE),
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: titleController,
                          cursorColor: const Color(0xFF6688CA),
                          cursorWidth: 3,
                          style: GoogleFonts.rubik(
                            color: const Color(0xFF6688CA),
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.title_outlined,
                              color: Color(0xFF6688CA),
                            ),
                            label: Text(
                              'Title',
                              style: GoogleFonts.rubik(
                                color: const Color(0xFF6688CA),
                              ),
                            ),
                            hintText: 'Title',
                            hintStyle: GoogleFonts.rubik(
                              color: const Color(0xFF6688CA),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: descriptionController,
                          cursorColor: const Color(0xFF6688CA),
                          cursorWidth: 3,
                          maxLines: 4,
                          style: GoogleFonts.rubik(
                            color: const Color(0xFF6688CA),
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.description_outlined,
                              color: Color(0xFF6688CA),
                            ),
                            label: Text(
                              'Description',
                              style: GoogleFonts.rubik(
                                color: const Color(0xFF6688CA),
                              ),
                            ),
                            hintText: 'Description',
                            hintStyle: GoogleFonts.rubik(
                              color: const Color(0xFF6688CA),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            alignment: Alignment.center,
                            child: Text(
                              'Date: ',
                              style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              DateTimeRange? pickedDateRange = await showDateRangePicker(
                                context: context,
                                initialDateRange: DateTimeRange(
                                  start: dateTimeStart,
                                  end: dateTimeEnd,
                                ),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2030),
                                helpText: 'Select the date: ',
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      colorScheme: const ColorScheme(
                                        brightness: Brightness.light,
                                        primary: Color(0xFF6688CA),
                                        onPrimary: Colors.white,
                                        secondary: Color(0xFF6688CA),
                                        onSecondary: Colors.white,
                                        error: Color(0xFF6688CA),
                                        onError: Colors.white,
                                        surface: Colors.white,
                                        onSurface: Color(0xFF6688CA),
                                      ),
                                      textTheme: GoogleFonts.rubikTextTheme().copyWith(
                                        bodyMedium: GoogleFonts.rubik(
                                          fontSize: 16,
                                          color: const Color(0xFF6688CA),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (pickedDateRange != null) {
                                set(() {
                                  dateTimeStart = dateTimeStart.copyWith(
                                    day: pickedDateRange.start.day,
                                    month: pickedDateRange.start.month,
                                    year: pickedDateRange.start.year,
                                  );

                                  dateTimeEnd = dateTimeEnd.copyWith(
                                    day: pickedDateRange.end.day,
                                    month: pickedDateRange.end.month,
                                    year: pickedDateRange.end.year,
                                  );
                                });
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 170,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${DateFormat('dd MMM').format(dateTimeStart)} - ${DateFormat('dd MMM').format(dateTimeEnd)}',
                                style: GoogleFonts.rubik(
                                  color: const Color(0xFF6688CA),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              margin: const EdgeInsets.only(top: 20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              isLoading = true;
                              set(() {});

                              if (titleController.text.isEmpty) {
                                Utils().showToast(
                                    context: context,
                                    message: 'Please fill the title to add Leave Application');
                              } else if (descriptionController.text.isEmpty) {
                                Utils().showToast(
                                    context: context,
                                    message:
                                        'Please fill the description to add Leave Application');
                              } else {
                                if (isEdit) {
                                  if (leaveApplicationModel?.status == "waiting") {
                                    LeaveApplicationModel leaveApplication = LeaveApplicationModel(
                                      lid: lid,
                                      title: titleController.text,
                                      description: descriptionController.text,
                                      sid: UserSharedPreferences.id,
                                      startDate: dateTimeStart.toString(),
                                      endDate: dateTimeEnd.toString(),
                                      status: 'waiting',
                                    );

                                    await Provider.of<LeaveApplicationProvider>(context,
                                            listen: false)
                                        .updateLeaveApplication(
                                      context: context,
                                      leaveApplicationModel: leaveApplication,
                                    );
                                  }

                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                } else {
                                  LeaveApplicationModel leaveApplication = LeaveApplicationModel(
                                    lid: lid,
                                    title: titleController.text,
                                    description: descriptionController.text,
                                    sid: UserSharedPreferences.id,
                                    startDate: dateTimeStart.toString(),
                                    endDate: dateTimeEnd.toString(),
                                    status: 'waiting',
                                  );

                                  await Provider.of<LeaveApplicationProvider>(context,
                                          listen: false)
                                      .addLeaveApplication(
                                          context: context,
                                          leaveApplicationModel: leaveApplication);

                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                }
                              }

                              isLoading = false;
                              set(() {});
                            },
                            child: Container(
                              height: 40,
                              width: 150,
                              margin: const EdgeInsets.only(top: 20),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                isEdit ? 'Edit' : 'Add',
                                style: GoogleFonts.rubik(
                                  color: const Color(0xFF6688CA),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      });
    },
  );
}
