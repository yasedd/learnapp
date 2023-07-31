import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map rates;
  const DetailsPage({required this.rates});

  @override
  Widget build(BuildContext context) {
    List currencies = rates.keys.toList();
    List exchangeRates = rates.values.toList();
    print(currencies);
    print(rates);
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: currencies.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                "${currencies[index]} : ${exchangeRates[index]}",
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            );
          },
        ),
      ),
    );
  }
}
