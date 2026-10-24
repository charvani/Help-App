import 'dart:convert';

import 'package:get/get.dart';
import 'package:help_app_flutter/commons/api_services.dart';
import 'package:help_app_flutter/model/homescreendata_model.dart';

import '../commons/common_functions.dart';
import '../commons/constants.dart';
import '../model/category_model.dart';
import '../model/categorypost_model.dart';
import '../model/homesearch_model.dart';
import '../model/myposts_model.dart';
import '../model/myprofile_model.dart';
import '../model/notification_model.dart';
import '../model/subscription_model.dart';

class MainController extends GetxController {
  RxBool isloading = false.obs;
  final RxString _logo = "".obs;
  final RxList<dynamic> _onboard = <dynamic>[].obs;
  final RxList<HomeSearchModel> _search = <HomeSearchModel>[].obs;
  final RxList<CategoryModel> _categories = <CategoryModel>[].obs;
  final Rx<HomeScreenDataModel> _homedata = HomeScreenDataModel(
          banners: [], categories: [], recentPost: [], notification: false)
      .obs;
  final RxList<CategoryPostModel> _categoriesposts = <CategoryPostModel>[].obs;
  final RxList<MyPostModel> _myPosts = <MyPostModel>[].obs;
  final RxString _cmsString = "".obs;
  final RxString _youtubeInfoString = "".obs;
  final Rx<SubscriptionModel> _subscriptionData = SubscriptionModel(
      status: "",
      paymentType: "",
      data: Data(
          id: "",
          packageTitle: "",
          packagePrice: "",
          billingType: "",
          noOfPosts: "",
          renwal: "",
          expiryDate: ""),
      packs: Packs(status: "", text: "", message: "", data: [])).obs;

  final Rx<MyProfileModel> _profileDetails = MyProfileModel(
          notification: false,
          id: "",
          accessToken: "",
          name: "",
          email: "",
          mobile: "",
          gender: "",
          city: "",
          image: "",
          fullImage: "")
      .obs;
  final RxList<NotificationModel> _notifications = <NotificationModel>[].obs;

  clearFun(List<dynamic> list) {
    list.clear();
  }

  getLogoFun() async {
    isloading.value = true;

    dynamic res = await Services().postMethod("", logoUrl);
    isloading.value = false;

    return res;
  }

  getOnboardFun() async {
    isloading.value = true;
    dynamic res = await Services().postMethod("", onboardUrl);
    _onboard.value = res['data'];
    isloading.value = false;
  }

  List<dynamic> get getOnboard => _onboard;

  getSigninFun(mapdata) async {
    isloading.value = true;
    dynamic res = await Services().postMethod(mapdata, signinUrl);
    isloading.value = false;
    return res;
  }

  getSignupFun(mapdata) async {
    isloading.value = true;
    dynamic res = await Services().postMethod(mapdata, signupUrl);
    isloading.value = false;
    return res;
  }

  getOtpVerifyFun(mapdata, url) async {
    isloading.value = true;
    dynamic res = await Services().postMethod(mapdata, url);
    isloading.value = false;
    return res;
  }

  getResendOtpFun(mapdata) async {
    isloading.value = true;
    dynamic res = await Services().postMethod(mapdata, resendUrl);
    isloading.value = false;
    return res;
  }

  getHomeSearchFun(loading, mapdata) async {
    if (loading) {
      isloading.value = loading;
    }
    dynamic res = await Services().postMethod(mapdata, searchUrl);
    clearFun(_search);

    if (res['status'] == "valid") {
      res['data'].forEach((e) {
        _search.add(HomeSearchModel.fromJson(e));
      });
    }
    isloading.value = !loading;
  }

  List<HomeSearchModel> get getHomeSearch => _search;

  getAllCategoriesFun(String from) async {
    if (from == "init") {
      isloading.value = true;
    }
    dynamic res = await Services().postMethod("", categorUrl);
    clearFun(_categories);
    if (res['status'] == "valid") {
      res['data'].forEach((e) {
        _categories.add(CategoryModel.fromJson(e));
      });
    } else {
      toastMesg(res['message'], false);
    }
    isloading.value = false;
    return res;
  }

  List<CategoryModel> get getAllCategories => _categories;

  getHomeScreenDatatFun(from, mapdata) async {
    if (from == "init") {
      isloading.value = true;
    }
    dynamic res = await Services().postMethod(mapdata, homeScreenDataUrl);
    if (res['status'] == "valid") {
      print("respose data");
      print(jsonEncode(res['data']));
      _homedata.value = HomeScreenDataModel.fromJson(res['data']);
    } else {
      toastMesg(res['message'], false);
    }
    isloading.value = false;
    return res;
  }

  HomeScreenDataModel get getHomeScreenData => _homedata.value;

  getCategoriesPostsFun(String from, int start, mapdata) async {
    if (from == "init") {
      isloading.value = true;
    }
    dynamic res = await Services().postMethod(mapdata, categoryPostsUrl);
    if (start == 0) {
      clearFun(_categoriesposts);
    }
    if (res['status'] == "valid") {
      res['data'].forEach((e) {
        _categoriesposts.add(CategoryPostModel.fromJson(e));
      });
    } else {
      toastMesg(res['message'], false);
    }
    isloading.value = false;
  }

  List<CategoryPostModel> get getCategoriesPosts => _categoriesposts;

  getEnquiryFun(mapdata) async {
    isloading.value = true;
    dynamic res = await Services().postMethod(mapdata, enquiryUrl);
    isloading.value = false;
    return res;
  }

  getPostViewFun(mapdata) async {
    isloading.value = true;
    dynamic res = await Services().postMethod(mapdata, postViewurl);
    isloading.value = false;
    return res;
  }

