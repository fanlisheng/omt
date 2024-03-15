import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';


class CameraPlayerMKTestWidget extends StatefulWidget {
  final String url;
  CameraPlayerMKTestWidget(this.url);

  @override
  CameraPlayerMKTestWidgetState createState() =>
      CameraPlayerMKTestWidgetState();
}

class CameraPlayerMKTestWidgetState extends State<CameraPlayerMKTestWidget> {
  final player = Player();
  int retryCount = 0;
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();

    startPlayer();
  }

  ///
  /// 开始播放
  ///
  void startPlayer() async {
    /// 以下配置为 mpv 底层配置
    if (controller.player.platform is NativePlayer) {
      // https://mpv.io/manual/master/#encoding
      var nativePlayer = controller.player.platform as NativePlayer;

      // 关闭音频输出 mpv 底层参数，测试在默认hdmi音频输出情况下是否受到其它音频播放影响
      await nativePlayer.setProperty('aid', 'no');
      // 缓存
      await nativePlayer.setProperty('cache', 'no');
      // 低延迟配置
      await nativePlayer.setProperty('profile', 'low-latency');
      // 可以减少图形驱动程序中的缓冲
      await nativePlayer.setProperty('opengl-glfinish', 'yes');
      // 倍速配置
      await nativePlayer.setProperty('speed', '1.5');
      // 立即输出帧配置，能解决延迟，但是画面不连贯
      await nativePlayer.setProperty('untimed', 'yes');
    }
    player.open(Media(widget.url));
  }

  /// 停止播放
  void stopPlayer() {
    print("MonitorPage.stopPlayer");
    player.stop();
    player.dispose();
  }

  @override
  void dispose() {
    stopPlayer();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AspectRatio(
        aspectRatio: 16.0 / 9.0,
        child: Video(
          controller: controller,
          // controls: NoVideoControls,
        ),
      ),
    );
  }
}