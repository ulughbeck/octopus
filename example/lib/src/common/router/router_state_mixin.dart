import 'package:example/src/common/model/dependencies.dart';
import 'package:example/src/common/router/authentication_guard.dart';
import 'package:example/src/common/router/home_guard.dart';
import 'package:example/src/common/router/routes.dart';
import 'package:example/src/common/router/shop_guard.dart';
import 'package:example/src/feature/shop/data/shop_tabs_cache_service.dart';
import 'package:flutter/widgets.dart'
    show DefaultTransitionDelegate, State, StatefulWidget, ValueNotifier;
import 'package:octopus/octopus.dart';

mixin RouterStateMixin<T extends StatefulWidget> on State<T> {
  late final Octopus router;
  late final ValueNotifier<List<({Object error, StackTrace stackTrace})>>
      errorsObserver;

  @override
  void initState() {
    final dependencies = Dependencies.of(context);
    // Observe all errors.
    errorsObserver =
        ValueNotifier<List<({Object error, StackTrace stackTrace})>>(
      <({Object error, StackTrace stackTrace})>[],
    );

    // Create cache for shop tabs.
    final shopTabCache = ShopTabsCacheService(
      sharedPreferences: dependencies.sharedPreferences,
    );

    // Create router.
    router = Octopus(
      routes: Routes.values,
      defaultRoute: Routes.shop,
      transitionDelegate: const DefaultTransitionDelegate<void>(),
      guards: <IOctopusGuard>[
        // Check authentication.
        AuthenticationGuard(
          // Get current user from authentication controller.
          getUser: () => dependencies.authenticationController.state.user,
          // Available routes for non authenticated user.
          routes: <String>{
            Routes.signin.name,
            Routes.signup.name,
          },
          // Default route for non authenticated user.
          signinNavigation: OctopusState.single(Routes.signin.node()),
          // Default route for authenticated user.
          homeNavigation: OctopusState.single(Routes.home.node()),
          // Check authentication on every authentication controller state change.
          refresh: dependencies.authenticationController,
        ),
        // Home route should be always on top.
        HomeGuard(),
        // Check shop tabs with nested navigation.
        ShopGuard(cache: shopTabCache),
      ],
      onError: (error, stackTrace) =>
          errorsObserver.value = <({Object error, StackTrace stackTrace})>[
        (error: error, stackTrace: stackTrace),
        ...errorsObserver.value,
      ],
      /* observers: <NavigatorObserver>[
        HeroController(),
      ], */
    );
    super.initState();
  }
}
