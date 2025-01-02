import 'package:omt/http/service/camera/camera_configuration_service.dart';
import 'package:omt/http/service/fileService/fileService.dart';
import 'package:omt/http/service/user/user_login/user_login_service.dart';
import 'package:omt/http/service/home/home_page/home_page_service.dart';
import 'package:omt/http/service/video/video_configuration_service.dart';
import 'package:omt/http/service/one_picture/one_picture/one_picture_service.dart';

///ReplaceServiceImport

///
///  tfblue_app
///  HttpQuery.dart
///
///  Created by kayoxu on 2021/8/6 at 10:07 上午
///  Copyright © 2021 kayoxu. All rights reserved.
///

class HttpQuery {
  static HttpQuery get share => HttpQuery._share();

  static HttpQuery? _instance;

  factory HttpQuery._share() {
    _instance ??= HttpQuery._();
    return _instance!;
  }

  late FileService fileService;

  late UserLoginService userLoginService;
  late HomePageService homePageService;
  late VideoConfigurationService videoConfigurationService;
  late CameraConfigurationService cameraConfigurationService;

  late OnePictureService onePictureService;
  ///ReplaceServiceDefine

  HttpQuery._() {
    fileService = FileService();

    userLoginService = UserLoginService();
    homePageService = HomePageService();
    videoConfigurationService = VideoConfigurationService();
    cameraConfigurationService = CameraConfigurationService();

    onePictureService = OnePictureService();
    ///ReplaceServiceImplementation
  }
}
