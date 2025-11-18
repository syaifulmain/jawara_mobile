/*
CARA MENGGUNAKAN IMAGE DISPLAY WIDGET

1. Import widget:
import 'package:jawara_mobile/widgets/custom_image_display.dart';

2. Gunakan dalam build method:

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String? selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dengan gambar dan tombol edit
        CustomImageDisplay(
          label: 'Dokumentasi Event',
          imagePath: selectedImagePath,
          onEdit: () {
            // Tampilkan modal untuk pilih gambar
            _showImagePickerModal();
          },
        ),
        
        // Tanpa tombol edit
        CustomImageDisplay(
          label: 'Foto Tambahan', 
          imagePath: 'https://example.com/image.jpg',
        ),

        // Custom ukuran thumbnail
        CustomImageDisplay(
          label: 'Logo',
          imagePath: 'assets/images/logo.png',
          thumbnailWidth: 100,
          thumbnailHeight: 100,
          onEdit: () => _editLogo(),
        ),
      ],
    );
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Ambil Foto'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementasi camera
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library), 
              title: Text('Pilih dari Gallery'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementasi gallery picker
              },
            ),
          ],
        ),
      ),
    );
  }
}

FITUR YANG TERSEDIA:
✅ Thumbnail gambar dengan ukuran portrait (150x200 default)
✅ Klik thumbnail untuk preview gambar ukuran penuh
✅ Tombol "Ubah" di sebelah label 
✅ Support network image (http/https) dan asset image
✅ Placeholder jika tidak ada gambar
✅ Error handling jika gambar gagal dimuat
✅ Loading indicator untuk network image
✅ Modal preview dengan header dan tombol close
✅ Responsive design

UNTUK IMPLEMENTASI PENUH, TAMBAHKAN PACKAGE:
- image_picker: ^1.0.4 (untuk camera dan gallery)
- path_provider: ^2.1.1 (untuk menyimpan file lokal)

*/