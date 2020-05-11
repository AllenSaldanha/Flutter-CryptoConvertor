import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;//only shows the platform class of the dart_io package

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  //For Android
  DropdownButton<String> androidDropdown(){
    List<DropdownMenuItem<String>> dropdownItems=[];
    for(int i=0;i<currenciesList.length;i++){
      String currency = currenciesList[i];
      var newItem=DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton <String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value){
        setState(() {
          print(value);
          selectedCurrency=value;
          getData();
        });
      },
    );
  }
  //For iOS
  CupertinoPicker iOSPicker(){
    List<Widget> pickerItems=[];
    for(String cur in currenciesList){
      pickerItems.add(Text(cur));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex){
        setState(() {
          selectedCurrency=currenciesList[selectedIndex];
          getData();
        });},
      children: pickerItems
    );
  }


  List priceList = [];
  bool isWaiting = false;

  void getData()async{
    isWaiting=true;
    try{
      List price = await CoinData().getPrice(selectedCurrency);
      setState(() {
        priceList=price;
        isWaiting=false;
      });}
    catch(e){
      print(e);
    }
  }

  @override
  void initState(){
    super.initState();
    getData();
  }

  Column makeCards(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        CurrencyCard(from:'BTC',to:selectedCurrency,value: isWaiting?'?':priceList[0]),
        CurrencyCard(from:'ETH',to:selectedCurrency,value: isWaiting?'?':priceList[1]),
        CurrencyCard(from:'LTC',to:selectedCurrency,value: isWaiting?'?':priceList[2]),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('🤑 Coin Ticker'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            makeCards(),
            Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS?iOSPicker():androidDropdown(),//Platform.isIOS?iOSPicker():androidDropdown,
            )
          ],
        ),
      );
  }
}

class CurrencyCard extends StatelessWidget {
  final String from;
  final String to;
  final value;
  CurrencyCard({this.to,this.from,this.value});
  @override
  Widget build(BuildContext context)  {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 28.0),
          child: Text (
            '1 $from = $value $to',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}