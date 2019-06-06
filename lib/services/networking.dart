import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

const String bitcoingAvgURL =
    'https://apiv2.bitcoinaverage.com/indices/global/ticker/';

class NetworkingServices {

  static dynamic getConversionPriceFor({@required String coinType, @required String currencyLabel}) async {
    http.Response response = await http.get(bitcoingAvgURL + '$coinType$currencyLabel');

    if(response.statusCode != 200) throw Exception('Coudln\'t fetch the data from remote servers.');

    return jsonDecode(response.body)['last'];
  }
}
