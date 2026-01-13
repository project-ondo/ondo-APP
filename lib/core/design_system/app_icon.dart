enum AppIcon {
  star1,
  star2,
  star3,
  star4,
  star5,

  alarmBrown,
  alarmGrey,
  arrowLeft,
  bookmark,
  camera,
  check,
  checkOn,
  defaultProfile,
  heart,
  logo,
  message,
  plus,
  searchFocus,
  searchUnFocus,
  send,
  star,

  chatSelect,
  chatUnSelect,
  communitySelect,
  communityUnSelect,
  homeSelect,
  homeUnSelect,
  userSelect,
  userUnSelect,
}



extension AppIconPath on AppIcon {
  static const String _basePath = 'assets/image';

  String get path {
    switch (this) {
      case AppIcon.star1:
        return '$_basePath/star1.svg';
      case AppIcon.star2:
        return '$_basePath/star2.svg';
      case AppIcon.star3:
        return '$_basePath/star3.svg';
      case AppIcon.star4:
        return '$_basePath/star4.svg';
      case AppIcon.star5:
        return '$_basePath/star5.svg';

      case AppIcon.alarmBrown:
        return '$_basePath/alarm_brown.svg';
      case AppIcon.alarmGrey:
        return '$_basePath/alarm_grey.svg';
      case AppIcon.arrowLeft:
        return '$_basePath/arrow_left.svg';
      case AppIcon.bookmark:
        return '$_basePath/bookmark.png';
      case AppIcon.camera:
        return '$_basePath/camera.svg';
      case AppIcon.check:
        return '$_basePath/check.svg';
      case AppIcon.checkOn:
        return '$_basePath/check_on.svg';
      case AppIcon.defaultProfile:
        return '$_basePath/default_profile.svg';
      case AppIcon.heart:
        return '$_basePath/heart.png';
      case AppIcon.logo:
        return '$_basePath/logo.png';
      case AppIcon.message:
        return '$_basePath/message.png';
      case AppIcon.plus:
        return '$_basePath/plus.svg';
      case AppIcon.searchFocus:
        return '$_basePath/search_focus.svg';
      case AppIcon.searchUnFocus:
        return '$_basePath/search_unfocus.svg';
      case AppIcon.send:
        return '$_basePath/send.svg';
      case AppIcon.star:
        return '$_basePath/star.png';

      case AppIcon.chatSelect:
        return '$_basePath/bottombar/chat_select.svg';
      case AppIcon.chatUnSelect:
        return '$_basePath/bottombar/chat_unselect.svg';
      case AppIcon.communitySelect:
        return '$_basePath/bottombar/community_select.svg';
      case AppIcon.communityUnSelect:
        return '$_basePath/bottombar/community_unselect.svg';
      case AppIcon.homeSelect:
        return '$_basePath/bottombar/home_select.svg';
      case AppIcon.homeUnSelect:
        return '$_basePath/bottombar/home_unselect.svg';
      case AppIcon.userSelect:
        return '$_basePath/bottombar/user_select.svg';
      case AppIcon.userUnSelect:
        return '$_basePath/bottombar/user_unselect.svg';
    }
  }
}
