import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MyShimmer extends StatelessWidget {
  final double width;
  final double height;
  const MyShimmer({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10)),
            )));
  }
}

Widget myListLoadingShimmer() {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, _) => const Card(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyShimmer(width: 80, height: 80),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyShimmer(width: 150, height: 15),
                          SizedBox(
                            height: 10,
                          ),
                          MyShimmer(width: 100, height: 10),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              MyShimmer(width: 30, height: 10),
                              MyShimmer(width: 30, height: 10)
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ));
}

Widget myProfileLoadingShimmer() {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(3),
          child: DottedBorder(
              strokeWidth: 3,
              color: const Color(0xFFF6F8FB),
              dashPattern: const [9, 7],
              borderType: BorderType.Circle,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const CircleAvatar(
                    radius: 50,
                    child: MyShimmer(
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              )),
        ),
        const SizedBox(
          height: 10,
        ),
        const MyShimmer(width: 100, height: 15),
        const SizedBox(
          height: 5,
        ),
        const MyShimmer(width: 100, height: 10),
      ],
    ),
  );
}
