import 'package:flutter/material.dart';
import 'package:movies_app_flutter/components/calendar_day.dart';
import 'package:movies_app_flutter/components/cienma_seat.dart';
import 'package:movies_app_flutter/components/show_time.dart';
import 'package:movies_app_flutter/utils/constants.dart';

class BuyTicket extends StatelessWidget {
  final title;

  const BuyTicket(this.title, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAppBarColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: .0, left: .0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 24,
                      height: MediaQuery.of(context).size.width / 24,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: SizedBox(
                  child: Text(
                    title,
                    style: kTitleTicketsTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  width: MediaQuery.of(context).size.width * 1.0,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25.0),
                      topLeft: Radius.circular(25.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 5.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: const <Widget>[
                          CalendarDay(
                            dayNumber: '9',
                            dayAbbreviation: 'TH',
                          ),
                          CalendarDay(
                            dayNumber: '10',
                            dayAbbreviation: 'FR',
                          ),
                          CalendarDay(
                            dayNumber: '11',
                            dayAbbreviation: 'SA',
                          ),
                          CalendarDay(
                            dayNumber: '12',
                            dayAbbreviation: 'SU',
                            isActive: true,
                          ),
                          CalendarDay(
                            dayNumber: '13',
                            dayAbbreviation: 'MO',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      ShowTime(
                        time: '11:00',
                        price: 5,
                        isActive: false,
                      ),
                      ShowTime(
                        time: '12:30',
                        price: 10,
                        isActive: true,
                      ),
                      ShowTime(
                        time: '12:30',
                        price: 10,
                        isActive: false,
                      ),
                      ShowTime(
                        time: '12:30',
                        price: 10,
                        isActive: false,
                      ),
                      ShowTime(
                        time: '12:30',
                        price: 10,
                        isActive: false,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Icon(
                      Icons.tv,
                      color: kPrimaryColor,
                      size: 25.0,
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Vox Cinema', style: kDrawerDescTextStyle),
                          const Text('Mall of Egypt, 6th of October',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white30, fontSize: 18.0)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    const Icon(
                      Icons.keyboard_arrow_right,
                      size: 30.0,
                      color: Colors.white38,
                    )
                  ],
                ),
              ),
              Center(child: Image.asset('images/screen.png')),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // First Seat Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 20),
                        ),
                        CienmaSeat(),
                        CienmaSeat(),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 20),
                        ),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 20) * 2,
                        ),
                        CienmaSeat(),
                        CienmaSeat(),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 20),
                        ),
                      ],
                    ),
                    // Second Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 20),
                        ),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 20) * 2,
                        ),
                        CienmaSeat(
                          isReserved: true,
                        ),
                        CienmaSeat(),
                        CienmaSeat(),
                      ],
                    ),
                    // Third  Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 20),
                        ),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 20) * 2,
                        ),
                        CienmaSeat(),
                        CienmaSeat(
                          isReserved: true,
                        ),
                        CienmaSeat(
                          isReserved: true,
                        ),
                      ],
                    ),
                    // 4TH Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 20),
                        ),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 20) * 2,
                        ),
                        CienmaSeat(
                          isReserved: true,
                        ),
                        CienmaSeat(),
                        CienmaSeat(),
                      ],
                    ),
                    // 5TH Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 20),
                        ),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 20) * 2,
                        ),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                      ],
                    ),
                    // 6TH Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 20),
                        ),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 20) * 2,
                        ),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                      ],
                    ),
                    // final Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                        CienmaSeat(),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Text(
                      '30\$',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 10.0),
                    decoration: const BoxDecoration(
                        color: kActionColor,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(25.0))),
                    child: const InkWell(
                        child: Text('Pay',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold))),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
