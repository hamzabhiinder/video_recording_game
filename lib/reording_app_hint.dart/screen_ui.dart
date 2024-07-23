import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Define the button labels for each page
  final List<List<String>> buttonLabels = [
    [
      'Button 1',
      'Button 2',
      'Button 3',
      'Button 4',
      'Button 5',
      'Button 6',
      'Button 7',
      'Button 8'
    ],
    [
      'Button 9',
      'Button 10',
      'Button 11',
      'Button 12',
      'Button 13',
      'Button 14',
      'Button 15',
      'Button 16'
    ],
    [
      'Button 17',
      'Button 18',
      'Button 19',
      'Button 20',
      'Button 21',
      'Button 22',
      'Button 23',
      'Button 24'
    ],
  ];
  final PageController _pageController = PageController(initialPage: 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swipe Buttons'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                color: Colors.white,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 25,
                        width: 100,
                        color: Colors.green,
                      ),
                      Container(
                        height: 25,
                        width: 20,
                        color: Colors.grey,
                      ),
                      Container(
                        height: 25,
                        width: 150,
                        color: Colors.blue[200],
                      ),
                      Container(
                        height: 25,
                        width: 20,
                        color: Colors.grey[200],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 25,
                        width: 100,
                        color: Colors.red,
                      ),
                      Container(
                        height: 25,
                        width: 20,
                        color: Colors.grey[200],
                      ),
                      Container(
                        width: 150,
                        height: 25,
                        color: Colors.blue[200],
                      ),
                      Container(
                        height: 25,
                        width: 20,
                        color: Colors.grey[200],
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          Align(
            alignment: Alignment(0, 0),
            child: SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                itemCount: buttonLabels.length,
                itemBuilder: (context, pageIndex) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 1, // Maintain a square aspect ratio
                    ),
                    itemCount: buttonLabels[pageIndex].length,
                    itemBuilder: (context, buttonIndex) {
                      return SizedBox(
                        width: 50,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0), // Make buttons square
                            ),
                            padding: EdgeInsets.zero,
                            fixedSize: const Size(50, 50), // Set the size to 50x50
                          ),
                          onPressed: () {
                            print('${buttonLabels[pageIndex][buttonIndex]} pressed');
                          },
                          child: Text(
                            buttonLabels[pageIndex][buttonIndex],
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}
