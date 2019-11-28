import 'package:flutter/material.dart';
import 'package:infobootleg/helpers/DB.dart';
import 'package:provider/provider.dart';

import 'helpers/Law.dart';
import 'helpers/state_model.dart';

class Searchbox extends StatelessWidget {
  final TextEditingController myController = TextEditingController();

  String leftPad(userInput) {
    while (userInput.length < 5) {
      userInput = "0" + userInput;
    }
    return userInput;
  }

  @override
  Widget build(BuildContext context) {
    final _myPageController = Provider.of<PageController>(context);

    return Container(
      width: 200,
      alignment: Alignment.center,
      child: Consumer<StateModel>(
        builder: (context, stateModel, child) {
          return TextField(
            controller: myController,
            onSubmitted: (userInput) async {
              Law law;
              try {
                law = await DB.retrieveLaw(leftPad(userInput));
              } catch (e) {}
              // tell user no law found!
              stateModel.setCurrentLaw(law);
              _myPageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOutQuint,
              );
            },
            style: TextStyle(
              fontSize: 20,
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Ley número...',
              prefixIcon: Icon(
                Icons.search,
                size: 35.0,
                color: Theme.of(context).accentColor,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).accentColor,
                  width: 2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// onSubmitted: () {
//   if (_pageController.hasClients) {
//     _pageController.animateToPage(
//       1,
//       duration: const Duration(milliseconds: 400),
//       curve: Curves.easeInOut,
//     );
//   }
// },

// return showDialog(
//   context: context,
//   builder: (context) {
//     return AlertDialog(
//       content: Text(
//         myController.text,
//       ),
//     );
//   },
// );
