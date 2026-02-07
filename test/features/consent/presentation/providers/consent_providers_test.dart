import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trip_wallet/features/consent/domain/entities/consent_record.dart';
import 'package:trip_wallet/features/consent/domain/repositories/consent_repository.dart';
import 'package:trip_wallet/features/consent/presentation/providers/consent_providers.dart';

class MockConsentRepository extends Mock implements ConsentRepository {}

class FakeConsentRecord extends Fake implements ConsentRecord {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockConsentRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeConsentRecord());
    registerFallbackValue(
      const AsyncValue<ConsentRecord>.loading(),
    );
  });

  setUp(() {
    mockRepository = MockConsentRepository();
  });

  group('consentRepositoryProvider', () {
    test('provides ConsentRepository instance', () {
      final container = ProviderContainer(
        overrides: [
          consentRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final repository = container.read(consentRepositoryProvider);
      expect(repository, equals(mockRepository));
    });
  });

  group('consentRecordProvider', () {
    test('loads consent record successfully', () async {
      final consentRecord = const ConsentRecord(
        isAccepted: true,
        acceptedAt: null,
        policyVersion: '1.0.0',
      );

      when(() => mockRepository.getConsentRecord())
          .thenAnswer((_) async => consentRecord);

      final container = ProviderContainer(
        overrides: [
          consentRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final listener = Listener<AsyncValue<ConsentRecord>>();
      container.listen(
        consentRecordProvider,
        listener.call,
        fireImmediately: true,
      );

      // Initial loading state
      verify(() => listener(null, const AsyncValue.loading()));

      // Wait for data
      final result = await container.read(consentRecordProvider.future);

      expect(result, equals(consentRecord));
      verify(() => mockRepository.getConsentRecord()).called(1);

      // Verify data state
      verify(() => listener(
            const AsyncValue.loading(),
            AsyncValue.data(consentRecord),
          ));

      verifyNoMoreInteractions(listener);
    });

    test('handles error when repository fails', () async {
      final exception = Exception('Failed to load consent record');

      when(() => mockRepository.getConsentRecord())
          .thenThrow(exception);

      final container = ProviderContainer(
        overrides: [
          consentRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      // Subscribe to trigger the provider
      container.listen(consentRecordProvider, (_, _) {});

      // Wait for error to propagate
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Verify error state
      final state = container.read(consentRecordProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<Exception>());
    });

    test('returns consent record with valid consent', () async {
      final consentRecord = ConsentRecord(
        isAccepted: true,
        acceptedAt: DateTime(2024, 1, 1),
        policyVersion: '1.0.0',
      );

      when(() => mockRepository.getConsentRecord())
          .thenAnswer((_) async => consentRecord);

      final container = ProviderContainer(
        overrides: [
          consentRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(consentRecordProvider.future);

      expect(result.hasValidConsent, isTrue);
      expect(result.isAccepted, isTrue);
      expect(result.acceptedAt, isNotNull);
    });

    test('returns consent record without valid consent', () async {
      const consentRecord = ConsentRecord(
        isAccepted: false,
        acceptedAt: null,
        policyVersion: '1.0.0',
      );

      when(() => mockRepository.getConsentRecord())
          .thenAnswer((_) async => consentRecord);

      final container = ProviderContainer(
        overrides: [
          consentRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(consentRecordProvider.future);

      expect(result.hasValidConsent, isFalse);
      expect(result.isAccepted, isFalse);
      expect(result.acceptedAt, isNull);
    });
  });
}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}
