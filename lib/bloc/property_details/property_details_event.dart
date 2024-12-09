import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class PropertyEvent extends Equatable {
  const PropertyEvent();

  @override
  List<Object> get props => [];
}

class TitleChanged extends PropertyEvent {
  final String title;

  const TitleChanged({required this.title});

  @override
  List<Object> get props => [title];
}

class DescriptionChanged extends PropertyEvent {
  final String description;

  const DescriptionChanged({required this.description});

  @override
  List<Object> get props => [description];
}

class PriceChanged extends PropertyEvent {
  final double price;

  const PriceChanged({required this.price});

  @override
  List<Object> get props => [price];
}

class PhotosChanged extends PropertyEvent {
  final List<File> photos;

  const PhotosChanged({required this.photos});

  @override
  List<Object> get props => [photos];
}

class SubmitProperty extends PropertyEvent {}
