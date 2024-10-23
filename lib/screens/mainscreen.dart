import 'package:camera_app/screens/homepage.dart';
import 'package:flutter/material.dart';

class Mainscreen extends StatelessWidget {
  const Mainscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Photo App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(255, 211, 210, 210),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 160,
          ),
          children: [
            InkWell(
              onTap: () {
                print('Pressed');
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => Homepage()));
              },
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.indigo,
                      child: Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'My Photos',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}
