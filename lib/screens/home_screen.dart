import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infobootleg/screens/job.dart';
import 'package:infobootleg/services/auth.dart';
import 'package:infobootleg/services/databaseService.dart';

import 'package:infobootleg/shared_widgets/platform_alert_dialog.dart';
import 'package:infobootleg/shared_widgets/platform_exception_alert_dialog.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final signOutConfirmed = await PlatformAlertDialog(
      title: "Salir",
      content: "¿Confirmar cerrar sesión?",
    ).show(context);
    if (signOutConfirmed) {
      _signOut(context);
    }
  }

  Future<void> _createJob(BuildContext context) async {
    try {
      final firestoreDatabaseService = Provider.of<DatabaseService>(context);
      await firestoreDatabaseService.createJob(
        Job(name: "blogging", rate: 10),
      );
    } on PlatformException catch (error) {
      PlatformExceptionAlertDialog(
        title: "Operation failed",
        exception: error,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Salir",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          )
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createJob(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final database = Provider.of<FirestoreDatabaseService>(context);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs.map((job) => Text(job.name)).toList();
          return ListView(children: children);
        }
        if (snapshot.hasError) {
          return Center(child: Text("Some error occurred!"));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
