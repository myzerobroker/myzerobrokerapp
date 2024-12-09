import 'dart:io';

import 'package:equatable/equatable.dart';

enum PropertyFormStatus { initial, loading, success, error }

class PropertyState extends Equatable {
  final String title;
  final String description;
  final double price;
  final List<File> photos;
  final PropertyFormStatus status;
  final String message;

  const PropertyState({
    this.title = '',
    this.description = '',
    this.price = 0.0,
    this.photos = const [],
    this.status = PropertyFormStatus.initial,
    this.message = '',
  });

  PropertyState copyWith({
    String? title,
    String? description,
    double? price,
    List<File>? photos,
    PropertyFormStatus? status,
    String? message,
  }) {
    return PropertyState(
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      photos: photos ?? this.photos,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [title, description, price, photos, status, message];
}