  getImageUploadFun(imagepath, from) async {
    dynamic res = await Services().imageUploadServic(imagepath, from);
    return res;
  }

  getProfileImageUploadFun(mapdata) async {
    dynamic res = await Services().postMethod(mapdata, profileImageUrl);
    Map pdata = {
      "customer_id": Constants.prefs!.getString("user_id"),
    };
    getMyProfileFun("init", pdata);
    return res;
  }

  getAddPostFun(mapdata) async {
    isloading.value = true;
    dynamic res = await Services().postMethod(mapdata, addPosturl);
    isloading.value = false;
    return res;
  }

  getEditPostFun(mapdata) async {
    dynamic res = await Services().postMethod(mapdata, editPosturl);
    return res;
  }

  getDeletePostFun(mapdata) async {
    dynamic res = await Services().postMethod(mapdata, deletePosturl);
    return res;
  }

  getSubscriptionFun(mapdata) async {
    isloading.value = true;
    dynamic res = await Services().postMethod(mapdata, subscriptionUrl);
    _subscriptionData.value = SubscriptionModel.fromJson(res);
    isloading.value = false;
  }

  SubscriptionModel get getSubscriptionData => _subscriptionData.value;

  getPaymentInitiateFun(mapdata) async {
    dynamic res = await Services().postMethod(mapdata, paymentInitiateUrl);
    return res;
  }

  getPaymentSuccessFun(mapdata) async {
    isloading.value = true;
    dynamic res = await Services().postMethod(mapdata, paymentSuccessUrl);
    isloading.value = false;
    return res;
  }

  getMyPostsFun(String from, int start, mapdata) async {
    if (from == "init") {
      isloading.value = true;
    }
    dynamic res = await Services().postMethod(mapdata, myPostsUrl);
    if (start == 0) {
      clearFun(_myPosts);
    }
    if (res['status'] == "valid") {
      res['data'].forEach((e) {
        _myPosts.add(MyPostModel.fromJson(e));
      });
    } else {
      // toastMesg(res['title'], false);
    }
    isloading.value = false;
    return res;
  }

  List<MyPostModel> get getMyPosts => _myPosts;

  getMyProfileFun(from, mapdata) async {
    isloading.value = true;
    dynamic res = await Services().postMethod(mapdata, myProfileUrl);
    _profileDetails.value = MyProfileModel.fromJson(res['data']);

    isloading.value = false;
  }

  MyProfileModel get getProfileData => _profileDetails.value;
  getProfileUpdateFun(mapdata) async {
    isloading.value = true;
    dynamic res = await Services().postMethod(mapdata, myProfileUpdateUrl);

    Map pdata = {
      "customer_id": Constants.prefs!.getString("user_id"),
    };
    getMyProfileFun("init", pdata);
    isloading.value = false;

    return res;
  }

  getCmsFun(url) async {
    isloading.value = true;
    dynamic res = await Services().postMethod("", url);
    if (res['status'] == true) {
      _cmsString.value = res['data']['description'];
    }
    isloading.value = false;
  }

  String get getCmsData => _cmsString.value;

  getSupportFun() async {
    isloading.value = true;

    dynamic res = await Services().postMethod("", mySupportUrl);
    isloading.value = false;

    return res;
  }

  getLogOutFun(mapdata) async {
    dynamic res = await Services().postMethod(mapdata, logoutUrl);

    return res;
  }

  getAccountDeleteFun(mapdata) async {
    dynamic res = await Services().postMethod(mapdata, accountDeleteUrl);
    return res;
  }

  getUpdateTokenFun(
    mapdata,
  ) async {
    dynamic res = await Services().postMethod(mapdata, updateTokenUrl);
    return res;
  }

  getNotificationsFun(String from, int start, mapdata) async {
    if (from == "init") {
      isloading.value = true;
    }
    dynamic res = await Services().postMethod(mapdata, notificationUrl);

    if (start == 0) {
      clearFun(_notifications);
    }
    if (res['status'] == "valid") {
      res['data'].forEach((e) {
        _notifications.add(NotificationModel.fromJson(e));
      });
    }
    isloading.value = false;
  }

  List<NotificationModel> get getNotifications => _notifications;

  getNotificationReadFun(mapdata, from) async {
    dynamic res = await Services().postMethod(mapdata, readNotificationUrl);
    if (from == "profile") {
      Map mapdata = {
        "customer_id": Constants.prefs!.getString("user_id"),
      };
      getMyProfileFun("init", mapdata);
    } else if (from == "home") {
      Map mapdata = {"mobile": Constants.prefs!.getString("mobile")};
      getHomeScreenDatatFun("init", mapdata);
    }
    return res;
  }

  getClearNotificationFun(mapdata) async {
    dynamic res = await Services().postMethod(mapdata, clearNotificationUrl);
    return res;
  }

  // getVersionCheckFun(mapdata) async {
  //   print("my mapdata........$mapdata");
  //   dynamic result = await Services().postMethod(mapdata, versionCheckUrl);
  //   print("my res.....$result");
  //   return result;
  // }

  getYoutubeInfo() async {
    isloading.value = true;
    dynamic res = await Services().postMethod("", youtubeInfoUrl);
    if (res['status'] == true) {
      _youtubeInfoString.value = res['data']['description'];
    }
    isloading.value = false;
  }

  String get getYoutubeInformation => _youtubeInfoString.value;

  getUpiInitiateFun(mapdata) async {
    dynamic res = await Services().postMethod(mapdata, upiInitateUrl);
    return res;
  }

  getLoadingPaymentStatusCheckingFun(mapdata) async {
    dynamic res = await Services().postMethod(mapdata, statusUpiCheckingUrl);
    return res;
  }
}
