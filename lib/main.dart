//Shrungi Katre
//BT19CSE132
//TAKE HOME ASSIGNMENT - 1

// Google drive link: https://drive.google.com/file/d/1X6ViEI5bH3qrmUypLcKsQy4H1Rwq2LXN/view?usp=sharing


import 'dart:math';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return themeBuild(
      defaultBrightness: Brightness.dark,
      builder: (context, _brightness) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Startup Name Generator',
          theme: ThemeData(primarySwatch: Colors.blue, brightness: _brightness),
          home: RandomWords(),
        );
      },
    );
  }
}

class themeBuild extends StatefulWidget {
  final Widget Function(BuildContext context, Brightness brightness) builder;
  final Brightness defaultBrightness;

  themeBuild({this.builder, this.defaultBrightness});
  @override
  _themeBuildState createState() => _themeBuildState();

  static _themeBuildState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<_themeBuildState>());
  }
}

class _themeBuildState extends State<themeBuild> {
  Brightness _brightness;
  @override
  void initState() {
    super.initState();
    _brightness = widget.defaultBrightness;

    if (mounted) setState(() {});
  }

  void changeTheme() {
    setState(() {
      _brightness =
          _brightness == Brightness.dark ? Brightness.light : Brightness.dark;
    });
  }

  Brightness getCurrentTheme() {
    return _brightness;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _brightness);
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  int _theme = 0;
  final List<WordPair> _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  void _changeTheme() {
    themeBuild.of(context).changeTheme();
    setState(() {
      _theme++;
    });
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final tiles = _saved.map(
        (WordPair pair) {
          return ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        },
      );
      final divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text('Saved Suggestions'),
        ),
        body: ListView(
          children: divided,
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*floatingActionButton: FloatingActionButton.extended(
        onPressed: _changeTheme,
        label: Text('Switch Theme'),
        icon: Icon(Icons.brightness_high),
      ),
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),*/
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: FloatingActionButton.extended(
              heroTag: 'brightness_high',
              onPressed: _changeTheme,
              /*onPressed: () {
                currentTheme.switchTheme();
              },*/
              label: Text('Switch Theme'),
              icon: Icon(Icons.brightness_high),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            left: 50.0,
            child: FloatingActionButton(
              heroTag: 'next',
              onPressed: () {
                List<String> myList = List<String>(4);;
                int length = _saved.length;
                if(length != 4)
                {
                  showAlertDialog(context); //
                }
                else
                {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondRoute(save : _saved)),
                  );
                }
              },
              child: Icon(Icons.arrow_forward_sharp),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
    
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return Divider();
          }

          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { Navigator.pop(context);},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Attention !!!"),
      content: Text("Please select exactly 4 favourites"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

/*class RandomWords extends StatefulWidget {
  @override
  State<RandomWords> createState() => _RandomWordsState();
}*/

class SecondRoute extends StatelessWidget  {
  final Set <WordPair> save ;
  SecondRoute({this.save});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flipping Tiles',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[900],
          title: Center(
            child: Text(
              'Flutter GridView',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        body: Column(children: <Widget>[
          Row(
            //ROW 1
            children: [
              getContainer1(),
              getContainer2(),
            ],
          ),
          Row(//ROW 2
              children: [
            getContainer3(),
            getContainer4(),
          ]),
          Container(
              child: FloatingActionButton(
              heroTag: 'next',
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_rounded),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
          ),
            
        ]),
      ),
    );
  }

  Widget getContainer1() {
    return Container(
      height: 200,
      width: 200,
      //color: Colors.blue,
      margin: EdgeInsets.all(25.0),
      //color: Colors.blue,

      child: WidgetFlipper(
              frontWidget: Container(
                color: Colors.green[200],
                child: Center(
                  child: Text(
                    save.elementAt(0).toString(),
                  ),
                ),
              ),

              backWidget: Container(
                color: Colors.grey[200],
                child: new Image.asset('assets/im1.jpg'),
                //alignment: Alignment.center,
                ),
              ),
      );

    
  }

  Widget getContainer2() {
    return Container(
      height: 200,
      width: 200,
      //color: Colors.blue,
      margin: EdgeInsets.all(25.0),
      //color: Colors.blue,

      child: WidgetFlipper(
              frontWidget: Container(
                color: Colors.green[200],
                child: Center(
                  child: Text(
                    save.elementAt(1).toString(),
                  ),
                ),
              ),

              backWidget: Container(
                color: Colors.grey[200],
                child: new Image.asset('assets/im2.jpg'),
                alignment: Alignment.center,
                ),
              ),
      

    );
  }

  Widget getContainer3() {
    return Container(
      height: 200,
      width: 200,
      //color: Colors.blue,
      margin: EdgeInsets.all(25.0),
      //color: Colors.blue,

      child: WidgetFlipper(
              frontWidget: Container(
                color: Colors.green[200],
                child: Center(
                  child: Text(
                    save.elementAt(2).toString(),
                  ),
                ),
              ),

              backWidget: Container(
                color: Colors.grey[200],
                child: new Image.asset('assets/im3.jpg'),
                alignment: Alignment.center,
                ),
              ),
      

    );
  }

  Widget getContainer4() {
    return Container(
      height: 200,
      width: 200,
      //color: Colors.blue,
      margin: EdgeInsets.all(25.0),
      //color: Colors.blue,
      
      child: WidgetFlipper(
              frontWidget: Container(
                color: Colors.green[200],
                child: Center(
                  child: Text(
                    save.elementAt(3).toString(),
                  ),
                ),
              ),

              backWidget: Container(
                color: Colors.grey[200],
                child: new Image.asset('assets/im4.jpg'),
                alignment: Alignment.center,
                ),
              ),
      

    );
  }
}



class WidgetFlipper extends StatefulWidget {
  WidgetFlipper({
    Key key,
    this.frontWidget,
    this.backWidget,
  }) : super(key: key);

  final Widget frontWidget;
  final Widget backWidget;

  @override
  _WidgetFlipperState createState() => _WidgetFlipperState();
}

class _WidgetFlipperState extends State<WidgetFlipper> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> _frontRotation;
  Animation<double> _backRotation;
  bool isFrontVisible = true;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _frontRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: pi / 2).chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
    _backRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: -pi / 2, end: 0.0).chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedCard(
          animation: _backRotation,
          child: widget.backWidget,
        ),
        AnimatedCard(
          animation: _frontRotation,
          child: widget.frontWidget,
        ),
        _tapDetectionControls(),
      ],
    );
  }

  Widget _tapDetectionControls() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        GestureDetector(
          onTap: _leftRotation,
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topLeft,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        GestureDetector(
          onTap: _rightRotation,
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topRight,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  void _leftRotation() {
    _toggleSide();
  }

  void _rightRotation() {
    _toggleSide();
  }

  void _toggleSide() {
    if (isFrontVisible) {
      controller.forward();
      isFrontVisible = false;
    } else {
      controller.reverse();
      isFrontVisible = true;
    }
  }
}

class AnimatedCard extends StatelessWidget {
  AnimatedCard({
    this.child,
    this.animation,
  });

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        var transform = Matrix4.identity();
        transform.setEntry(3, 2, 0.001);
        transform.rotateY(animation.value);
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }
}