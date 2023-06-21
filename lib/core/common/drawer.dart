import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomNavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [buildHeader(context), buildMenuItems(context)],
          ),
        ),
      );
  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.only(left: 29, right: 16),
        child: Column(children: [
          Column(
            children: [
              ListTile(
                title: Text(
                  "Home Page",
                  style: GoogleFonts.rubik(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                title: Text(
                  "Attendance History",
                  style: GoogleFonts.rubik(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                title: GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Settings",
                    style: GoogleFonts.rubik(
                        fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width / 1.3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(
                width: 55,
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.share),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Share Up",
                        style: GoogleFonts.rubik(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.logout),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Log Out",
                        style: GoogleFonts.rubik(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ],
          )
        ]),
      );

  Widget buildHeader(BuildContext context) => Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: 80,
                    width: 80,
                    color: Colors.transparent,
                    child: const Icon(Icons.cancel)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                "assets/images/svg/hegati_logo_final.png",
                height: 102,
                width: 84,
              )
            ],
          ),
        ],
      );
}
