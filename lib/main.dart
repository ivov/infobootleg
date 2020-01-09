import 'package:flutter/material.dart';
import 'package:infobootleg/services/auth.dart';
import 'package:infobootleg/services/auth_provider.dart';
import 'package:provider/provider.dart';

import 'helpers/state_model.dart';
// import 'helpers/theme_data.dart';

// import 'screens/result_screen.dart';
// import 'screens/search_screen.dart';
import 'screens/landing_screen.dart';

void main() => runApp(Infobootleg());

class Infobootleg extends StatelessWidget {
  final PageController _myPageController = PageController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<PageController>(
          builder: (context) => _myPageController,
        ),
        ChangeNotifierProvider<StateModel>(
          builder: (context) => StateModel(),
        )
      ],
      child: AuthProvider(
        auth: Auth(),
        child: MaterialApp(
          title: 'Infobootleg',
          theme: ThemeData(primarySwatch: Colors.indigo),
          home: LandingScreen(auth: Auth()),
        ),
      ),
    );
  }
}

// original:
// class Infobootleg extends StatelessWidget {
//   final PageController _myPageController = PageController();

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ListenableProvider<PageController>(
//             builder: (context) => _myPageController),
//         ChangeNotifierProvider<StateModel>(
//           builder: (context) => StateModel(),
//         )
//       ],
//       child: MaterialApp(
//         title: 'Infobootleg',
//         theme: themeData,
//         home: PageView(
//           controller: _myPageController,
//           scrollDirection: Axis.vertical,
//           children: <Widget>[
//             SearchScreen(),
//             Consumer<StateModel>(
//               builder: (context, stateModel, child) =>
//                   ResultScreen(stateModel.currentLaw),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
