import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'coin_data.dart';
import 'components/conversion_card.dart';
import 'services/networking.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String _selectedCurrency = 'USD';
  String _conversionPriceForBTC;
  String _conversionPriceForETH;
  String _conversionPriceForLTC;

  Widget centerScreenWidgets;

  DropdownButton _getAndroidDropdownButton() {
    List<DropdownMenuItem<String>> dropdownMenuList = [];
    for (String currencyName in currenciesList) {
      dropdownMenuList.add(
        DropdownMenuItem(
          child: Text(
            currencyName,
            textAlign: TextAlign.center,
          ),
          value: currencyName,
        ),
      );
    }

    return DropdownButton<String>(
      isExpanded: true,
      value: _selectedCurrency,
      items: dropdownMenuList,
      onChanged: (value) {
        setState(
          () {
            _selectedCurrency = value;
            _updateConversionPrice();
          },
        );
      },
    );
  }

  CupertinoPicker _getCupertinoPicker() {
    List<Text> pickerMenuList = [];

    for (String currencyName in currenciesList) {
      pickerMenuList.add(Text(currencyName));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      children: pickerMenuList,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
    );
  }

  Expanded _buildLoadingWidget() {
    return Expanded(
      child: Center(
        child: SpinKitDoubleBounce(color: Colors.grey, size: 100.0),
      ),
    );
  }

  Column _buildConversionCardColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <ConversionCard>[
        ConversionCard(
          coinType: 'USD',
          conversionPrice: _conversionPriceForBTC,
          selectedCurrency: _selectedCurrency,
        ),
        ConversionCard(
          coinType: 'ETH',
          conversionPrice: _conversionPriceForETH,
          selectedCurrency: _selectedCurrency,
        ),
        ConversionCard(
          coinType: 'LTC',
          conversionPrice: _conversionPriceForLTC,
          selectedCurrency: _selectedCurrency,
        )
      ],
    );
  }

  void _updateConversionPrice() async {
    setState(() {
      centerScreenWidgets = _buildLoadingWidget();
    });

    double conversionPriceForBTC = await NetworkingServices(coinType: 'BTC')
        .getConversionPriceFor(_selectedCurrency);

    double conversionPriceForETH = await NetworkingServices(coinType: 'ETH')
        .getConversionPriceFor(_selectedCurrency);

    double conversionPriceForLTC = await NetworkingServices(coinType: 'LTC')
        .getConversionPriceFor(_selectedCurrency);

    setState(() {
      _conversionPriceForBTC = conversionPriceForBTC.toStringAsFixed(2);
      _conversionPriceForETH = conversionPriceForETH.toStringAsFixed(2);
      _conversionPriceForLTC = conversionPriceForLTC.toStringAsFixed(2);

      centerScreenWidgets = _buildConversionCardColumn();
    });
  }

  @override
  void initState() {
    super.initState();
    _updateConversionPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          centerScreenWidgets,
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.all(30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS
                ? _getCupertinoPicker()
                : _getAndroidDropdownButton(),
          ),
        ],
      ),
    );
  }
}
