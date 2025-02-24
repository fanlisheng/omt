// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../page/home/device_add/view_models/device_add_viewmodel.dart';

abstract final class Routes {
  static const home = '/';
  static const login = '/login';
  static const deviceBind = '/device_bind';
  static const deviceDetail = '/device_detail';


  static const searchRelative = 'search';
  static const results = '/$resultsRelative';
  static const resultsRelative = 'results';
  static const activities = '/$activitiesRelative';
  static const activitiesRelative = 'activities';
  static const booking = '/$bookingRelative';
  static const bookingRelative = 'booking';
  static String bookingWithId(int id) => '$booking/$id';
}
