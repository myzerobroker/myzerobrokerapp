import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:my_zero_broker/bloc/video/video_bloc.dart';
import 'package:my_zero_broker/utils/constant/theme.dart';
import 'package:video_player/video_player.dart';
// import 'video_bloc.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoBloc _videoBloc;
  List<VideoPlayerController> _controllers = [];
  int _currentIndex = 0;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _videoBloc = VideoBloc()..add(VideoFetch());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _videoBloc.close();
    super.dispose();
  }

  void _initializeControllers(List<String> videoUrls) {
    _controllers = videoUrls.map((url) {
      print("https://myzerobroker.com/public/storage" + url);
      final controller = VideoPlayerController.network(
          "https://myzerobroker.com/public/storage/$url");
      controller.initialize().then((_) {
        setState(() {});
        if (_controllers.indexOf(controller) == _currentIndex) {
          controller.pause();
        }
      });
      return controller;
    }).toList();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controllers[_currentIndex].value.isPlaying) {
        _controllers[_currentIndex].pause();
      } else {
        _controllers[_currentIndex].play();
      }
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controllers[_currentIndex].setVolume(_isMuted ? 0 : 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoBloc, VideoState>(
      bloc: _videoBloc,
      listener: (context, state) {
        if (state is VideoLoaded) {
          _initializeControllers(state.videoUrls);
        }
      },
      builder: (context, state) {
        if (state is VideoLoading) {
          return const Center(
              child: CircularProgressIndicator(
            color: ColorsPalette.primaryColor,
            strokeWidth: 1,
          ));
        } else if (state is VideoError) {
          return SizedBox.shrink();
        } else if (state is VideoLoaded && _controllers.isNotEmpty) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            margin: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              // color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    ColorsPalette.primaryColor.withOpacity(0.4) ?? Colors.white,
                width: 10,
              ),
            ),
            child: Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: _controllers.length,
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.shade400,
                      child: _controllers[index].value.isInitialized
                          ? AspectRatio(
                              aspectRatio:
                                  _controllers[index].value.aspectRatio,
                              child: VideoPlayer(_controllers[index]),
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                              color: ColorsPalette.primaryColor,
                              strokeWidth: 1,
                            )),
                    );
                  },
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _controllers[_currentIndex].pause();
                        _currentIndex = index;
                        _controllers[_currentIndex].play();
                        _controllers[_currentIndex].setVolume(_isMuted ? 0 : 1);
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ColorsPalette.secondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _togglePlayPause,
                          icon: Icon(
                            _controllers[_currentIndex].value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: _toggleMute,
                          icon: Icon(
                            _isMuted ? Icons.volume_off : Icons.volume_up,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
