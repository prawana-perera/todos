import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          alignment: Alignment.center,
          // width: 192.0,
          // height: 96,
          padding: EdgeInsets.only(top: 30.0, left: 10.0),
          color: Colors.grey,
          // margin: EdgeInsets.all(50.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    "Margherita",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        fontSize: 30.0,
                        decoration: TextDecoration.none,
                        fontFamily: 'Oxygen',
                        fontWeight: FontWeight.normal),
                  )),
                  Expanded(
                      child: Text(
                    "Tomatoe, Mozzarella, Basil",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        fontSize: 20.0,
                        decoration: TextDecoration.none,
                        fontFamily: 'Oxygen',
                        fontWeight: FontWeight.normal),
                  ))
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    "Margherita",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        fontSize: 30.0,
                        decoration: TextDecoration.none,
                        fontFamily: 'Oxygen',
                        fontWeight: FontWeight.normal),
                  )),
                  Expanded(
                      child: Text(
                    "Tomatoe, Mozzarella, Basil",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        fontSize: 20.0,
                        decoration: TextDecoration.none,
                        fontFamily: 'Oxygen',
                        fontWeight: FontWeight.normal),
                  ))
                ],
              ),
              HomeImageWidget(),
              HomeDemoButton()
            ],
          )),
    );
  }
}

class HomeImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('images/lion.png');
    Image image = Image(image: assetImage, width: 400, height: 400);

    return Container(child: image);
  }
}

class HomeDemoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var button = Container(
      margin: EdgeInsets.only(top: 50.0),
      child: ElevatedButton(
        child: Text('Order your pizza'),
        onPressed: () {
          order(context);
        },
      ),
    );

    return button;
  }

  void order(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text('Ordered'),
      content: Text('Thanks for your order'),
    );

    showDialog(context: context, builder: (BuildContext context) => alert);
  }
}
