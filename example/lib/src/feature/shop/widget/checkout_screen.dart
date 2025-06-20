import 'package:example/src/common/router/routes.dart';
import 'package:example/src/common/widget/common_actions.dart';
import 'package:example/src/common/widget/form_placeholder.dart';
import 'package:example/src/common/widget/scaffold_padding.dart';
import 'package:example/src/feature/shop/widget/shop_back_button.dart';
import 'package:example/src/feature/shop/widget/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:octopus/octopus.dart';

/// {@template checkout_screen}
/// CheckoutScreen widget.
/// {@endtemplate}
class CheckoutScreen extends StatelessWidget {
  /// {@macro checkout_screen}
  const CheckoutScreen({super.key});

  void pay(BuildContext context) {
    context.octopus.setState((state) => state
      ..removeByName(Routes.checkout.name)
      ..arguments[ShopScreen.tabIdentifier] = Routes.catalog.name);
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(
        content: Text('Payment successful'),
        backgroundColor: Colors.green,
      ),
    );
    HapticFeedback.mediumImpact().ignore();
  }

  static const double _bottomHeight = 48 + 16 + 16;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
          leading: const ShopBackButton(),
          actions: CommonActions(),
        ),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              // Scrollable body
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: ScaffoldPadding.of(context).copyWith(
                    top: 16,
                    bottom: _bottomHeight + 16,
                  ),
                  child: const FormPlaceholder(),
                ),
              ),

              // Bottom gradient
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: _bottomHeight + 48,
                child: IgnorePointer(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: const <Color>[
                          Colors.transparent,
                          Colors.purple,
                          Colors.purple,
                        ],
                        stops: <double>[
                          0,
                          1.0 - _bottomHeight / bounds.height,
                          1,
                        ],
                      ).createShader(bounds),
                      blendMode: BlendMode.dstIn,
                      child: const ColoredBox(color: Colors.white),
                    ),
                  ),
                ),
              ),

              // Checkout button
              Positioned(
                height: _bottomHeight,
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: ScaffoldPadding.of(context).copyWith(
                    bottom: 16,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => pay(context),
                              label: const Text(
                                'Card',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  height: 1,
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              icon: const Icon(
                                Icons.payment,
                                size: 24,
                                color: Colors.black,
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: Colors.greenAccent.shade200,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => pay(context),
                              label: const Text(
                                'PayPal',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  height: 1,
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              icon: const Icon(
                                Icons.paypal,
                                size: 24,
                                color: Colors.black,
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: Colors.blueAccent.shade200,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
