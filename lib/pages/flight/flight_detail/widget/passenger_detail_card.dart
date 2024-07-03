import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travellingo/bloc/user_bloc/user_bloc.dart';
import 'package:travellingo/bloc/user_bloc/user_state.dart';
import 'package:travellingo/models/user.dart';

class PassengerDetailCard extends StatefulWidget {
  final Function() onAdd;
  const PassengerDetailCard({super.key, required this.onAdd});

  @override
  State<PassengerDetailCard> createState() => _PassengerDetailCardState();
}

class _PassengerDetailCardState extends State<PassengerDetailCard> {
  late UserBloc userBloc;

  @override
  void initState() {
    userBloc = context.read<UserBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserState>(
        stream: userBloc.controller,
        builder: (context, snapshot) {
          bool isLoading =
              snapshot.data?.isLoading ?? false || !snapshot.hasData;
          if (isLoading || snapshot.data?.receivedProfile == null) {
            return const SizedBox();
          }

          User user = snapshot.data!.receivedProfile!;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.tertiaryContainer,
                  Theme.of(context).colorScheme.surfaceBright.withAlpha(250),
                ],
              ), // Adjust the color to match your design
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                IconButton(
                    onPressed: widget.onAdd,
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5)),
                        shape: WidgetStateProperty.all(const CircleBorder())),
                    icon: const Icon(Icons.person_add_alt_1_outlined))
              ],
            ),
          );
        });
  }
}
