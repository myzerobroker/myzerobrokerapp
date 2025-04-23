part of 'video_bloc.dart';

sealed class VideoState extends Equatable {
  const VideoState();

  @override
  List<Object> get props => [];
}

final class VideoInitial extends VideoState {}

final class VideoLoading extends VideoState {}

final class VideoLoaded extends VideoState {
  final List<String> videoUrls;
  const VideoLoaded({required this.videoUrls});
}

final class VideoError extends VideoState {
  final String error;
  const VideoError({required this.error});
}
