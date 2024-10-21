import 'package:flutter/material.dart';
import 'package:pbl_op/widgets/sort.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget dashboard = Container(
      color: const Color.fromARGB(255, 241, 244, 249),
      padding: const EdgeInsets.only(left: 35, right: 35, bottom: 20, top: 55),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Hello!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Color(0xFFc8cad1)),
              ),
              Text(
                "My Dashboard",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 16),
              )
            ],
          ),
          Icon(
            Icons.notification_add_outlined,
            size: 30,
          )
        ],
      ),
    );

    Widget faces = Container(
      color: const Color.fromARGB(255, 241, 244, 249),
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Container(
              height: 90,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.only(
                  left: 14, right: 14, top: 10, bottom: 10),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 20,
                        color: Colors.white,
                      ),
                      Text(
                        " Recognized",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "50",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontWeight: FontWeight.w900,
                            height: 0.9),
                      ),
                      Text(
                        " Faces",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              height: 90,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.only(
                  left: 13, right: 13, top: 10, bottom: 10),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 20,
                        color: Colors.white,
                      ),
                      Text(
                        " Unrecognized",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "22",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontWeight: FontWeight.w900,
                            height: 0.9),
                      ),
                      Text(
                        " Faces",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Widget activity = Container(
      color: const Color.fromARGB(255, 241, 244, 249),
      padding: const EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black,
        ),
        padding: const EdgeInsets.all(15),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "  Log Activity",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1),
                ),
                Icon(
                  Icons.date_range_outlined,
                  color: Colors.white,
                  size: 25,
                )
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.account_circle_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                Padding(padding: EdgeInsets.only(left: 10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Olivia Martin",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "25 June 2024, 08:00",
                      style: TextStyle(
                          color: Colors.white54,
                          letterSpacing: 1.0,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.account_circle_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                Padding(padding: EdgeInsets.only(left: 10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Olivia Martin",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "25 June 2024, 08:00",
                      style: TextStyle(
                          color: Colors.white54,
                          letterSpacing: 1.0,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.account_circle_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                Padding(padding: EdgeInsets.only(left: 10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Olivia Martin",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "25 June 2024, 08:00",
                      style: TextStyle(
                          color: Colors.white54,
                          letterSpacing: 1.0,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.account_circle_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                Padding(padding: EdgeInsets.only(left: 10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Olivia Martin",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "25 June 2024, 08:00",
                      style: TextStyle(
                          color: Colors.white54,
                          letterSpacing: 1.0,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );

    return Column(
      children: [
        Expanded(
          flex: 12,
          child: dashboard,
        ),
        Expanded(
          flex: 11,
          child: faces,
        ),
        const Expanded(
          flex: 26,
          child: MySort(
            texts: ['Today', 'Week', 'Month', 'Year'],
            selectedIndex: 0,
          ),
        ),
        Expanded(
          flex: 27,
          child: activity,
        ),
      ],
    );
  }
}
