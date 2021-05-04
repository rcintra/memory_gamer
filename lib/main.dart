import 'package:flutter/material.dart';
import 'package:memory_gamer/data/data.dart';

import 'model/tile_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memory Gamer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TileModel> gridViewTiles = [];
  List<TileModel> questionPairs = [];

  @override
  void initState() {
    super.initState();
    reStart();
  }

  void reStart() {
    pairs = getPairs();
    pairs.shuffle();

    gridViewTiles = pairs;

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        print("2 seconds done");
        questionPairs = getQuestions();
        gridViewTiles = questionPairs;
        selected = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            points != 800
                ? Column(
                    children: [
                      Text(
                        "$points/800",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                      Text("Pontos"),
                    ],
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),
            points != 800
                ? GridView(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisSpacing: 0.0,
                      maxCrossAxisExtent: 100,
                    ),
                    children: List.generate(gridViewTiles.length, (index) {
                      return Tile(
                        imageAssetPath:
                            gridViewTiles[index].getImageAssetPath(),
                        parent: this,
                        tileIndex: index,
                      );
                    }))
                : Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              points = 0;
                              reStart();
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 200,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Text(
                              "Replay",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class Tile extends StatefulWidget {
  String imageAssetPath;
  int tileIndex;

  _HomePageState parent;

  Tile({this.imageAssetPath, this.parent, this.tileIndex});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!selected) {
          setState(() {
            pairs[widget.tileIndex].setIsSelected(true);
          });
          if (selectedImageAssetPath != "") {
            if (selectedImageAssetPath ==
                pairs[widget.tileIndex].getImageAssetPath()) {
              //correct
              print("add point");
              points = points + 100;
              print(selectedTileIndex);
              print(widget.imageAssetPath);

              TileModel tileModel = new TileModel();
              print(widget.tileIndex);
              selected = true;

              Future.delayed(const Duration(seconds: 2), () {
                tileModel.setImageAssetPath("assets/correct.png");
                pairs[widget.tileIndex] = tileModel;
                print(selectedTileIndex);
                pairs[selectedTileIndex] = tileModel;
                widget.parent.setState(() {
                  pairs[widget.tileIndex].setImageAssetPath("");
                  pairs[selectedTileIndex].setImageAssetPath("");
                });
                setState(() {
                  selected = false;
                });
                selectedImageAssetPath = "";
              });
            } else {
              // wrong choise
              print("wrong choice");
              selected = true;
              Future.delayed(const Duration(seconds: 2), () {
                this.widget.parent.setState(() {
                  pairs[widget.tileIndex].setIsSelected(false);
                  pairs[selectedTileIndex].setIsSelected(false);
                });
                setState(() {
                  selected = false;
                });
              });
              selectedImageAssetPath = "";
            }
          } else {
            selectedTileIndex = widget.tileIndex;
            selectedImageAssetPath =
                pairs[widget.tileIndex].getImageAssetPath();
          }
          setState(() {
            pairs[widget.tileIndex].setIsSelected(true);
          });
          print("You clicked me");
        }
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: pairs[widget.tileIndex].getImageAssetPath() != ""
            ? Image.asset(pairs[widget.tileIndex].getIsSelected()
                ? pairs[widget.tileIndex].getImageAssetPath()
                : widget.imageAssetPath)
            : Image.asset("assets/correct.png"),
      ),
    );
  }
}
