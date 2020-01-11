import 'package:flutter/foundation.dart';

class Job {
  Job({
    @required this.name,
    @required this.rate,
  });
  final String name;
  final int rate;

  factory Job.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;
    final String name = data["name"];
    final int rate = data["rate"];
    return Job(
      name: name,
      rate: rate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "rate": rate,
    };
  }
}
