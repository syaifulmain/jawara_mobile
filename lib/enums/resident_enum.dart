enum Gender {
  lakiLaki('M', 'Laki-laki'),
  perempuan('F', 'Perempuan');

  final String value;
  final String label;

  const Gender(this.value, this.label);

  static Gender fromString(String value) {
    return Gender.values.firstWhere(
      (category) => category.value == value,
      orElse: () => Gender.lakiLaki,
    );
  }
}

enum Religion {
  islam('Islam', 'Islam'),
  kristen('Kristen', 'Kristen'),
  katolik('Katolik', 'Katolik'),
  hindu('Hindu', 'Hindu'),
  buddha('Buddha', 'Buddha'),
  konghucu('Konghuchu', 'Konghuchu'),
  lainnya('Lainnya', 'Lainnya');

  final String value;
  final String label;

  const Religion(this.value, this.label);

  static Religion fromString(String value) {
    return Religion.values.firstWhere(
      (category) => category.value == value,
      orElse: () => Religion.lainnya,
    );
  }
}

enum BloodType {
  a('A', 'A'),
  b('B', 'B'),
  ab('AB', 'AB'),
  o('O', 'O'),
  tidakTahu('Tidak Tahu', 'Tidak Tahu');

  final String value;
  final String label;

  const BloodType(this.value, this.label);

  static BloodType fromString(String value) {
    return BloodType.values.firstWhere(
      (category) => category.value == value,
      orElse: () => BloodType.tidakTahu,
    );
  }
}

enum FamilyRole {
  kepalaKeluarga('Kepala Keluarga', 'Kepala Keluarga'),
  istri('Istri', 'Istri'),
  anak('Anak', 'Anak'),
  lainnya('Lainnya', 'Lainnya');

  final String value;
  final String label;

  const FamilyRole(this.value, this.label);

  static FamilyRole fromString(String value) {
    return FamilyRole.values.firstWhere(
      (category) => category.value == value,
      orElse: () => FamilyRole.lainnya,
    );
  }
}

enum LastEducation {
  tidakSekolah('Tidak Sekolah', 'Tidak Sekolah'),
  sd('SD', 'SD'),
  smp('SMP', 'SMP'),
  sma('SMA', 'SMA'),
  diploma('Diploma', 'Diploma'),
  sarjana('Sarjana', 'Sarjana'),
  pascasarjana('Pascasarjana', 'Pascasarjana');

  final String value;
  final String label;

  const LastEducation(this.value, this.label);

  static LastEducation fromString(String value) {
    return LastEducation.values.firstWhere(
      (category) => category.value == value,
      orElse: () => LastEducation.tidakSekolah,
    );
  }
}

enum Occupation {
  pekerjaSwasta('Pekerja Swasta', 'Pekerja Swasta'),
  pegawaiNegeri('Pegawai Negeri', 'Pegawai Negeri'),
  wiraswasta('Wiraswasta', 'Wiraswasta'),
  pelajarMahasiswa('Pelajar/Mahasiswa', 'Pelajar/Mahasiswa'),
  tidakBekerja('Tidak Bekerja', 'Tidak Bekerja'),
  lainnya('Lainnya', 'Lainnya');

  final String value;
  final String label;

  const Occupation(this.value, this.label);

  static Occupation fromString(String value) {
    return Occupation.values.firstWhere(
      (category) => category.value == value,
      orElse: () => Occupation.lainnya,
    );
  }
}
