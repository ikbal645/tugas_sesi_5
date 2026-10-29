import 'package:flutter/material.dart';
import '../models/registration_ticket.dart';

class RegisteredTicketsScreen extends StatelessWidget {
  final List<RegistrationTicket> tickets;
  final Function(String) onCancelTicket;

  const RegisteredTicketsScreen({
    super.key,
    required this.tickets,
    required this.onCancelTicket,
  });

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      return const Center(
        child: Text('Belum ada tiket terdaftar.'),
      );
    }

    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return Dismissible(
          key: Key(ticket.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Batalkan Tiket'),
                content: const Text(
                    'Apakah Anda yakin ingin membatalkan pendaftaran ini?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('Tidak'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text('Ya, Batalkan'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            onCancelTicket(ticket.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tiket telah dibatalkan.')),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(ticket.eventTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Peserta: ${ticket.name} (${ticket.participantType})'),
                  Text(
                      'Tgl: ${ticket.attendanceDate.day}/${ticket.attendanceDate.month}/${ticket.attendanceDate.year}'),
                  Text('Paket: ${ticket.kitPackage}'),
                ],
              ),
              isThreeLine: true,
            ),
          ),
        );
      },
    );
  }
}