import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final List<Map<String, dynamic>> tours = [
    {
      'title': 'City Sightseeing',
      'subtitle': 'Explore the city\'s landmarks',
      'price': '\$25',
      'icon': Icons.flight,
    },
    {
      'title': 'Bike Tour',
      'subtitle': 'Discover hidden gems',
      'price': '\$45',
      'icon': Icons.pedal_bike,
    },
    {
      'title': 'Culinary Experience',
      'subtitle': 'Taste local flavors',
      'price': '\$60',
      'icon': Icons.restaurant,
    },
  ];

  final List<Map<String, dynamic>> inspirations = [
    {
      'title': 'Sunset at the beach',
      'desc': 'Can’t get enough of this view! 🌅',
      'hashtags': ['#travel', '#paradise'],
      'author': 'Ella',
    },
    {
      'title': 'Snowy peaks',
      'desc': 'Winter wonderland! ❄️',
      'hashtags': ['#winter', '#adventure'],
      'author': 'Leo',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.blueGrey[100],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Rated Tours
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Top Rated Tours",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: tours.map((tour) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue[50],
                            child: Icon(tour['icon'], color: Colors.blueAccent),
                          ),
                          title: Text(tour['title']),
                          subtitle: Text(tour['subtitle']),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                tour['price'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.flight_takeoff, size: 16),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Subtitle
              Center(
                child: Text(
                  "JURUSTAY THE BEST\nADVENTURE EXPERIENCE.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 20),

              // Travel Inspirations
              Text(
                "Travel Inspirations",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: inspirations.length,
                  itemBuilder: (context, index) {
                    final card = inspirations[index];
                    return Container(
                      width: 200,
                      margin: EdgeInsets.only(right: 12),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card['title'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(card['desc']),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 4,
                            children: card['hashtags']
                                .map<Widget>(
                                  (tag) => Chip(
                                    label: Text(
                                      tag,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    backgroundColor: Colors.grey[200],
                                  ),
                                )
                                .toList(),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.grey,
                              ),
                              SizedBox(width: 6),
                              Text(card['author']),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
