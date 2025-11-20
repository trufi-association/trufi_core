# trufi_core

A Flutter package for route planning and navigation with flexible local storage architecture.

## 📦 Local Storage Architecture

This package uses a **storage-agnostic architecture** that allows easy switching between different storage backends.

### Current Implementation: SharedPreferences ✅
- Simple and reliable key-value storage
- No code generation required
- Cross-platform support

### Key Features:
- 🔌 **Pluggable Storage**: Easy to swap implementations via `ILocalStorage` interface
- 🔄 **Migration Ready**: Seamlessly migrate to SQLite/Drift when needed
- 📱 **Platform Independent**: Works on all Flutter platforms
- 🧪 **Testable**: Mock-friendly architecture

### Quick Start

```dart
import 'package:trufi_core/repositories/storage/shared_preferences_storage.dart';
import 'package:trufi_core/repositories/location/services/storage_location_service.dart';

// Create storage
final storage = SharedPreferencesStorage();
await storage.init();

// Use with services
final locationService = StorageLocationService(storage);
await locationService.loadRepository();
```

### Documentation
- 📖 [Storage Architecture](STORAGE_ARCHITECTURE.md) - Detailed architecture overview
- 🚀 [Migration Guide](MIGRATION_GUIDE.md) - Migrating from Hive
- 💡 [Examples](lib/repositories/storage/storage_example.dart) - Usage examples

### ⚠️ Breaking Changes
**Hive has been completely removed** from this package (as of November 2025):
- ❌ `HiveLocationService` - **Removed** (use `StorageLocationService`)
- ❌ `MapRouteHiveLocalRepository` - **Removed** (use `StorageMapRouteRepository`)
- ❌ `initHiveForFlutter()` - **Removed** (no longer needed)

See [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for migration instructions and [HIVE_REMOVAL_SUMMARY.md](HIVE_REMOVAL_SUMMARY.md) for details.