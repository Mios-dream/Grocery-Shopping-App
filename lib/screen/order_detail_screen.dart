import 'package:flutter/material.dart' hide Step, Stepper;
import 'package:go_router/go_router.dart';

import '../widget/app_stepper.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Positioned.fill(
          // child: Image.network(
          //   'img_url',
          //   fit: BoxFit.cover,
          // ),
          child: Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.0,
            leading: const BackButton(),
            actions: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.help_outline),
                label: const Text('Order Help'),
              ),
              const SizedBox(width: 8.0)
            ],
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                    left: 16.0, top: 24.0, right: 16.0, bottom: 24.0),
                padding: const EdgeInsets.only(
                    left: 24.0, top: 24.0, right: 24.0, bottom: 36.0),
                decoration: BoxDecoration(
                  color: colorScheme.inverseSurface,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ORDER STATUS',
                              style: textTheme.bodyLarge!.copyWith(
                                color: colorScheme.onInverseSurface,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Preparing',
                              style: textTheme.headlineSmall!.copyWith(
                                color: colorScheme.onInverseSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'READY BY',
                              style: textTheme.bodyLarge!.copyWith(
                                color: colorScheme.onInverseSurface,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '04:30 PM',
                              style: textTheme.headlineSmall!.copyWith(
                                color: colorScheme.onInverseSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    const SizedBox(
                        height: 70,
                        child: HorizontalStepper(
                          steps: [
                            Step(
                              icon: Icons.receipt_long,
                              isCompleted: true,
                            ),
                            Step(icon: Icons.store),
                            Step(icon: Icons.location_on),
                          ],
                        )),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withAlpha(245),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(48.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Details',
                            style: textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('#123456', style: textTheme.bodyLarge),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 16.0),
                      Expanded(
                        child: ListView(children: [
                          Stepper(
                            steps: [
                              Step(
                                icon: Icons.shopping_cart,
                                title: Text(
                                  'Pick Up',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                  'Order placed on Nov 10th at 4:27pm',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              Step(
                                icon: Icons.location_on,
                                title: Text(
                                  'Drop Off',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                  '2800 Wilshire Blvd, Santa Monica, CA 90403',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              )
                            ],
                          )
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            height: 96,
            color: colorScheme.primaryContainer,
            elevation: 0.0,
            padding: const EdgeInsets.only(
                left: 16.0, top: 24.0, right: 24.0, bottom: 16.0),
            child: FilledButton(
              onPressed: () {
                context
                    .goNamed('category', pathParameters: {'categoryID': '1'});
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48.0),
                backgroundColor: colorScheme.surface,
                foregroundColor: colorScheme.primary,
              ),
              child: Text(
                'Order Again',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
