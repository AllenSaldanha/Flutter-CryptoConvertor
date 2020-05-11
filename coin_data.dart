import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const kURL = 'https://rest.coinapi.io/v1/exchangerate';
const kapiKEY = '51CD7005-5106-43D5-AEE0-89477FCBE849';
// ('$kURL/BTC/USD?apikey=$kapiKEY')


const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];


class CoinData {
  Future getPrice(selectedCurrency)async{
    final priceCrypto=[];
    for(String Crypto in cryptoList){
      String url = '$kURL/$Crypto/$selectedCurrency?apikey=$kapiKEY';
      http.Response response = await http.get(url);
      if(response.statusCode==200){
        var decodedData=jsonDecode(response.body);
        double price=decodedData['rate'];
        priceCrypto.add(price.round());
      }
      else{
        print(response.statusCode);
        throw 'problem with the get request';
      }
    }
    return priceCrypto;
  }
}

//
//void main()async{
//  CoinData coinData =  CoinData();
//  List price= await coinData.getPrice('USD');
//  print(price);
//}