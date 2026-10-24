import 'package:get/get.dart';
import 'package:help_app_flutter/commons/common_functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../screens/authentication_screens/signin_screen.dart';
import 'constants.dart';

// String baseUrl = "https://colormoon.in/help_app/api/";
String baseUrl = "https://thehelpapp.in/api/";

String barrierToken = "api_key/generate_token";
String logoUrl = "onboarding_slider";
String onboardUrl = "onboarding_slider/welcome_sliders";
String signinUrl = "login";
String signupUrl = "register";
String signinOtpVerifyUrl = "register/login_verify_otp";
String signupOtpVerifyUrl = "register/register_verify_otp";
String resendUrl = "register/resend_otp";
String searchUrl = "Home_screen/search";
String categorUrl = "Post/categories";
String homeScreenDataUrl = "Home_screen";
String categoryPostsUrl = "Post/categories_posts";
String enquiryUrl = "Post/enquiry";
String postViewurl = "Post/details";
String imageUploadurl = "file_upload";
String addPosturl = "Post";
String editPosturl = "Post/edit";
String deletePosturl = "Post/delete";
String subscriptionUrl = "Home_screen/customer_pack";
String paymentInitiateUrl = "razorpay";
String paymentSuccessUrl = "razorpay/success";
String myPostsUrl = "Post/list";
String myProfileUrl = "Register/profile";
String myProfileUpdateUrl = "register/profile_update";
String aboutUrl = "Cms_content/about";
String termsAndConditionsUrl = "Cms_content/terms_and_conditions";
String privacyAndPolicyUrl = "Cms_content/privacy_policy";
String mySupportUrl = "Cms_content/support";
String accountDeleteUrl = "register/delete_account";
String logoutUrl = "Logout";
String updateTokenUrl = "Update_token";
String notificationUrl = "Notifications";
String readNotificationUrl = "Notifications/notification_seen";
String clearNotificationUrl = "Notifications/notification_clear";
String versionCheckUrl = "Home_screen/version";
String youtubeInfoUrl = "Cms_content/youtube_instructions";
String profileImageUrl = "register/profile_image_update";
String userStatusUrl = "register/customer_status";
String statusUpiCheckingUrl = "check_status";
String upiInitateUrl = "upi_gateway";

class BasicAuth {
  Future<void> jwtToken() async {
    Map<String, dynamic> bodyData = {
      'type': 'MOBILEAPP',
      'apikey': 'helpapp@cmoon',
      'pwd': '90f14f475030d65155d4fbcb50050739'
    };

    http.Response response =
        await http.post(Uri.parse(baseUrl + barrierToken), body: bodyData);

    if (response.statusCode == 200) {
      var result = convert.jsonDecode(response.body);
      if (result['status'] == 'valid') {
        Constants.jwtToken = result['data']['token'];
        // Constants.prefs?.setString('jwt_token', result['data']['token']);
      } else {
        print("Unable to gernerate jwt token please check charvani 1");
      }
    } else {
      print("Unable to gernerate jwt token please check charvani 2");
    }
  }
}

class Services {
  Future<dynamic> postMethod(bodyData, endUrl) async {
    dynamic result;
    if (Constants.prefs!.getString("access_token") != null) {
      activeUserCheckingFun();
    }

    if (Constants.jwtToken != null) {
      var response = await http.post(Uri.parse(baseUrl + endUrl),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            'Authorization': 'Bearer ${Constants.jwtToken}',
          },
          body: bodyData);
      if (response.statusCode == 200) {
        result = convert.jsonDecode(response.body);
      } else {
        print("getting wrong api status code 1");
      }
      return result;
    } else {
      BasicAuth().jwtToken();
      var response = await http.post(Uri.parse(baseUrl + endUrl),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            'Authorization': 'Bearer ${Constants.jwtToken}',
          },
          body: bodyData);
      if (response.statusCode == 200) {
        result = convert.jsonDecode(response.body);
      } else {
        print("getting wrong api status code 2 ");
      }
      return result;
    }
  }

  Future<dynamic> imageUploadServic(imgPath, from) async {
    if (Constants.prefs!.getString("access_token") != null) {
      activeUserCheckingFun();
    }

    dynamic result;
    print("res................$imgPath............$from");
    if (Constants.jwtToken != null) {
      var response =
          http.MultipartRequest('POST', Uri.parse(baseUrl + imageUploadurl));
      response.files
          .add(http.MultipartFile.fromString("upload_folder_name", from));
      response.files.add(
        await http.MultipartFile.fromPath('image', imgPath),
      );
      response.fields["title"] = "charvani";
      response.headers["Content-Type"] = "application/x-www-form-urlencoded";
      response.headers["Authorization"] = 'Bearer ${Constants.jwtToken}';
      var res = await response.send();

      var sresult = await http.Response.fromStream(res);
      if (sresult.statusCode == 200) {
        result = convert.jsonDecode(sresult.body);
      } else {
        print("image getting wrong api status code 1");
      }
      return result;
    } else {
      BasicAuth().jwtToken();

      var response =
          http.MultipartRequest('POST', Uri.parse(baseUrl + imageUploadurl));
      response.files.add(await http.MultipartFile.fromPath('image', imgPath));
      response.fields["title"] = "charvani";
      response.headers["Content-Type"] = "application/x-www-form-urlencoded";
      response.headers["Authorization"] = 'Bearer ${Constants.jwtToken}';
      var res = await response.send();
      var sresult = await http.Response.fromStream(res);
      if (sresult.statusCode == 200) {
        result = convert.jsonDecode(sresult.body);
      } else {
        print("image getting wrong api status code 2");
      }
      return result;
    }
  }

  activeUserCheckingFun() async {
    dynamic result;
    if (Constants.jwtToken != null) {
      var response =
          await http.post(Uri.parse(baseUrl + userStatusUrl), headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': 'Bearer ${Constants.jwtToken}',
      }, body: {
        "access_token": Constants.prefs!.getString("access_token")
      });
      if (response.statusCode == 200) {
        result = convert.jsonDecode(response.body);
        if (result['status'] != "valid") {
          toastMesg(result['message'], false);
          Get.offAll(() => const SigninScreen());
          Constants.prefs!.remove("device_token");
          Constants.prefs!.remove("login");
          Constants.prefs!.remove("mobile");
          Constants.prefs!.remove("mail");
          Constants.prefs!.remove("name");
          Constants.prefs!.remove("user_id");
          Constants.prefs!.remove("access_token");
        }
      } else {
        print("getting wrong api status code 1");
      }
    } else {
      BasicAuth().jwtToken();
      var response =
          await http.post(Uri.parse(baseUrl + userStatusUrl), headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': 'Bearer ${Constants.jwtToken}',
      }, body: {
        "access_token": Constants.prefs!.getString("access_token")
      });
      if (response.statusCode == 200) {
        result = convert.jsonDecode(response.body);
        if (result['status'] != "valid") {
          toastMesg(result['message'], false);
          Get.offAll(() => const SigninScreen());
          Constants.prefs!.remove("device_token");
          Constants.prefs!.remove("login");
          Constants.prefs!.remove("mobile");
          Constants.prefs!.remove("mail");
          Constants.prefs!.remove("name");
          Constants.prefs!.remove("user_id");
          Constants.prefs!.remove("access_token");
        }
      } else {
        print("getting wrong api status code 1");
      }
    }
  }
}
