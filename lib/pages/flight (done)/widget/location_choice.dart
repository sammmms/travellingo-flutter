import 'package:flutter/material.dart';

class FlightLocationChoice extends StatefulWidget {
  final ValueNotifier<String> from;
  final ValueNotifier<String> to;

  const FlightLocationChoice({super.key, required this.from, required this.to});

  @override
  State<FlightLocationChoice> createState() => _FlightLocationChoiceState();
}

class _FlightLocationChoiceState extends State<FlightLocationChoice> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset("assets/flight/plane_boarding.png"),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: widget.from.value,
                        onChanged: (String? newValue) {
                          if (newValue == widget.to.value) {
                            widget.to.value = widget.from.value;
                            widget.from.value = newValue!;
                          } else {
                            widget.from.value = newValue!;
                          }
                          setState(() {});
                        },
                        items: const [
                          DropdownMenuItem(value: 'Kobe', child: Text('Kobe')),
                          DropdownMenuItem(
                              value: 'Osaka', child: Text('Osaka')),
                          DropdownMenuItem(
                              value: 'Himeji Castle',
                              child: Text('Himeji Castle')),
                          DropdownMenuItem(
                              value: 'Kyoto', child: Text('Kyoto')),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Image.asset("assets/flight/plane_landing.png"),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: widget.to.value,
                        onChanged: (String? newValue) {
                          if (newValue == widget.from.value) {
                            widget.from.value = widget.to.value;
                            widget.to.value = newValue!;
                          } else {
                            widget.to.value = newValue!;
                          }
                          setState(() {});
                        },
                        items: const [
                          DropdownMenuItem(
                              value: 'Himeji Castle',
                              child: Text('Himeji Castle')),
                          DropdownMenuItem(
                              value: 'Kyoto', child: Text('Kyoto')),
                          DropdownMenuItem(value: 'Kobe', child: Text('Kobe')),
                          DropdownMenuItem(
                              value: 'Osaka', child: Text('Osaka')),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFF28527A)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(360),
                ))),
            icon: const Icon(Icons.swap_vert, color: Colors.white),
            onPressed: () {
              setState(() {
                var to2 = widget.to.value;
                widget.to.value = widget.from.value;
                widget.from.value = to2;
              });
            },
          )
        ],
      ),
    );
  }
}
