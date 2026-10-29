import 'package:flutter/material.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';

class EventRegistrationScreen extends StatefulWidget {
  final EventItem event;
  final Function(RegistrationTicket) onTicketAdded;

  const EventRegistrationScreen({
    super.key,
    required this.event,
    required this.onTicketAdded,
  });

  @override
  State<EventRegistrationScreen> createState() =>
      _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();

  String _participantType = 'Mahasiswa';
  DateTime? _selectedDate;
  String _kitPackage = 'Standar';
  double _donationAmount = 0.0;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal kehadiran terlebih dahulu!')),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda harus menyetujui tata tertib!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final newTicket = RegistrationTicket(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      eventTitle: widget.event.title,
      name: _nameController.text,
      nim: _nimController.text,
      email: _emailController.text,
      whatsapp: _whatsappController.text,
      participantType: _participantType,
      attendanceDate: _selectedDate!,
      kitPackage: _kitPackage,
      donationAmount: _donationAmount,
    );

    widget.onTicketAdded(newTicket);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pendaftaran berhasil dilakukan!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar: ${widget.event.title}')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Nama wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nimController,
                      decoration: const InputDecoration(
                        labelText: 'NIM',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? 'NIM wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Email wajib diisi';
                        if (!val.contains('@')) return 'Format email tidak valid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _whatsappController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Nomor WhatsApp',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? 'Nomor WhatsApp wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _participantType,
                      decoration: const InputDecoration(
                        labelText: 'Tipe Peserta',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Mahasiswa', 'Dosen', 'Umum']
                          .map((type) =>
                              DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _participantType = val!),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      title: Text(
                        _selectedDate == null
                            ? 'Pilih Tanggal Kehadiran'
                            : 'Tanggal: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: _presentDatePicker,
                    ),
                    const SizedBox(height: 16),
                    Text('Paket Seminar Kit:',
                        style: Theme.of(context).textTheme.titleMedium),
                    RadioListTile<String>(
                      title: const Text('Standar (Sertifikat + E-Book)'),
                      value: 'Standar',
                      groupValue: _kitPackage,
                      onChanged: (val) => setState(() => _kitPackage = val!),
                    ),
                    RadioListTile<String>(
                      title: const Text('Premium (Sertifikat + Kaos + Merchandise)'),
                      value: 'Premium',
                      groupValue: _kitPackage,
                      onChanged: (val) => setState(() => _kitPackage = val!),
                    ),
                    const SizedBox(height: 12),
                    Text('Donasi Acara: Rp ${_donationAmount.toInt()}',
                        style: Theme.of(context).textTheme.titleMedium),
                    Slider(
                      value: _donationAmount,
                      min: 0,
                      max: 100000,
                      divisions: 10,
                      label: 'Rp ${_donationAmount.toInt()}',
                      onChanged: (val) => setState(() => _donationAmount = val),
                    ),
                    CheckboxListTile(
                      value: _agreedToTerms,
                      title: const Text('Saya menyetujui tata tertib acara.'),
                      onChanged: (val) =>
                          setState(() => _agreedToTerms = val ?? false),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _submitForm,
                        child: const Text('Daftar Sekarang'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}