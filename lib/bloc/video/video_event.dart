part of 'video_bloc.dart';

sealed class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object> get props => [];
}


final class VideoFetch extends VideoEvent {
  const VideoFetch();
}