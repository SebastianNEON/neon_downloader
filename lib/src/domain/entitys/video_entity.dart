import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  final String? id;
  final String? videoUrl;
  final String? vidioPath;
  final String? imgUrl;
  final String? imgPath; // not implemented yet
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final DateTime? deleteAt;
  final Duration? lastPosition;

  const VideoEntity({
    this.id,
    this.videoUrl,
    this.vidioPath,
    this.imgUrl,
    this.imgPath,
    this.updatedAt,
    this.createdAt,
    this.deleteAt,
    this.lastPosition,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['videoUrl'] = videoUrl;
    map['vidioPath'] = vidioPath;
    map['imgUrl'] = imgUrl;
    map['imgPath'] = imgPath;
    map['updatedAt'] = updatedAt;
    map['createdAt'] = createdAt;
    map['deleteAt'] = deleteAt;
    map['lastPosition'] = lastPosition;

    return map;
  }

  factory VideoEntity.fromJson(dynamic json) {
    return VideoEntity(
      id: json['id'],
      videoUrl: json['videoUrl'],
      vidioPath: json['vidioPath'],
      imgUrl: json['imgUrl'],
      imgPath: json['imgPath'],
      updatedAt: json['updatedAt'],
      createdAt: json['createdAt'],
      deleteAt: json['deleteAt'],
      lastPosition: json['lastPosition'],
    );
  }

  VideoEntity copyWith({
    String? id,
    String? videoUrl,
    String? vidioPath,
    String? imgUrl,
    String? imgPath,
    DateTime? updatedAt,
    DateTime? createdAt,
    DateTime? deleteAt,
    Duration? lastPosition,
  }) {
    return VideoEntity(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      vidioPath: vidioPath ?? this.videoUrl,
      imgUrl: imgUrl ?? this.imgUrl,
      imgPath: imgPath ?? this.imgPath,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      deleteAt: deleteAt ?? this.deleteAt,
      lastPosition: lastPosition ?? this.lastPosition,
    );
  }

  @override
  List<Object?> get props => [
        id,
        videoUrl,
        vidioPath,
        imgUrl,
        imgPath,
        updatedAt,
        createdAt,
        deleteAt,
        lastPosition,
      ];
}
