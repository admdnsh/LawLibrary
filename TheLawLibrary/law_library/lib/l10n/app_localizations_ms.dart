// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appTitle => 'Perpustakaan Undang-undang';

  @override
  String get settings => 'Tetapan';

  @override
  String get appearance => 'Paparan';

  @override
  String get darkMode => 'Mod Gelap';

  @override
  String get uiDensity => 'Ketumpatan UI';

  @override
  String get fontSize => 'Saiz Fon';

  @override
  String get adjustSpacing => 'Laraskan Jarak';

  @override
  String get adjustFontSize => 'Laraskan saiz teks';

  @override
  String get language => 'Bahasa';

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String get data => 'Data & Storan';

  @override
  String get favorites => 'Kegemaran';

  @override
  String get clearFavorites => 'Kosongkan Kegemaran';

  @override
  String get removeSavedLaws => 'Padam semua undang-undang disimpan';

  @override
  String get clearCache => 'Kosongkan Cache';

  @override
  String get removeTempData => 'Padam data sementara';

  @override
  String get confirm => 'Sahkan';

  @override
  String get cancel => 'Batal';

  @override
  String get confirmRemoveFavorites => 'Adakah anda pasti mahu memadam semua kegemaran?';

  @override
  String get confirmClearCache => 'Adakah anda pasti mahu mengosongkan cache?';

  @override
  String get about => 'Mengenai';

  @override
  String get appVersion => 'Versi Aplikasi';

  @override
  String get paymentInformation => 'Maklumat Pembayaran';

  @override
  String get whereToPay => 'Tempat Membuat Pembayaran';

  @override
  String get paymentOptionsText => 'Untuk membuat pembayaran, anda mempunyai dua pilihan mudah:';

  @override
  String get onlinePayment => '1. Pembayaran Dalam Talian';

  @override
  String get onlinePaymentDescription => 'Anda boleh menjelaskan denda atau bayaran dengan cepat dan selamat melalui portal pembayaran dalam talian rasmi kami. Kaedah ini tersedia 24/7, membolehkan anda membayar dari mana-mana menggunakan komputer atau peranti mudah alih.';

  @override
  String get inPersonPayment => '2. Pembayaran Secara Bersemuka di Cawangan JSKLL';

  @override
  String get inPersonPaymentDescription => 'Jika anda lebih suka membuat pembayaran secara bersemuka, anda boleh mengunjungi cawangan JSKLL tertentu. Cawangan ini boleh memproses pembayaran semasa waktu operasi biasa.';

  @override
  String get importantNote => 'Nota Penting';

  @override
  String get importantNoteDescription => 'Pastikan anda membawa dokumentasi yang diperlukan (contohnya, notis kesalahan, pengenalan) semasa membuat pembayaran di cawangan.';

  @override
  String get onlinePaymentGuide => 'Panduan Pembayaran Dalam Talian';

  @override
  String get videoReference => 'Untuk maklumat lanjut tentang pembayaran dalam talian, sila rujuk video ini:';

  @override
  String get aboutLawLibrary => 'Mengenai Law Library';

  @override
  String get appVersionNumber => 'Versi 2.0';

  @override
  String get aboutDescriptionTitle => 'Penerangan';

  @override
  String get aboutDescriptionBody => 'Law Library ialah sebuah aplikasi komprehensif yang direka untuk membantu pengguna mengakses, meneroka, dan mengurus maklumat perundangan dengan cekap. Aplikasi ini menyediakan fungsi carian, pengkategorian, serta penandaan undang-undang untuk rujukan pantas. Semua kandungan undang-undang diperoleh daripada Akta Lalu Lintas Jalan Raya (2022) dan Peraturan-Peraturan Lalu Lintas Jalan Raya (2022).';

  @override
  String get aboutFeaturesTitle => 'Ciri-ciri';

  @override
  String get featureSearch => 'Carian Undang-undang';

  @override
  String get featureCategories => 'Penapisan Kategori';

  @override
  String get featureFavorites => 'Pengurusan Kegemaran';

  @override
  String get featureSettings => 'Tetapan Boleh Disesuaikan';

  @override
  String get aboutCapstoneTitle => 'Projek Capstone';

  @override
  String get aboutCapstoneBody => 'Aplikasi ini dibangunkan sebagai projek capstone bagi memenuhi keperluan Ijazah Sarjana Muda Sains (Kepujian) dalam Pengkomputeran (Pengkhususan Pembangunan Perisian). Projek ini dijalankan dengan kerjasama Jabatan Kawalan Lalu Lintas dan Penyiasatan (JSKLL), menggabungkan pengetahuan teori dan kemahiran praktikal untuk menangani cabaran dunia sebenar melalui penyelidikan gunaan dan inovasi.';

  @override
  String get aboutCreditsTitle => 'Penghargaan';

  @override
  String get aboutCreditsBody => 'Dibangunkan oleh: Muhammad Adam Danish bin Shukri\n\nPenyelia UTB:\nDr. Wida Susanty Haji Suhaili\nAk. Dr Mohd Salihin Pg Haji Abdul Rahim\n\nPenyelia Agensi:\nASP Pg Hjh Nafiah Pg Hj Asli';

  @override
  String get homeTitle => 'Perpustakaan Undang-undang';

  @override
  String get homeSubtitle => 'Cari, semak dan urus kesalahan jalan raya';

  @override
  String searchFound(num count, Object query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'entri',
      one: 'entri',
    );
    return 'Ditemui $count $_temp0 untuk \"$query\"';
  }

  @override
  String totalLaws(Object count) {
    return 'Jumlah Undang-undang: $count';
  }

  @override
  String get welcomeTitle => 'Selamat Datang!';

  @override
  String get welcomeIntro => 'Cara menggunakan aplikasi:';

  @override
  String get guideSearch => '• Gunakan bar carian di atas untuk mencari undang-undang.';

  @override
  String get guideFilter => '• Tapis mengikut kategori di bawah bar carian.';

  @override
  String get guideTap => '• Tekan undang-undang untuk melihat butiran.';

  @override
  String get guideFavorite => '• Tekan ikon bintang untuk tambah/buang kegemaran.';

  @override
  String get guideNav => '• Gunakan navigasi bawah untuk tukar skrin.';

  @override
  String get guideAdmin => '• Pentadbir boleh akses Panel Admin di penjuru kanan atas.';

  @override
  String get gotIt => 'Faham';

  @override
  String get logoutSuccess => 'Berjaya log keluar';

  @override
  String get tabFavorites => 'Kegemaran';

  @override
  String get tabPayment => 'Pembayaran';

  @override
  String get tabAbout => 'Mengenai';

  @override
  String get tabSettings => 'Tetapan';

  @override
  String get tabHome => 'Laman Utama';

  @override
  String get noFavoritesTitle => 'Tiada kegemaran lagi';

  @override
  String get noFavoritesDescription => 'Tambah undang-undang ke kegemaran untuk melihatnya di sini';

  @override
  String get searchFavoritesHint => 'Cari kegemaran...';

  @override
  String favoritesSearchResult(num count, Object query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'entri',
      one: 'entri',
    );
    return 'Dijumpai $count $_temp0 untuk \"$query\"';
  }

  @override
  String get noSearchResultsTitle => 'Tiada padanan ditemui';

  @override
  String get noSearchResultsDescription => 'Cuba ubah carian anda';

  @override
  String lawChapterCategory(Object chapter, Object category) {
    return 'Bab $chapter • $category';
  }

  @override
  String get loginAppBarTitle => 'Log Masuk Admin';

  @override
  String get loginWelcomeTitle => 'Selamat Kembali';

  @override
  String get loginSubtitle => 'Log masuk untuk mengakses ciri admin';

  @override
  String get loginUsernameLabel => 'Nama Pengguna';

  @override
  String get loginPasswordLabel => 'Kata Laluan';

  @override
  String get loginButton => 'LOG MASUK';

  @override
  String get loginErrorGeneric => 'Ralat berlaku. Sila cuba lagi.';

  @override
  String get loginUsernameRequired => 'Nama pengguna diperlukan';

  @override
  String get loginUsernameMinLength => 'Nama pengguna mesti sekurang-kurangnya 3 aksara';

  @override
  String get loginPasswordRequired => 'Kata laluan diperlukan';

  @override
  String get loginPasswordMinLength => 'Kata laluan mesti sekurang-kurangnya 6 aksara';

  @override
  String get lawChapterRequired => 'Bab diperlukan';

  @override
  String get lawTitleRequired => 'Tajuk diperlukan';

  @override
  String get lawCategoryRequired => 'Kategori diperlukan';

  @override
  String get searchHint => 'Cari undang-undang...';

  @override
  String get searchNoResults => 'Tiada hasil ditemui';

  @override
  String get searchNoResultsTitle => 'Tiada undang-undang ditemui';

  @override
  String get searchNoResultsSubtitle => 'Cuba laraskan kriteria carian atau penapis anda';

  @override
  String get paginationPrevious => 'Halaman sebelumnya';

  @override
  String get paginationNext => 'Halaman seterusnya';

  @override
  String searchError(Object errorMessage) {
    return 'Error: $errorMessage';
  }

  @override
  String get recentSearches => 'Terkini';

  @override
  String get clearSearches => 'Padam';

  @override
  String get noResultsFound => 'Tiada keputusan dijumpai';

  @override
  String get noResultsHint => 'Cuba cari mengikut tajuk kesalahan, nombor bab, atau kategori.';

  @override
  String get noResultsTryLabel => 'Cuba cari:';

  @override
  String get compoundFines => 'DENDA KOMPAUN';

  @override
  String get tabDashboard => 'Papan Pemuka';

  @override
  String get dashboardLawsByCategory => 'Undang-undang Mengikut Kategori';

  @override
  String get dashboardRecentSearches => 'Carian Terkini';

  @override
  String get dashboardError => 'Tidak dapat memuatkan papan pemuka';

  @override
  String get dashboardErrorHint => 'Semak sambungan anda dan cuba lagi.';

  @override
  String get dashboardRetry => 'Cuba Lagi';

  @override
  String get dashboardTotalLaws => 'Jumlah Undang-undang';

  @override
  String get dashboardTotalLawsSubtitle => 'Kesalahan jalan raya dalam pangkalan data';

  @override
  String get splashSubtitle => 'Rujukan Kesalahan Jalan Raya';

  @override
  String get onboardingSlide1Title => 'Cari kesalahan dengan segera';

  @override
  String get onboardingSlide1Desc => 'Cari mengikut kata kunci, nombor bab, atau kategori untuk mendapatkan kesalahan jalan raya yang tepat — walaupun dalam keadaan tertekan di sekatan jalan raya.';

  @override
  String get onboardingSlide2Title => 'Simpan undang-undang yang kerap digunakan';

  @override
  String get onboardingSlide2Desc => 'Leret mana-mana keputusan untuk menyimpannya. Kesalahan yang disimpan sentiasa boleh dicapai dengan satu ketukan, walaupun tanpa sambungan internet.';

  @override
  String get onboardingSlide3Title => 'Sedia untuk digunakan';

  @override
  String get onboardingSlide3Desc => 'Semua yang anda perlukan ada di sini. Kekal cekap, kekal maklum, dan biarkan aplikasi melakukan pencarian.';

  @override
  String get onboardingSkip => 'Langkau';

  @override
  String get onboardingGetStarted => 'Mulakan';

  @override
  String get onboardingNext => 'Seterusnya';

  @override
  String get dashboardNoSearches => 'Tiada carian lagi — mulakan carian untuk melihat sejarah di sini';

  @override
  String get dashboardNoCategoryData => 'Tiada data kategori tersedia';

  @override
  String get lawDetailsTitle => 'Butiran Undang-undang';

  @override
  String get confirmDeleteTitle => 'Sahkan Padam';

  @override
  String confirmDeleteMessage(Object chapter) {
    return 'Adakah anda pasti mahu memadam Bab $chapter?';
  }

  @override
  String get delete => 'Padam';

  @override
  String get lawOffence1 => 'Kesalahan Pertama';

  @override
  String get lawOffence2 => 'Kesalahan Kedua';

  @override
  String get lawOffence3 => 'Kesalahan Ketiga';

  @override
  String get lawOffence4 => 'Kesalahan Keempat';

  @override
  String get lawOffence5 => 'Kesalahan Kelima';

  @override
  String searchFoundPage(Object page, num count, Object query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'keputusan',
      one: 'keputusan',
    );
    return 'Halaman $page · $count $_temp0 untuk \"$query\"';
  }
}
