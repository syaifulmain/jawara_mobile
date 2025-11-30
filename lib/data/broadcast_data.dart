import '../models/broadcast_model.dart';

List<BroadcastModel> dummyBroadcasts = [
  BroadcastModel(
    id: '1',
    judul: 'Pengumuman Penting',
    isi: 'Akan diadakan maintenance sistem pada tanggal 25 Desember.',
    tanggal: '2023-12-20',
    fotoPath: 'assets/images/maintenance.png',
    dokumenPath: 'assets/docs/maintenance.pdf',
    userId: 'user123',
  ),
  BroadcastModel(
    id: '2',
    judul: 'Event Akhir Tahun',
    isi: 'Jangan lupa menghadiri event akhir tahun di aula utama.',
    tanggal: '2023-12-15',
    fotoPath: 'assets/images/event.png',
    dokumenPath: 'assets/docs/event_details.pdf',
    userId: 'user456',
  ),
  BroadcastModel(
    id: '3',
    judul: 'Update Aplikasi',
    isi: 'Versi terbaru aplikasi sudah tersedia. Silakan update melalui Play Store.',
    tanggal: '2023-12-10',
    fotoPath: 'assets/images/update.png',
    dokumenPath: 'assets/docs/update_notes.pdf',
    userId: 'user789',
  ),
];