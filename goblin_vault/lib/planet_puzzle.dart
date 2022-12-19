import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';

class PlanetPuzzle extends StatefulWidget {
  const PlanetPuzzle({super.key, required this.validator});

  final Function validator;

  @override
  State<PlanetPuzzle> createState() => _PlanetPuzzleState();
}

class _PlanetPuzzleState extends State<PlanetPuzzle> {
  double distance = 10;
  bool isSolved = false;
  final List<SolarPuzzlePiece> pieces = List.generate(
      12,
      (index) => SolarPuzzlePiece(AssetImage('assets/images/pp$index.jpg'),
          index: index))
    ..shuffle();

  bool checkSolved() {
    for (var i = 0; i < pieces.length; i++) {
      if (i != pieces[i].index) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return buildPuzzle();
  }

  Widget buildPuzzle() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(child: gridBuilder()));
  }

  Widget gridBuilder() {
    return DraggableGridViewBuilder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: distance,
        crossAxisSpacing: distance,
        // childAspectRatio: MediaQuery.of(context).size.width /
        //     (MediaQuery.of(context).size.height / 3),
      ),
      shrinkWrap: true,
      children: listBuilder(),
      isOnlyLongPress: false,
      dragCompletion:
          (List<DraggableGridItem> list, int beforeIndex, int afterIndex) {
        swap(beforeIndex, afterIndex);
        if (!isSolved && checkSolved()) {
          setState(() {
            isSolved = true;
          });
        }
        if (isSolved) validateClue(true);
      },
      dragFeedback: (List<DraggableGridItem> list, int index) {
        return Container(
          width: 200,
          height: 150,
          child: list[index].child,
        );
      },
      dragPlaceHolder: (List<DraggableGridItem> list, int index) {
        return PlaceHolderWidget(
          child: Container(
            color: Colors.white,
          ),
        );
      },
    );
  }

  List<DraggableGridItem> listBuilder() {
    List<DraggableGridItem> puzzlePieces = [];
    for (var i = 0; i < pieces.length; i++) {
      puzzlePieces.add(makePiece(i));
    }
    return puzzlePieces;
  }

  DraggableGridItem makePiece(int gridIndex) {
    SolarPuzzlePiece piece = pieces[gridIndex];
    return DraggableGridItem(
        isDraggable: true,
        child: Image(
          image: piece.image!,
        ));
  }

  swap(int idx1, int idx2) {
    var temp = pieces[idx1];
    pieces[idx1] = pieces[idx2];
    pieces[idx2] = temp;
  }

  validateClue(dynamic password) {
    var isSolved = widget.validator(password);
    if (isSolved) {
      Navigator.of(context).pop();
    }
  }
}

class SolarPuzzlePiece {
  const SolarPuzzlePiece(this.image, {required this.index, required this.name});

  final int index;
  final String name;
  final AssetImage? image;
}
