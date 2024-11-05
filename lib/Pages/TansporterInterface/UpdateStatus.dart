// screens/update_status.dart
import 'package:flutter/material.dart';

class UpdateStatusDriver extends StatefulWidget {
  @override
  _UpdateStatusDriverState createState() => _UpdateStatusDriverState();
}

class _UpdateStatusDriverState extends State<UpdateStatusDriver> {
  String _status = 'Disponible';

  void _updateStatus(String status) {
    setState(() {
      _status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Statut actuel : $_status",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _updateStatus("Disponible"),
            child: Text("Disponible"),
          ),
          ElevatedButton(
            onPressed: () => _updateStatus("En mission"),
            child: Text("En mission"),
          ),
          ElevatedButton(
            onPressed: () => _updateStatus("Non disponible"),
            child: Text("Non disponible"),
          ),
        ],
      ),
    );
  }
}
