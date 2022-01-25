import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/data/models/animal.dart';
import 'package:rescado/src/data/models/card_data.dart';
import 'package:rescado/src/services/controllers/card_controller.dart';
import 'package:rescado/src/services/controllers/settings_controller.dart';
import 'package:rescado/src/views/buttons/floating_button.dart';
import 'package:rescado/src/views/misc/animated_logo.dart';

// Stack of cards the user can swipe left or right
class SwipeableStack extends StatelessWidget {
  final cardWidth = 300.0; // Preferred width of a card
  final cardHeight = 440.0; // Preferred height of a card
  final scales = [1.0, 1.0, 0.93, 0.86]; // Factor each card should be multiplied by to create illusion of depth
  final margins = [0.0, 0.0, 28.0, 52.0]; // Distance each card should be from the top, top card to bottom card

  SwipeableStack({
    Key? key,
  }) : super(key: key);

  double _scale([int index = 0]) => scales.length <= index ? scales.last : scales[index];

  double _margin([int index = 0]) => margins.length <= index ? margins.last : margins[index];

  @override
  Widget build(BuildContext context) => Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final maxWidth = MediaQuery.of(context).size.width * .9;
          final actualWidth = cardWidth > maxWidth ? maxWidth : cardWidth; // If card won't fit its parent, make it 90% of the parent's width

          return ref.watch(cardControllerProvider).when(
                data: (CardData cardData) => Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    if (cardData.animals.length >= 4) _buildCard(context, ref, actualWidth, cardHeight, cardData.animals[3], 3),
                    if (cardData.animals.length >= 3) _buildCard(context, ref, actualWidth, cardHeight, cardData.animals[2], 2),
                    if (cardData.animals.length >= 2) _buildCard(context, ref, actualWidth, cardHeight, cardData.animals[1], 1),
                    _makeInteractable(context, ref, _buildCard(context, ref, actualWidth, cardHeight, cardData.animals[0], 0)),
                  ],
                ),
                // TODO properly implement error (to be thrown if no cards left or no filter matches too) and loading
                error: (_, __) => const Text('error!!'),
                loading: () => const SizedBox(
                  width: 50.0,
                  child: AnimatedLogo(),
                ),
              );
        },
      );

  Widget _buildCard(BuildContext context, WidgetRef ref, double width, double height, Animal animal, int index) => Center(
        // The actual card
        child: AnimatedContainer(
          // Duration.zero disables pop down animation but works because top card animation is fast enough to hide that there is no animation
          duration: ref.watch(cardControllerProvider).value!.shouldPopUp ? const Duration(milliseconds: 500) : Duration.zero,
          curve: Curves.fastOutSlowIn,
          width: width,
          height: height,
          padding: const EdgeInsets.all(10.0),
          transform: ref.watch(cardControllerProvider).value!.shouldPopUp
              ? (Matrix4.identity()
                ..translate((width - width * _scale(index)) / 2, (height - height * _scale(index)) / 2 + _margin(index))
                ..scale(_scale(index)))
              : (Matrix4.identity()
                ..translate((width - width * _scale(index + 1)) / 2, (height - height * _scale(index + 1)) / 2 + _margin(index + 1))
                ..scale(_scale(index + 1))),
          decoration: BoxDecoration(
            color: ref.watch(settingsControllerProvider).activeTheme.backgroundVariantColor,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: const [
              BoxShadow(
                // TODO we perhaps want to extract this BoxDecoration if we want to reuse it for modal popups in the future
                offset: Offset(0, 5),
                blurRadius: 15.0,
                spreadRadius: 1.0,
                color: Color(0x1A000000),
              )
            ],
          ),
          // The contents of the card
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // The photo at the top
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: GestureDetector(
                    onTap: () => print('clicked the photo'), // ignore: avoid_print
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          animal.photos[0].reference,
                          fit: BoxFit.cover,
                        ),
                        // Shadowbox at the bottom with name and breed
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            height: 150.0,
                            padding: const EdgeInsets.all(20.0),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Color(0x00000000),
                                  Color(0x90000000),
                                  Color(0x90000000),
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  animal.name,
                                  style: const TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  animal.breed,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // Skip/like buttons at the bottom
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FloatingButton(
                      color: const Color(0xFFEE575F),
                      size: FloatingButtonSize.big,
                      svgAsset: RescadoConstants.iconCross,
                      semanticsLabel: AppLocalizations.of(context)!.labelSkip,
                      onPressed: () => ref.read(cardControllerProvider.notifier).swipeLeft(),
                    ),
                    FloatingButton(
                      color: const Color(0xFFEE575F),
                      size: FloatingButtonSize.big,
                      svgAsset: RescadoConstants.iconHeartOutline,
                      semanticsLabel: AppLocalizations.of(context)!.labelLike,
                      onPressed: () => ref.read(cardControllerProvider.notifier).swipeRight(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  // Builds the front card, which is a regular card, but draggable.
  Widget _makeInteractable(BuildContext context, WidgetRef ref, Widget card) => LayoutBuilder(
        builder: (_, constraints) {
          // need LayoutBuilder to know the center of the widget for rotation/tilting the card
          final center = constraints.biggest.center(Offset.zero);
          ref.read(cardControllerProvider.notifier).cacheBoxWidth(constraints.biggest.width);

          return GestureDetector(
            onPanStart: (_) => ref.read(cardControllerProvider.notifier).startDragging(),
            onPanUpdate: (DragUpdateDetails dragUpdateDetails) => ref.read(cardControllerProvider.notifier).handleDragging(dragUpdateDetails),
            onPanEnd: (_) => ref.read(cardControllerProvider.notifier).endDragging(),
            child: AnimatedContainer(
              duration: ref.watch(cardControllerProvider).value!.shouldAnimate ? RescadoConstants.swipeableCardAnimationDuration : Duration.zero,
              curve: ref.watch(cardControllerProvider).value!.isDraggable ? Curves.easeOutBack : Curves.linear,
              transform: Matrix4.identity()
                ..translate(center.dx, center.dy) // rotate around center
                ..rotateZ(ref.watch(cardControllerProvider).value!.angle) // rotate around center
                ..translate(-center.dx, -center.dy) // rotate around center
                ..translate(ref.watch(cardControllerProvider).value!.offset.dx, ref.watch(cardControllerProvider).value!.offset.dy), // translate the dragged offset
              child: card,
            ),
          );
        },
      );
}