import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(VideoInitial()) {
    on<VideoFetch>((event, emit) async {
      emit(VideoLoading());
      try {
        final response = await http
            .get(Uri.parse("https://myzerobroker.com/api/all-videos"));
        if (response.statusCode == 200) {
          final allVideos = jsonDecode(response.body)["videos"] as List;
          final videoUrls = allVideos.where((json)=> json["status"] == 1 
          ).map((json) => json["video_url"] as String).toList();
          print(videoUrls);          
          emit(VideoLoaded(videoUrls: videoUrls));

        }
      } catch (err) {
        emit(VideoError(error: err.toString()));
      }
    });
  }
}
