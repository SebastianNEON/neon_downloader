import 'package:equatable/equatable.dart';

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

  factory ConfigEntity.fromJson(dynamic json) {
    return ConfigEntity(
      duration: Duration(days: json['id']),
      token: json['token'],
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
