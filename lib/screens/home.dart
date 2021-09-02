import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle =
        theme.textTheme.headline3!.copyWith(color: Colors.white70);
    final TextStyle dateStyle = theme.textTheme.headline6!
        .copyWith(color: Colors.white70, fontSize: 15);
    final df = DateFormat('E MMMM d, y');

    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 184,
            child: Stack(
              children: [
                Positioned.fill(
                  // In order to have the ink splash appear above the image, you
                  // must use Ink.image. This allows the image to be painted as part
                  // of the Material and display ink effects above it. Using a
                  // standard Image will obscure the ink splash.
                  child: Ink.image(
                    image: AssetImage('assets/images/landscape.jpeg'),
                    fit: BoxFit.cover,
                    child: Container(),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 4.0,
                                        color: Colors.blueAccent
                                            .withOpacity(0.7)))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        debugPrint('pressed back');
                                      },
                                    )),
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text('My Todos', style: titleStyle),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, top: 20),
                                  child: Text(df.format(DateTime.now()),
                                      style: dateStyle),
                                ),
                              ],
                            )),
                        flex: 2,
                      ),
                      Expanded(
                          child: Container(
                        constraints: BoxConstraints.expand(),
                        color: Colors.black.withOpacity(0.2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('Stats', style: titleStyle)],
                        ),
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            color: Colors.white24,
            child: ListView(
              children: [
                _tile('CineArts at the Empire', '85 W Portal Ave', Icons.map),
                _tile('The Castro Theater', '429 Castro St', Icons.theaters),
                _tile(
                    'Alamo Drafthouse Cinema', '2550 Mission St', Icons.group),
                _tile('Roxie Theater', '3117 16th St', Icons.accessible),
                _tile('United Artists Stonestown Twin', '501 Buckingham Way',
                    Icons.theaters),
                _tile('AMC Metreon 16', '135 4th St #3000', Icons.add_alarm),
                _tile('K\'s Kitchen', '757 Monterey Blvd', Icons.restaurant),
                _tile('Emmy\'s Restaurant', '1923 Ocean Ave', Icons.wb_cloudy),
                _tile('Chaiya Thai Restaurant', '272 Claremont Blvd',
                    Icons.water_sharp),
                _tile('La Ciccia', '291 30th St', Icons.restaurant),
              ],
            ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Add New');
        },
        tooltip: 'Add new Todo',
        child: new Icon(Icons.add),
      ),
    );
  }

  ListTile _tile(String title, String subtitle, IconData icon) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle),
      leading: Icon(
        icon,
        color: Colors.blue[500],
      ),
    );
  }
}
