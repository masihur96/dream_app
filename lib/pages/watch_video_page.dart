import 'package:dream_app/controller/advertisement_controller.dart';
import 'package:dream_app/controller/user_controller.dart';
import 'package:dream_app/variables/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class WatchVideo extends StatefulWidget {
  @override
  _WatchVideoState createState() => _WatchVideoState();
}

class _WatchVideoState extends State<WatchVideo> {
  VideoPlayerController? _controller;
  int _currentVideoIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getVideoURLsAndPlay();
  }

  @override
  void dispose() {
    _controller!.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.dispose();
  }

  getVideoURLsAndPlay() async {
    final AdvertisementController advertisement = Get.find();

    SharedPreferences preference = await SharedPreferences.getInstance();
    var id = preference.get('id');
    List<String> videoUrlList = [];
    advertisement.getSingleUserData(id.toString()).then((value) async {
      String currentDate =
          '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
      print(advertisement.watchDate);
      print(currentDate);

      for (var i = 0; i < advertisement.videoList.length; i++) {
        videoUrlList.add(advertisement.videoList[i].videoUrl!);
      }

      print("Video URLs: ${videoUrlList.length}");
      if (currentDate != advertisement.watchDate) {
        _showDialog(
            title: 'Watched video and get Money ',
            subTitle:
                ' You will get 1 TK to watch every video. And you can watch 5 videos per day.\nEach day you get 5 videos to watch.');
        _playNextVideo(videoUrlList: videoUrlList);
      } else {
        _showDialog(
            title: "You have no videos to watch today.",
            subTitle:
                ' You will get 1 TK to watch every video. And you can watch 5 videos per day.\nEach day you get 5 videos to watch.');
      }
    });
  }

  void _playNextVideo({required List<String> videoUrlList}) async {
    if (_currentVideoIndex < videoUrlList.length) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrlList[_currentVideoIndex]),
      );

      _controller!.addListener(() {
        // Check if the video has ended
        if (_controller!.value.isInitialized &&
            !_controller!.value.isPlaying &&
            _controller!.value.position >= _controller!.value.duration) {
          // Prevent multiple executions
          if (_currentVideoIndex < videoUrlList.length) {
            setState(() {
              _currentVideoIndex++;
              _playNextVideo(videoUrlList: videoUrlList);
            });
          } else {
            _onAllVideosFinished(_currentVideoIndex);
          }
        }
      });

      // Initialize and play the video
      await _controller!.initialize();
      setState(() {});
      _controller!.play();
    }
  }

  void _onAllVideosFinished(int videoCount) {
    _currentVideoIndex++;
    final AdvertisementController advertisement = Get.find();
    final UserController userController = Get.find();
    print("All videos have finished playing!: $videoCount ");

    advertisement.updateAddAmount(userController, videoCount);
    // Call your function here when all videos have finished playing
    print("All videos have finished playing!");
  }

  _showDialog({required String title, required String subTitle}) {
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              backgroundColor: Colors.white,
              scrollable: true,
              contentPadding: EdgeInsets.all(20),
              title: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .030,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '** ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.orange),
                      ),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: kPrimaryColor,
                            fontSize: MediaQuery.of(context).size.width * .040),
                      ),
                      Text(
                        '**',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.orange,
                            fontSize: MediaQuery.of(context).size.width * .040),
                      ),
                    ],
                  ),
                  Text(
                    subTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: kPrimaryColor,
                        fontSize: MediaQuery.of(context).size.width * .040),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .050,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final UserController userController = Get.find();

    return GetBuilder<AdvertisementController>(builder: (advertisement) {
      return Scaffold(
        body: _bodyUI(size, advertisement, userController),
      );
    });
  }

  Widget _bodyUI(Size size, AdvertisementController advertisement,
          UserController userController) =>
      Stack(
        children: <Widget>[
          _isLoading
              ? Center(
                  child: Padding(
                  padding: EdgeInsets.only(top: size.width * .3),
                  child: CircularProgressIndicator(),
                ))
              : advertisement.videoList.isEmpty
                  ? const Center(
                      child: Padding(
                      padding: EdgeInsets.only(top: 58.0),
                      child: Text("Video Player is Empty"),
                    ))
                  : Container(),
          Center(
            child: _controller != null
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: Center(
                        child: VideoPlayer(
                      _controller!,
                    )),
                  )
                : Container(),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Text(
                  'Video watched: $_currentVideoIndex /${advertisement.videoList.length}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  'Today Earn: $_currentVideoIndex TK',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          )
        ],
      );
}
