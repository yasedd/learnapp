// ignore_for_file: unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:learnapp/pages/details_page.dart';
import 'package:learnapp/services/http_service.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  double? _deviceHight, _deviceWidth;
  HTTPService? http;
  String? selectedcoin = 'bitcoin';
  @override
  void initState() {
    super.initState();
    http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _selectedCoinDropDown(),
                _dataWidgets(),
              ]),
        ),
      ),
    );
  }

  Widget _selectedCoinDropDown() {
    List<String> _coins = ['bitcoin', 'ethereum', 'tether', 'binancecoin'];
    List<DropdownMenuItem> _items = _coins
        .map((e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w600),
            )))
        .toList();

    return DropdownButton(
      value: selectedcoin,
      items: _items,
      onChanged: (_value) {
        setState(() {
          print(selectedcoin);
          selectedcoin = _value;
          print(selectedcoin);
        });
      },
      dropdownColor: Colors.purple[900],
      iconSize: 30,
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  Widget _dataWidgets() {
    return FutureBuilder(
      future: http!.get("/coins/$selectedcoin"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map data = jsonDecode(snapshot.data.toString());
          num usdPrice = data["market_data"]["current_price"]["usd"];
          num change24h = data["market_data"]["price_change_percentage_24h"];
          Map exchangeRate = data["market_data"]["current_price"];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext _context) {
                      return DetailsPage(rates: exchangeRate);
                    }));
                  },
                  child: coinImageWidget(data["image"]["large"])),
              currentPrice(usdPrice),
              percentageChangeWidget(change24h),
              coinDescription(data["description"]["en"])
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget currentPrice(num rate) {
    return Text(
      "${rate.toStringAsFixed(2)} USD",
      style: const TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
    );
  }

  Widget percentageChangeWidget(num change) {
    return Text(
      "${change.toString()} %",
      style: const TextStyle(
          color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),
    );
  }

  Widget coinImageWidget(String imgURL) {
    return Container(
      height: _deviceHight! * 0.15,
      width: _deviceWidth! * 0.15,
      padding: EdgeInsets.symmetric(vertical: _deviceHight! * 0.02),
      decoration:
          BoxDecoration(image: DecorationImage(image: NetworkImage(imgURL))),
    );
  }

  Widget coinDescription(String desc) {
    return Container(
      height: _deviceHight! * 0.515,
      width: _deviceWidth! * 0.90,
      margin: EdgeInsets.symmetric(vertical: _deviceHight! * 0.05),
      padding: EdgeInsets.symmetric(
          vertical: _deviceHight! * 0.01, horizontal: _deviceWidth! * 0.02),
      color: Colors.purple[800],
      child: Text(
        desc,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
