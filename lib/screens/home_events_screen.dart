import 'package:flutter/material.dart';
import '../data/sample_events.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';
import '../widgets/event_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/venue_map_viewer.dart';
import 'event_registration_screen.dart';
import 'registered_tickets_screen.dart';

class HomeEventsScreen extends StatefulWidget {
  const HomeEventsScreen({super.key});

  @override
  State<HomeEventsScreen> createState() => _HomeEventsScreenState();
}

class _HomeEventsScreenState extends State<HomeEventsScreen> {
  int _currentIndex = 0;
  String _selectedCategory = 'Semua';
  final List<RegistrationTicket> _registeredTickets = [];

  void _addTicket(RegistrationTicket ticket) {
    setState(() {
      _registeredTickets.add(ticket);
    });
  }

  void _cancelTicket(String id) {
    setState(() {
      _registeredTickets.removeWhere((t) => t.id == id);
    });
  }

  List<EventItem> get _filteredEvents {
    if (_selectedCategory == 'Semua') return sampleEvents;
    return sampleEvents
        .where((e) => e.category == _selectedCategory)
        .toList();
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => FilterBottomSheet(
        selectedCategory: _selectedCategory,
        onSelectCategory: (cat) {
          setState(() {
            _selectedCategory = cat;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // Tab 1: Seminar & Workshop
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('  Kategori: $_selectedCategory',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: _openFilterBottomSheet,
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredEvents.length,
              itemBuilder: (ctx, index) {
                final event = _filteredEvents[index];
                return EventCard(
                  event: event,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => EventRegistrationScreen(
                          event: event,
                          onTicketAdded: _addTicket,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Tab 2: Galeri & Denah Venue
      DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.photo_library), text: 'Galeri Poster'),
                Tab(icon: Icon(Icons.map), text: 'Denah Venue'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: sampleEvents.length,
                    itemBuilder: (ctx, i) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          sampleEvents[i].imageUrl,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                  const VenueMapViewer(),
                ],
              ),
            ),
          ],
        ),
      ),

      // Tab 3: Tiket Terdaftar
      RegisteredTicketsScreen(
        tickets: _registeredTickets,
        onCancelTicket: _cancelTicket,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaEvent Hub'),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.event),
            label: 'Seminar',
          ),
          NavigationDestination(
            icon: Icon(Icons.place),
            label: 'Galeri & Denah',
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_number),
            label: 'Tiket Saya',
          ),
        ],
      ),
    );
  }
}