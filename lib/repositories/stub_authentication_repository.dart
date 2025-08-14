/// Stub implementation of AuthenticationRepository for Linux
/// This avoids Firebase dependencies on Linux platform
class StubAuthenticationRepository {
  const StubAuthenticationRepository();

  /// Mock sign in - always succeeds on Linux
  Future<void> signInAnonymously() async {
    // No-op for Linux
    print('🐧 Linux: Mock authentication successful');
  }
}
