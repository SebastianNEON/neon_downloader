import 'package:equatable/equatable.dart';
import 'dart:convert';

class ConfigEntity extends Equatable {
  final Duration duration;
  final String token;

  const ConfigEntity({
    this.duration = const Duration(days: 30),
    this.token = '',
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['duration'] = duration.inDays;
    map['token'] = token;

    return map;
  }

  factory ConfigEntity.fromJson(dynamic data) {
    dynamic json = jsonDecode(data);
    return ConfigEntity(
      duration: Duration(days: json['duration'] as int),
      token: json['token'] as String,
    );
  }

  ConfigEntity copyWith({
    Duration? duration,
    String? token,
  }) {
    return ConfigEntity(
      duration: duration ?? this.duration,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [duration, token];
}
