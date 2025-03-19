import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String timeAgo(DateTime dateTime) {
   Duration difference = DateTime.now().difference(dateTime);

  if (difference.inDays < 7) {
    if (difference.inSeconds < 60) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else {
     return "${difference.inDays} days ago";
    }
  } else {
    return DateFormat('dd/MM/yy').format(dateTime);
  }
}



Widget myCircularProgressBar(){
  return CircularProgressIndicator.adaptive();
}
  