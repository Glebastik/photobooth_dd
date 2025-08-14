import 'dart:typed_data';

/// Stub ShareUrls for Linux
class StubShareUrls {
  const StubShareUrls({
    required this.facebook,
    required this.twitter,
    required this.explicitShareUrl,
  });

  final String facebook;
  final String twitter;
  final String explicitShareUrl;
}

/// Stub implementation of PhotosRepository for Linux
/// This avoids Firebase dependencies on Linux platform
class StubPhotosRepository {
  const StubPhotosRepository();

  /// Mock photo sharing - always succeeds on Linux
  Future<StubShareUrls> sharePhoto({
    required String fileName,
    required Uint8List data,
    required String shareText,
  }) async {
    // No-op for Linux - just return mock URLs
    print('🐧 Linux: Mock photo sharing successful for $fileName');
    return const StubShareUrls(
      facebook: 'https://mock-facebook-url',
      twitter: 'https://mock-twitter-url', 
      explicitShareUrl: 'https://mock-share-url',
    );
  }

  /// Mock photo composition - returns input data on Linux
  Future<Uint8List> composite({
    required Uint8List data,
    required double aspectRatio,
    required List<String> layers,
  }) async {
    // No-op for Linux - just return original data
    print('🐧 Linux: Mock photo composition successful');
    return data;
  }
}
