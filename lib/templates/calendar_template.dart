import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widget/calendar.dart';
import '../widget/eventList.dart';
import '../widget/workTypeMenu.dart';

class CalendarTemplate extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Calendar(),
          SizedBox(height: 15),
          EventList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          _openWorkTypeModal(context);
        },
        child: Icon(Icons.create, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _openWorkTypeModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          height: MediaQuery.of(context).size.height,
          color: Color(0xFF737373),
          child: Container(
            child: WorkTypeMenu(),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(30),
                topRight: const Radius.circular(30),
              ),
            ),
          ),
        );
      }
    );
  }
}
