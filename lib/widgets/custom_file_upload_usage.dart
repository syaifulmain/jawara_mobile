/*
CARA MENGGUNAKAN FILE UPLOAD WIDGET

1. Import widget:
import 'package:jawara_mobile/widgets/custom_file_upload.dart';

2. Contoh penggunaan untuk upload foto:

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<String> selectedPhotos = [];
  List<String> selectedDocuments = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Upload Foto dengan factory constructor
        CustomFileUpload.photo(
          onTap: _handlePhotoUpload,
          selectedFiles: selectedPhotos,
          onRemoveFile: _removePhoto,
        ),
        
        SizedBox(height: 16),
        
        // Upload Dokumen dengan factory constructor
        CustomFileUpload.document(
          onTap: _handleDocumentUpload,
          selectedFiles: selectedDocuments,
          onRemoveFile: _removeDocument,
        ),
        
        SizedBox(height: 16),
        
        // Upload Video dengan factory constructor
        CustomFileUpload.video(
          onTap: _handleVideoUpload,
          selectedFiles: selectedVideos,
          onRemoveFile: _removeVideo,
        ),
        
        SizedBox(height: 16),
        
        // Upload Custom dengan constructor manual
        CustomFileUpload(
          label: 'Audio',
          description: 'Maksimal 5 file audio (.mp3), ukuran maksimal 10MB per file.',
          icon: Icons.audiotrack,
          uploadText: 'Upload audio mp3',
          onTap: _handleAudioUpload,
          selectedFiles: selectedAudios,
          onRemoveFile: _removeAudio,
          height: 100, // Custom height
        ),
      ],
    );
  }

  Future<void> _handlePhotoUpload() async {
    try {
      // Tampilkan dialog pilihan
      final String? choice = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pilih Sumber Gambar'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Kamera'),
                  onTap: () => Navigator.of(context).pop('camera'),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () => Navigator.of(context).pop('gallery'),
                ),
              ],
            ),
          );
        },
      );

      if (choice != null) {
        final ImagePicker picker = ImagePicker();
        
        if (choice == 'camera') {
          // Pilih dari camera
          final XFile? photo = await picker.pickImage(source: ImageSource.camera);
          
          if (photo != null) {
            setState(() {
              selectedPhotos.add(photo.path);
            });
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Foto berhasil diambil!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        } else if (choice == 'gallery') {
          // Pilih dari gallery (multiple)
          final List<XFile> images = await picker.pickMultiImage();
          
          if (images.isNotEmpty) {
            setState(() {
              selectedPhotos.addAll(images.map((image) => image.path));
            });
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${images.length} foto berhasil dipilih!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    
    // Demo mode
    setState(() {
      selectedPhotos.add('photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
    });
  }

  void _handleDocumentUpload() {
    // TODO: Implementasi dengan file_picker
    // import 'package:file_picker/file_picker.dart';
    
    /*
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        selectedDocuments.addAll(result.paths.where((path) => path != null).cast<String>());
      });
    }
    */
    
    // Demo mode
    setState(() {
      selectedDocuments.add('document_${DateTime.now().millisecondsSinceEpoch}.pdf');
    });
  }

  void _removePhoto(int index) {
    setState(() {
      selectedPhotos.removeAt(index);
    });
  }

  void _removeDocument(int index) {
    setState(() {
      selectedDocuments.removeAt(index);
    });
  }
}

FITUR WIDGET:
✅ UI konsisten dengan desain yang diberikan
✅ Icon dapat disesuaikan (cloud_upload untuk foto, description untuk dokumen, dll)
✅ Label dan deskripsi dapat dikustomisasi
✅ List file yang terpilih dengan preview nama dan icon
✅ Tombol hapus untuk setiap file
✅ Factory constructors untuk penggunaan mudah:
   - CustomFileUpload.photo()
   - CustomFileUpload.document() 
   - CustomFileUpload.video()
✅ Support custom height dan width
✅ Icon otomatis berdasarkan ekstensi file
✅ Ripple effect saat diklik

UNTUK IMPLEMENTASI PENUH, TAMBAHKAN PACKAGE KE pubspec.yaml:
dependencies:
  image_picker: ^1.0.4    # Untuk camera dan gallery  
  file_picker: ^6.1.1     # Untuk file dokumen
  path_provider: ^2.1.1   # Untuk menyimpan file lokal

CONTOH IMPLEMENTASI SUDAH BERJALAN DI:
- lib/screens/admin/broadcast/tambah_pengeluaran_screen.dart

*/