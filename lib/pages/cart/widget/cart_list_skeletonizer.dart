import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartListSkeletonizer extends StatelessWidget {
  final bool isLoading;
  const CartListSkeletonizer({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Skeletonizer(
      enabled: isLoading,
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      children: [
                        AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                                "https://fastly.picsum.photos/id/386/300/300.jpg?hmac=d6FbS5fber4u6kKm85UMyvPMNGXhkx3_gjHz7pkIMug",
                                width: 100,
                                fit: BoxFit.cover)),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const Spacer(),
                                Text(
                                  "Rp ${NumberFormat("###,###", "id_ID").format(50000)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (_) {},
                              side: WidgetStateBorderSide.resolveWith(
                                (state) => BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              checkColor:
                                  Theme.of(context).colorScheme.secondary,
                              shape: const CircleBorder(),
                              fillColor: WidgetStateColor.transparent,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(right: 5, bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.zero,
                              child: Row(
                                children: [
                                  Container(
                                    color: Colors.transparent,
                                    padding: const EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.remove,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      size: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "1",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    color: Colors.transparent,
                                    padding: const EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.add,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          );
        },
      ),
    ));
  }
}
