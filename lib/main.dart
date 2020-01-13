import 'package:flutter/material.dart';
import 'package:infobootleg/screens/referral_screen.dart';
import 'package:provider/provider.dart';

import 'helpers/theme_data.dart';
import 'services/authService.dart';

void main() => runApp(Infobootleg());

class Infobootleg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      builder: (context) => AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Infobootleg',
        theme: themeData,
        home: ReferralScreen(),
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
