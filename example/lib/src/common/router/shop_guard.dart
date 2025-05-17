import 'dart:async';

import 'package:example/src/common/router/routes.dart';
import 'package:example/src/feature/shop/data/shop_tabs_cache_service.dart';
import 'package:octopus/octopus.dart';

/// Do not allow any nested routes at `shop` inderectly except of `*-tab`.
class ShopGuard extends OctopusGuard {
  ShopGuard({
    ShopTabsCacheService? cache,
  }) : _cache = cache;

  final ShopTabsCacheService? _cache;

  @override
  FutureOr<OctopusState> call(
    List<OctopusHistoryEntry> history,
    OctopusState$Mutable state,
    Map<String, Object?> context,
  ) {
    final shop = state.findByName(Routes.shop.name);
    if (shop == null) return state; // Do nothing if `shop` not found.

    // Restore state from cache if exists.
    if (!shop.hasChildren) {
      _cache?.restore(state);
    }

    // Update cache.
    _cache?.save(state);
    return state;
  }
}
