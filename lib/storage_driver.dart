import 'storage_driver_base.dart';
import 'storage_driver_stub.dart' as driver
    if (dart.library.io) 'storage_driver_io.dart'
    if (dart.library.html) 'storage_driver_web.dart';

export 'storage_driver_base.dart' show StorageDriver;

StorageDriver createStorageDriver() => driver.buildStorageDriver();
