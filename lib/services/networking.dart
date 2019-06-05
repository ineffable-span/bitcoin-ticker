import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

const String bitcoingAvgURL =
    'https://apiv2.bitcoinaverage.com/indices/global/ticker/';

class NetworkingServices {
  final String coinType;

  NetworkingServices({@required this.coinType});

  dynamic getConversionPriceFor(String currencyLabel) async {
    http.Response response = await http.get(bitcoingAvgURL + '$coinType$currencyLabel');

    return jsonDecode(response.body)['last'];
  }
}
