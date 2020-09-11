library flutter_ff_contact_avatar;

import 'package:flutter/material.dart';
import 'dart:math' show min;

import 'ff_contact_avatar_model.dart';
import 'package:ff_contact_avatar_remake/ff-contact-avatar-theme.dart';

export 'package:ff_contact_avatar_remake/ff_contact_avatar_list.dart';
export 'package:ff_contact_avatar_remake/ff-contact-avatar-theme.dart';
export 'ff_contact_avatar_model.dart';

// ignore: must_be_immutable
class FFContactAvatar extends StatelessWidget {
  Image image;
  String name;
  String message;
  bool showBadge, showInitial, showLoading;
  final FFContactAvatarModel model;
  final VoidCallback onTap;

  FFContactAvatarTheme theme;

  FFContactAvatar({
    FFContactAvatarTheme theme,
    this.model,
    this.image,
    this.name,
    this.message,
    this.showBadge = false,
    this.onTap,
    this.showInitial = true,
    this.showLoading = false,
  }) {
    this.theme = (theme == null) ? FFContactAvatarTheme.defaultTheme : theme;

    if (model != null) {
      this.image = model.image;
      this.name = model.name;
      this.message = model.message;
      this.showBadge = model.showBadge;
    }
  }

  String _getInitials() {
    var nameParts = name.split(" ").map((elem) {
      return elem[0];
    });

    if (nameParts.length == 0) {
      return "";
    }

    int numberOfParts = min(2, nameParts.length);
    return nameParts.join().substring(0, numberOfParts);
  }

  CircleAvatar _makeImageAvatar() {
    if (this.showLoading)
      return CircleAvatar(
        radius: theme.avatarRadius,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(theme.avatarRadius),
          child: CircularProgressIndicator(backgroundColor: theme.foregroundColor),
        ),
      );
    else
      return CircleAvatar(
        radius: theme.avatarRadius,
        backgroundImage: this.image.image,
      );
  }

  CircleAvatar _makeInitialsAvatar() {
    return CircleAvatar(
      radius: theme.avatarRadius,
      child: Text(
        _getInitials(),
        style: theme.initialsTextStyle,
      ),
      backgroundColor: theme.backgroundColor,
      foregroundColor: theme.foregroundColor,
    );
  }

  Widget _makeCircleAvatar() {
    CircleAvatar ca = ((image != null && !this.showInitial) || this.showLoading)
        ? _makeImageAvatar()
        : _makeInitialsAvatar();

    Color badgeColor = showBadge ? theme.badgeColor : Colors.transparent;

    return GestureDetector(
      onTap: this.onTap,
      child: Material(
        elevation: theme.avatarElevation,
        borderRadius: BorderRadius.circular(theme.avatarRadius),
        child: Stack(
          children: <Widget>[
            ca,
            Positioned(
              top: 1,
              right: 1,
              width: 16,
              height: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _makePadding() {
    return SizedBox(
      height: theme.verticalPadding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _makeCircleAvatar(),
        _makePadding(),
        Text(
          name,
          style: theme.nameTextStyle,
        ),
        _makePadding(),
        Text(
          message,
          style: theme.messageTextStyle,
        ),
      ],
    );
  }
}
