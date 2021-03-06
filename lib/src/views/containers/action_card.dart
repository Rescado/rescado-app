import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rescado/src/constants/rescado_constants.dart';
import 'package:rescado/src/views/buttons/action_button.dart';

// Card that looks like a modal popup, but because it isn't, won't block other parts of the screen. Displays a title and a body, and optionally an SVG and/or action button.
class ActionCard extends StatefulWidget {
  final String title;
  final String body;
  final String? svgAsset;
  final ActionButton? actionButton;
  final bool animated;

  final double _padding = 16.0;

  const ActionCard({
    Key? key,
    required this.title,
    required this.body,
    this.svgAsset,
    this.actionButton,
    required this.animated,
  }) : super(key: key);

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animated ? 750 : 0),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) => FadeScaleTransition(
        animation: _animationController,
        child: child,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          width: 320.0,
          // This is max width because of Card (I think). Scales nicely.
          padding: EdgeInsets.only(top: widget._padding, left: widget._padding, right: widget._padding),
          // SVG needs to hit the bottom of the card
          child: Column(
            mainAxisSize: MainAxisSize.min, // Don't stretch the parent container vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Centers title (everything below is expanded)
            children: [
              Text(
                widget.title,
                style: RescadoConstants.actionLabel,
              ),
              _buildBody(context),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the "body" below the title. Renders text and, if provided an SVG, renders the SVG on its left.
  Widget _buildBody(BuildContext context) {
    if (widget.svgAsset == null) {
      return _buildContent(context);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end, // Glues SVG and body with button to the bottom
      children: [
        SvgPicture.asset(
          widget.svgAsset!,
          width: 90.0,
        ),
        Expanded(
          // Take up all the remaining space to the right of the SVG
          child: _buildContent(context),
        ),
      ],
    );
  }

  // Builds the actual text content that is shown in the card. If an action button is provided, renders it as well.
  Widget _buildContent(BuildContext context) {
    if (widget.actionButton == null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: widget._padding),
        child: Text(
          widget.body,
          style: RescadoConstants.actionLabel,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns the action body to the left (to align text left if not wrapping)
      children: [
        Padding(
          padding: EdgeInsets.only(top: widget._padding, left: widget._padding, bottom: widget._padding),
          child: Text(widget.body),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: widget.actionButton!,
        ),
        SizedBox(
          height: widget._padding, // To compensate for no bottom padding on the container
        )
      ],
    );
  }
}
