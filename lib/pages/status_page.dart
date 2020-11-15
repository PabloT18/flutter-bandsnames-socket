import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_app/services/sockect_service.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sockectService = Provider.of<SockectService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Status Status ${sockectService.serverStatus}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: () {
          sockectService
              .emit("nuevo-mensaje", {'mensaje': "Mensaje desde flutter"});
        },
      ),
    );
  }
}
