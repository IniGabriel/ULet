import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ulet_1/pages/history_page/history_page.dart';
import 'package:ulet_1/pages/transfer_page/add_number_page.dart';
import 'package:ulet_1/top_up/top_up.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Content
          Column(
            children: [
              Container(
                width: double.infinity,
                height: screenHeight * 0.38,
                color: Color(0xFFA41724),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Text(
                        'UserName',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                        ),
                      ),
                      Text(
                        'Rp. xxx.xxx.xxx',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: screenWidth * 0.36,
                            padding: EdgeInsets.symmetric(
                                horizontal: 7.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30.0),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddNumberPage()),
                                  );
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.string(
                                      '''<svg width="31" height="31" viewBox="0 0 31 31" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M15.5 5.16659C21.1975 5.16659 25.8333 9.80238 25.8333 15.4999C25.8333 21.1975 21.1975 25.8333 15.5 25.8333C9.80244 25.8333 5.16665 21.1975 5.16665 15.4999C5.16665 9.80238 9.80244 5.16659 15.5 5.16659ZM15.5 2.58325C8.3661 2.58325 2.58331 8.36604 2.58331 15.4999C2.58331 22.6338 8.3661 28.4166 15.5 28.4166C22.6339 28.4166 28.4166 22.6338 28.4166 15.4999C28.4166 8.36604 22.6339 2.58325 15.5 2.58325ZM21.9583 14.2083H16.7916V9.04158H14.2083V14.2083H9.04165V16.7916H14.2083V21.9583H16.7916V16.7916H21.9583V14.2083Z" fill="#0B0B0B"/></svg>''',
                                      width: 31,
                                      height: 31,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Add Number',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: screenWidth * 0.36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30.0),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HistoryPage()),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14.0, vertical: 10.0),
                                  child: Row(
                                    children: [
                                      SvgPicture.string(
                                        '''<svg width="31" height="26" viewBox="0 0 31 26" fill="none" xmlns="http://www.w3.org/2000/svg">
                                        <path d="M17.4167 0.25C14.0352 0.25 10.7922 1.5933 8.40107 3.98439C6.00999 6.37548 4.66669 9.61849 4.66669 13H0.416687L5.92752 18.5108L6.02669 18.7092L11.75 13H7.50002C7.50002 7.5175 11.9342 3.08333 17.4167 3.08333C22.8992 3.08333 27.3334 7.5175 27.3334 13C27.3334 18.4825 22.8992 22.9167 17.4167 22.9167C14.6825 22.9167 12.2034 21.7975 10.4184 19.9983L8.40669 22.01C9.58736 23.1972 10.9914 24.1389 12.5378 24.7808C14.0842 25.4227 15.7424 25.7521 17.4167 25.75C20.7982 25.75 24.0412 24.4067 26.4323 22.0156C28.8234 19.6245 30.1667 16.3815 30.1667 13C30.1667 9.61849 28.8234 6.37548 26.4323 3.98439C24.0412 1.5933 20.7982 0.25 17.4167 0.25ZM16 7.33333V14.4167L22.0209 17.9867L23.1117 16.1592L18.125 13.1983V7.33333H16Z" fill="black"/>
                                        </svg>
                                        ''',
                                        width: 28,
                                        height: 28,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'History',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: screenWidth * 0.36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30.0),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TopUp()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 10.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.atm_rounded,
                                    color: Colors.black,
                                    size: 35.0,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Top Up',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
