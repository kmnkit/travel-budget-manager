import '../../domain/entities/consent_status.dart';
import '../../domain/repositories/consent_repository.dart';
import '../datasources/consent_local_datasource.dart';

class ConsentRepositoryImpl implements ConsentRepository {
  final ConsentLocalDataSource _dataSource;

  ConsentRepositoryImpl(this._dataSource);

  @override
  Future<ConsentStatus?> getConsentStatus() async {
    return _dataSource.getConsentStatus();
  }

  @override
  Future<void> saveConsentStatus(ConsentStatus status) async {
    await _dataSource.saveConsentStatus(status);
  }

  @override
  Future<bool> isConsentCompleted() async {
    return _dataSource.isConsentCompleted();
  }

  @override
  Future<void> clearConsent() async {
    await _dataSource.clearConsent();
  }
}
