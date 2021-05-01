// import 'package:json_annotation/json_annotation.dart';
// part 'site.g.dart';

// @JsonSerializable()
class Site {
  final String type;
  final String slotTime;
  final String siteName;
  final String link;

  Site(this.type, this.siteName, this.slotTime, this.link);
}
