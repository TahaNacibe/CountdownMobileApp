import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countdown_mobile/models/user_model.dart';
import 'package:flutter/foundation.dart';

class WaitCard {
  Timestamp createdAt;
  String description;
  String id;
  String image;
  String ownerId;
  String title;
  Timestamp waitToDate;
  List<String> waitingUsers;
  int waitingUsersCount;
  UserModel? ownerMetaData;
  List<UserModel>? waitingUsersMetaData;

  //* Constructor
  WaitCard({
    required this.createdAt,
    required this.description,
    required this.id,
    required this.image,
    required this.ownerId,
    required this.title,
    required this.waitToDate,
    required this.waitingUsers,
    required this.waitingUsersCount,
    this.ownerMetaData,
    this.waitingUsersMetaData
  });

  //* Copy With Method
  WaitCard copyWith({
    Timestamp? createdAt,
    String? description,
    String? id,
    String? image,
    String? ownerId,
    String? title,
    Timestamp? waitToDate,
    List<String>? waitingUsers,
    int? waitingUsersCount,
  }) {
    return WaitCard(
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      id: id ?? this.id,
      image: image ?? this.image,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      waitToDate: waitToDate ?? this.waitToDate,
      waitingUsers: waitingUsers ?? this.waitingUsers,
      waitingUsersCount: waitingUsersCount ?? this.waitingUsersCount,
    );
  }

  //* Convert Object to Map
  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'description': description,
      'id': id,
      'image': image,
      'ownerId': ownerId,
      'title': title,
      'waitToDate': waitToDate,
      'waitingUsers': waitingUsers,
      'waitingUsersCount': waitingUsersCount,
    };
  }

  //* Create Object from Map
  factory WaitCard.fromMap(Map<String, dynamic> map) {
    return WaitCard(
      createdAt: map['createdAt'] is Timestamp
          ? map['createdAt'] as Timestamp
          : Timestamp.fromMillisecondsSinceEpoch(map['createdAt']),
      description: map['description'] as String,
      id: map['id'] as String,
      image: map['image'] as String,
      ownerId: map['ownerId'] as String,
      title: map['title'] as String,
      waitToDate: map['waitToDate'] is Timestamp
          ? map['waitToDate'] as Timestamp
          : Timestamp.fromMillisecondsSinceEpoch(map['waitToDate']),
      waitingUsers: List<String>.from(map['waitingUsers'] as List<dynamic>),
      waitingUsersCount: map['waitingUsersCount'] as int,
      ownerMetaData: map["ownerMetaData"],
      waitingUsersMetaData: map["waitingUsersMetaData"]
    );
  }

  //* Convert Object to JSON
  String toJson() => json.encode(toMap());

  //* Create Object from JSON
  factory WaitCard.fromJson(String source) =>
      WaitCard.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WaitCard(createdAt: $createdAt, description: $description, id: $id, image: $image, ownerId: $ownerId, title: $title, waitToDate: $waitToDate, waitingUsers: $waitingUsers, waitingUsersCount: $waitingUsersCount)';
  }

  @override
  bool operator ==(covariant WaitCard other) {
    if (identical(this, other)) return true;

    return other.createdAt == createdAt &&
        other.description == description &&
        other.id == id &&
        other.image == image &&
        other.ownerId == ownerId &&
        other.title == title &&
        other.waitToDate == waitToDate &&
        listEquals(other.waitingUsers, waitingUsers) &&
        other.waitingUsersCount == waitingUsersCount;
  }

  @override
  int get hashCode {
    return createdAt.hashCode ^
        description.hashCode ^
        id.hashCode ^
        image.hashCode ^
        ownerId.hashCode ^
        title.hashCode ^
        waitToDate.hashCode ^
        waitingUsers.hashCode ^
        waitingUsersCount.hashCode;
  }
}
