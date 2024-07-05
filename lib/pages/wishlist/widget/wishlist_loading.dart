import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:travellingo/utils/format_currency.dart';

class WishlistLoading extends StatelessWidget {
  final bool isLoading;
  const WishlistLoading({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
          itemCount: 7,
          separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
          itemBuilder: (context, index) {
            return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: 125,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      children: [
                        AspectRatio(
                            aspectRatio: 1,
                            child: Image.asset("assets/images/placeholder.png",
                                width: 100, fit: BoxFit.cover)),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Seaside Restaurant",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        size: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error),
                                    const Text("USA, Los Angeles"),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  formatToIndonesiaCurrency(500000),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          }),
    );
  }
}
