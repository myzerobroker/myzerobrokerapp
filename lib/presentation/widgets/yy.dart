import 'package:flutter/material.dart';
import 'package:my_zero_broker/presentation/widgets/xx.dart';

class ParticlesSpark extends StatefulWidget {
  const ParticlesSpark({Key? key}) : super(key: key);

  @override
  State<ParticlesSpark> createState() => _ParticlesDemoState();
}

class _ParticlesDemoState extends State<ParticlesSpark> {


  @override
  Widget build(BuildContext context) {
      final height = MediaQuery.of(context).size.height;
    return Container(
      height: height, // Set a fixed height for the widget
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: const Stack(
          children: [
            Positioned.fill(
              child: RisingParticles(
                quantity: 20,
                maxSize: 8,
                minSize: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
