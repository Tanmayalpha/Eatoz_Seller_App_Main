import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eshopmultivendor/Helper/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:eshopmultivendor/Helper/ApiBaseHelper.dart';
import 'package:eshopmultivendor/Helper/AppBtn.dart';
import 'package:eshopmultivendor/Helper/Color.dart';
import 'package:eshopmultivendor/Helper/Session.dart';
import 'package:eshopmultivendor/Helper/String.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StateProfile();
}

String? lat, long;

class StateProfile extends State<Profile> with TickerProviderStateMixin {
//==============================================================================
//========================== Variable Dectlaration =============================

  String? newAddressProof;

  String? name,
      email,
      mobile,
      address,
      image,
      curPass,
      newPass,
      adhar,
      confPass,
      loaction,
      accNo,
      storename,
      storeurl,
      storeDesc,
      accname,
      bankname,
      bankcode,
      latitutute,
      longitude,
      adharNumber,
      taxname,
      taxnumber,
      pannumber,
      status,
      storelogo,
      fssaiNumber;

  bool _isLoading = false;
  GlobalKey<FormState> sellernameKey = GlobalKey<FormState>();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  GlobalKey<FormState> addressKey = GlobalKey<FormState>();
  GlobalKey<FormState> storenameKey = GlobalKey<FormState>();
  GlobalKey<FormState> storeurlKey = GlobalKey<FormState>();
  GlobalKey<FormState> storeDescKey = GlobalKey<FormState>();
  GlobalKey<FormState> adharkey = GlobalKey<FormState>();
  GlobalKey<FormState> accnameKey = GlobalKey<FormState>();
  GlobalKey<FormState> accnumberKey = GlobalKey<FormState>();
  GlobalKey<FormState> bankcodeKey = GlobalKey<FormState>();
  GlobalKey<FormState> banknameKey = GlobalKey<FormState>();
  GlobalKey<FormState> latitututeKey = GlobalKey<FormState>();
  GlobalKey<FormState> longituteKey = GlobalKey<FormState>();
  GlobalKey<FormState> taxnameKey = GlobalKey<FormState>();
  GlobalKey<FormState> taxnumberKey = GlobalKey<FormState>();
  GlobalKey<FormState> pannumberKey = GlobalKey<FormState>();
  GlobalKey<FormState> fassaiKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController? nameC,
      emailC,
      mobileC,
      addressC,
      storenameC,
      storeurlC,
      storeDescC,
      accnameC,
      accnumberC,
      bankcodeC,
      banknameC,
      adharC,
      latitututeC,
      longituteC,
      taxnameC,
      taxnumberC,
      pannumberC,
      curPassC,
      newPassC,
      confPassC,
      fassaiC;

  bool isSelected = false, isArea = true;
  bool _isNetworkAvail = true;
  bool _showCurPassword = false, _showPassword = false, _showCmPassword = false;
  Animation? buttonSqueezeanimation;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  AnimationController? buttonController;

//==============================================================================
//============================= Init method ====================================

  File? addressProof;
  String? newAdhar;
  String? userfassai;

  /*_getFromGallery1() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        addressProof = File(pickedFile.path);
      });
      updateUserImage();
      Navigator.pop(context);
    }
  }*/

  /*_getFromCamera1() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        addressProof = File(pickedFile.path);
      });
      updateUserImage();
      Navigator.pop(context);
    }
  }*/

  @override
  void initState() {
    super.initState();

    mobileC = new TextEditingController();
    nameC = new TextEditingController();
    emailC = new TextEditingController();
    addressC = new TextEditingController();
    storenameC = new TextEditingController();
    storeurlC = new TextEditingController();
    storeDescC = new TextEditingController();
    accnameC = new TextEditingController();
    accnumberC = new TextEditingController();
    bankcodeC = new TextEditingController();
    adharC = new TextEditingController();
    banknameC = new TextEditingController();
    latitututeC = new TextEditingController();
    longituteC = new TextEditingController();
    taxnameC = new TextEditingController();
    pannumberC = new TextEditingController();
    taxnumberC = new TextEditingController();
    fassaiC = new TextEditingController();
    getUserDetails();

    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = new Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      new CurvedAnimation(
        parent: buttonController!,
        curve: new Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }
//==============================================================================
//============================= dispose method =================================

  @override
  void dispose() {
    buttonController!.dispose();
    mobileC?.dispose();
    nameC?.dispose();
    addressC!.dispose();
    emailC!.dispose();
    storenameC!.dispose();
    storeurlC!.dispose();
    storeDescC!.dispose();
    accnameC!.dispose();
    accnumberC!.dispose();
    bankcodeC!.dispose();
    adharC!.dispose();
    banknameC!.dispose();
    latitututeC!.dispose();
    longituteC!.dispose();
    taxnameC!.dispose();
    pannumberC!.dispose();
    taxnumberC!.dispose();
    fassaiC!.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

//==============================================================================
//================= User Details frome Shared Preferance =======================

  String? sellerProfile;

  getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sellerProfile = prefs.getString('profileImage');
    userfassai = prefs.getString('fassai_number');
    newAdhar = prefs.getString('adhar_no');
    fassaiC!.text = userfassai.toString();
    if (newAddressProof == null) {
      newAddressProof = prefs.getString('address_proof');
    }
    print("vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv ${getPrefrence(accountName)}");
    CUR_USERID = await getPrefrence(Id);
    mobile = await getPrefrence(Mobile);
    name = await getPrefrence(Username);
    email = await getPrefrence(Email);
    address = await getPrefrence(Address);
    image = await getPrefrence(IMage);
    CUR_USERID = await getPrefrence(Id);
    mobile = await getPrefrence(Mobile);
    storename = await getPrefrence(Storename);
    storeurl = await getPrefrence(Storeurl);
    storeDesc = await getPrefrence(storeDescription);
    accNo = await getPrefrence(accountNumber);
    accname = await getPrefrence(accountName);
    bankcode = await getPrefrence(bankCode);
    bankname = await getPrefrence(bankName);
    latitutute = await getPrefrence(Latitude);
    longitude = await getPrefrence(Longitude);
    adhar = await getPrefrence(Adhar);
    taxname = await getPrefrence(taxName);
    taxnumber = await getPrefrence(taxNumber);
    pannumber = await getPrefrence(panNumber);
    status = await getPrefrence(STATUS);
    userfassai = await getPrefrence('fassai_number');
    adharNumber= await getPrefrence(adharNo);

    storelogo = await getPrefrence(StoreLogo);
    mobileC!.text = mobile ?? "";
    nameC!.text = name ?? "";
    emailC!.text = email ?? "";
    addressC!.text = address ?? "";
    storenameC!.text = storename ?? "";
    storeurlC!.text = storeurl ?? "";
    storeDescC!.text = storeDesc ?? "";
    accnameC!.text = accname ?? "";
    accnumberC!.text = accNo ?? "";
    bankcodeC!.text = bankcode ?? "";
    banknameC!.text = bankname ?? "";
    latitututeC!.text = latitutute ?? "";
    longituteC!.text = longitude ?? "";
    taxnameC!.text = taxname ?? "";
    taxnumberC!.text = taxnumber ?? "";
    pannumberC!.text = pannumber ?? "";
    fassaiC!.text = userfassai ?? "";
    adharC!.text = adharNumber ?? "";

    setState(() {});
  }

//==============================================================================
//===================== noInternet Widget ======================================

  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            noIntImage(),
            noIntText(context),
            noIntDec(context),
            AppBtn(
              title: getTranslated(context, "TRY_AGAIN_INT_LBL")!,
              btnAnim: buttonSqueezeanimation,
              btnCntrl: buttonController,
              onBtnSelected: () async {
                _playAnimation();

                Future.delayed(
                  Duration(seconds: 2),
                ).then(
                  (_) async {
                    _isNetworkAvail = await isNetworkAvailable();
                    if (_isNetworkAvail) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => super.widget,
                        ),
                      );
                    } else {
                      await buttonController!.reverse();
                      setState(
                        () {},
                      );
                    }
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

//==============================================================================
//======================= For Form validate And Submit =========================

  // bool validateAndSave() {
  //   final form = _formKey.currentState!;
  //   if (form.validate()) {
  //     form.save();
  //     return true;
  //   }
  //   return false;
  // }

  // void validateAndSubmit() async {
  //   if (validateAndSave()) {
  //     checkNetwork();
  //   }
  // }

//==============================================================================
//========================= Network awailabilitry ==============================

  Future<void> checkNetwork() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      await buttonController!.reverse();
      setUpdateUser();
    } else {
      Future.delayed(Duration(seconds: 2)).then(
        (_) async {
          await buttonController!.reverse();
          setState(
            () {
              _isNetworkAvail = false;
            },
          );
        },
      );
    }
  }

  removePhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var headers = {
      'Cookie': 'ci_session=30340c3659794ddfea1de8a6c36e4ff608094004'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${baseUrl}remove_profile_image'));
    request.fields.addAll({'user_id': '${CUR_USERID}'});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResult = json.decode(finalResult);
      setState(() {
        prefs.setString('profileImage', "");
      });
      getUserDetails();
      Navigator.pop(context);
    } else {
      print(response.reasonPhrase);
    }
  }

  updateUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var headers = {
      'Cookie': 'ci_session=2d2a07a95eb9661f0454e55eb238cfe93cd20c3a'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse(baseUrl + 'update_image'));
    request.fields.addAll({'user_id': '${CUR_USERID}'});
    imageFile == null
        ? null
        : request.files.add(
            await http.MultipartFile.fromPath('image', '${imageFile!.path}'));

    request.headers.addAll(headers);
    print(
        "checking paramter here ${request.fields} and ${baseUrl + 'update_image'} ");
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResult);
      print("checking jsonResponse here now  of image${jsonResponse}");
      setState(() {
        prefs.setString(
            'profileImage', jsonResponse['data'][0]['image'].toString());
        LOGO = jsonResponse['data'][0]['image'].toString();
      });

      print("logo value is here now ${LOGO}");
    } else {
      print(response.reasonPhrase);
    }
  }

//==============================================================================
//========================= For Update Saller API  =============================

  Future<void> setUpdateUser() async {
    //var parameter = {
    //   Id: CUR_USERID,
    //   Name: name ?? "",
    //   Mobile: mobile ?? "",
    //   Email: email ?? "",
    //   Address: address ?? "",
    //   Storename: storename ?? "",
    //   Storeurl: storeurl ?? "",
    //   storeDescription: storeDesc ?? "",
    //   accountNumber: accNo ?? "",
    //   accountName: accname ?? "",
    //   bankCode: bankcode ?? "",
    //   bankName: bankname ?? "",
    //   Latitude: latitutute ?? "",
    //   Longitude: longitude ?? "",
    //   taxName: taxname ?? "",
    //   taxNumber: taxnumber ?? "",
    //   panNumber: pannumber ?? "",
    //   STATUS: status ?? "1",
    //   "address_proof": addressProof,
    // };

    // print("bbbbbbbbbbbbbbbbbbbbb ${updateUserApi}");
    // apiBaseHelper.postAPICall(updateUserApi, parameter).then(
    //   (getdata) async {
    //     bool error = getdata["error"];
    //     String? msg = getdata["message"];
    //     if (!error) {
    //       await buttonController!.reverse();
    //       setSnackbar(msg!);
    //     } else {
    //       await buttonController!.reverse();
    //       setSnackbar(msg!);
    //       setState(() {});
    //     }
    //   },
    //   onError: (error) {
    //     setSnackbar(error.toString());
    //   },
    // );

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var headers = {
      'Cookie': 'ci_session=e6fd02b5e324643ce3ff1ee8881f777f29672db4'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl}update_user'));

    request.fields.addAll({
      Id: CUR_USERID.toString(),
      Name: name ?? "",
      Mobile: mobile ?? "",
      Email: email ?? "",
      Address: address ?? "",
      Storename: storename ?? "",
      Storeurl: storeurl ?? "",
      storeDescription: storeDesc ?? "",
      // accountNumber: accNo ?? "",
      // accountName: accname ?? "",
      // bankCode: bankcode ?? "",
      // bankName: banknameC!.text ?? "",
      Latitude: latitutute ?? "",
      Longitude: longitude ?? "",
      taxName: taxname ?? "",
      taxNumber: taxnumber ?? "",
      adharNo: adharNumber ?? "",
      panNumber: pannumber ?? "",
      STATUS: status ?? "1",
      "fassai_number": userfassai ?? ""
    });
    print('____requestrequestrequestrequest_______${request.fields}____${request}______');
    addressProof == null
        ? null
        : request.files.add(await http.MultipartFile.fromPath(
            'address_proof', addressProof!.path.toString()));
    // request.files.add(await http.MultipartFile.fromPath(
    //     'image', '/C:/Users/Indian/Downloads/Group 3.png'));
    request.headers.addAll(headers);
    print(
        "new update profile param ${baseUrl}update_user  and ${request.fields}");
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      await buttonController!.reverse();
      var finalResult = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResult);
      newAddressProof = jsonResponse['data'][0]['address_proof'];
      prefs.setString('address_proof', newAddressProof.toString());
      prefs.setString(
          'fassaiNumber', jsonResponse['data'][0]['fassai_number'].toString());
      newAdhar = jsonResponse['data'][0]['adhar_no'];
      prefs.setString('adhar_no', jsonResponse['data'][0]['adhar_no'].toString());
      print('_____newAdharnewAdharnewAdharnewAdhar______${newAdhar}__________');
      setState(() {
        setSnackbar(jsonResponse['message']);
      });
    } else {
      print(response.reasonPhrase);
    }
  }

//==============================================================================
//========================== SanackBar code ====================================

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(color: primary),
        ),
        backgroundColor: white,
        elevation: 1.0,
      ),
    );
  }

  File? imageFile;

final picker =  ImagePicker();

  _getFromGallery() async {
    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      updateUserImage();
      Navigator.pop(context);
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      updateUserImage();
      Navigator.pop(context);
    }
  }

//==============================================================================
//========================== build Method ======================================

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: lightWhite,
      appBar: getAppBar(getTranslated(context, "EDIT_PROFILE_LBL")!, context),
      body: Stack(
        children: <Widget>[
          bodyPart(),
          showCircularProgress(_isLoading, primary)
        ],
      ),
    );
  }

//==============================================================================
//========================== build Method ======================================
  bodyPart() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: _isNetworkAvail
            ? Column(
                children: <Widget>[
                  getprofileImage(),
                  getFirstHeader(),
                  getSecondHeader(),
                  // getThirdHeader(),

                  // Container(
                  //   child: Column(
                  //     children: [
                  //       Text("Address Proof"),
                  //       SizedBox(
                  //         height: 5,
                  //       ),
                  //       MaterialButton(
                  //         onPressed: () {
                  //           showDialog(
                  //               context: context,
                  //               builder: (context) {
                  //                 return StatefulBuilder(builder:
                  //                     (BuildContext context,
                  //                         StateSetter setState) {
                  //                   return AlertDialog(
                  //                     content: Column(
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       mainAxisSize: MainAxisSize.min,
                  //                       children: [
                  //                         Text("Upload Images"),
                  //                         SizedBox(
                  //                           height: 10,
                  //                         ),
                  //                         InkWell(
                  //                           onTap: () {
                  //                             _getFromGallery1();
                  //                           },
                  //                           child: Row(
                  //                             children: [
                  //                               Icon(Icons.photo),
                  //                               SizedBox(
                  //                                 width: 5,
                  //                               ),
                  //                               Text("Image from Gallery"),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                         SizedBox(
                  //                           height: 10,
                  //                         ),
                  //                         InkWell(
                  //                           onTap: () {
                  //                             _getFromCamera1();
                  //                           },
                  //                           child: Row(
                  //                             children: [
                  //                               Icon(Icons.camera),
                  //                               SizedBox(
                  //                                 width: 5,
                  //                               ),
                  //                               Text("Image from Camera"),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   );
                  //                 });
                  //               });
                  //         },
                  //         child: newAddressProof == null
                  //             ? addressProof == null
                  //                 ? Text(
                  //                     "Upload Image",
                  //                     style: TextStyle(color: Colors.white),
                  //                   )
                  //                 : Container(
                  //                     height: 60,
                  //                     width: 70,
                  //                     child: Image.file(
                  //                       addressProof!,
                  //                       fit: BoxFit.fill,
                  //                     ),
                  //                   )
                  //             : Container(
                  //                 height: 60,
                  //                 width: 70,
                  //                 child: Image.network(
                  //                   "${newAddressProof}",
                  //                   fit: BoxFit.fill,
                  //                 ),
                  //               ),
                  //         color: primary,
                  //       )
                  //     ],
                  //   ),
                  // ),

                  getFurthHeader(),
                  // changePass(),
                  // updateBtn(),
                ],
              )
            : noInternet(context),
      ),
    );
  }

//==============================================================================
//=========================== profile Image ====================================

  getprofileImage() {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: primary,
            child: imageFile != null
                ? Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: primary)),
                        child: CircleAvatar(
                          backgroundImage: FileImage(imageFile!),
                          radius: 100,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setState) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Upload Image"),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _getFromGallery();
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.image),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text("Image from Gallery"),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              _getFromCamera();
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.camera),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text("Image from Camera"),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                                });
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : LOGO != ''
                    ? Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: primary)),
                            child: CircleAvatar(
                              backgroundImage: sellerProfile == null
                                  ? NetworkImage(LOGO)
                                  : NetworkImage(sellerProfile.toString()),
                              radius: 100,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Upload Image"),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _getFromGallery();
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.image),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text("Image from Gallery"),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _getFromCamera();
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.camera),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text("Image from Camera"),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  removePhoto();
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.image),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text("Remove Photo"),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                    });
                              },
                              child: Container(
                                height: 20,
                                width: 20,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: primary)),
                        child: Icon(Icons.account_circle, size: 100)),
          ),
          SizedBox(
            height: 5,
          ),
          // Container(
          //   child: MaterialButton(
          //     onPressed: () {
          //       removePhoto();
          //     },
          //     child: Text(
          //       "Remove Photo",
          //       style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 15,
          //           fontWeight: FontWeight.w500),
          //     ),
          //     color: primary,
          //   ),
          // )
        ],
      ),
    );
  }

//==============================================================================
//============================== First Header ==================================

  getFirstHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 5.0),
      child: Container(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Column(
            children: <Widget>[
              setSallerName(),
              getDivider(),
              setMobileNo(),
              getDivider(),
              setEmail(),
              getDivider(),
              setAddress(),
            ],
          ),
        ),
      ),
    );
  }

//==============================================================================
//============================== Divider =======================================

  getDivider() {
    return Divider(
      height: 1,
      color: lightBlack,
    );
  }

//==============================================================================
//=========================== Saller Name ======================================

  setSallerName() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.person_outlined,
            color: primary,
            size: 27,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Restaurant Owner",
                  style: Theme.of(this.context).textTheme.caption!.copyWith(
                        color: lightBlack2,
                        fontWeight: FontWeight.normal,
                      ),
                ),
                name != "" && name != null
                    ? Text(
                        name!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Text(
                        getTranslated(context, "NotAdded")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              ],
            ),
          ),
          Spacer(),
          // IconButton(
          //   icon: Icon(
          //     Icons.edit,
          //     size: 20,
          //     color: lightBlack,
          //   ),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       barrierDismissible: false,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           contentPadding: const EdgeInsets.all(0),
          //           elevation: 2.0,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.all(
          //               Radius.circular(5.0),
          //             ),
          //           ),
          //           content: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
          //                 child: Text(
          //                   getTranslated(context, "ADD_NAME_LBL")!,
          //                   style: Theme.of(this.context)
          //                       .textTheme
          //                       .subtitle1!
          //                       .copyWith(color: fontColor),
          //                 ),
          //               ),
          //               Divider(color: lightBlack),
          //               Form(
          //                 key: sellernameKey,
          //                 child: Padding(
          //                   padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          //                   child: TextFormField(
          //                     keyboardType: TextInputType.text,
          //                     style: Theme.of(this.context)
          //                         .textTheme
          //                         .subtitle1!
          //                         .copyWith(
          //                           color: lightBlack,
          //                           fontWeight: FontWeight.normal,
          //                         ),
          //                     validator: (val) =>
          //                         validateUserName(val, context),
          //                     autovalidateMode:
          //                         AutovalidateMode.onUserInteraction,
          //                     controller: nameC,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           actions: <Widget>[
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "CANCEL")!,
          //                 style: TextStyle(
          //                   color: lightBlack,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 setState(
          //                   () {
          //                     Navigator.pop(context);
          //                   },
          //                 );
          //               },
          //             ),
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "SAVE_LBL")!,
          //                 style: TextStyle(
          //                   color: fontColor,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 final form = sellernameKey.currentState!;
          //                 if (form.validate()) {
          //                   form.save();
          //                   setState(
          //                     () {
          //                       name = nameC!.text;
          //                       Navigator.pop(context);
          //                     },
          //                   );
          //                 }
          //               },
          //             )
          //           ],
          //         );
          //       },
          //     );
          //   },
          // )
        ],
      ),
    );
  }

//==============================================================================
//============================= Mobile Number ==================================

  setMobileNo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.phone_in_talk_outlined,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated(context, "MOBILEHINT_LBL")!,
                  style: Theme.of(this.context).textTheme.caption!.copyWith(
                      color: lightBlack2, fontWeight: FontWeight.normal),
                ),
                mobile != null && mobile != ""
                    ? Text(
                        mobile!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Text(
                        getTranslated(context, "NotAdded")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//==============================================================================
//=============================== set Email ====================================

  setEmail() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.email_outlined,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated(context, "Email")!,
                  style: Theme.of(this.context).textTheme.caption!.copyWith(
                      color: lightBlack2, fontWeight: FontWeight.normal),
                ),
                email != "" && email != null
                    ? Text(
                        email!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Text(
                        getTranslated(context, "NotAdded")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              ],
            ),
          ),
          Spacer(),
          // IconButton(
          //   icon: Icon(
          //     Icons.edit,
          //     size: 20,
          //     color: lightBlack,
          //   ),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       barrierDismissible: false,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           contentPadding: const EdgeInsets.all(0),
          //           elevation: 2.0,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.all(
          //               Radius.circular(5.0),
          //             ),
          //           ),
          //           content: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
          //                 child: Text(
          //                   getTranslated(context, "addEmail")!,
          //                   style: Theme.of(this.context)
          //                       .textTheme
          //                       .subtitle1!
          //                       .copyWith(color: fontColor),
          //                 ),
          //               ),
          //               Divider(color: lightBlack),
          //               Form(
          //                 key: emailKey,
          //                 child: Padding(
          //                   padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          //                   child: TextFormField(
          //                     keyboardType: TextInputType.text,
          //                     style: Theme.of(this.context)
          //                         .textTheme
          //                         .subtitle1!
          //                         .copyWith(
          //                             color: lightBlack,
          //                             fontWeight: FontWeight.normal),
          //                     validator: (val) => validateField(val, context),
          //                     autovalidateMode:
          //                         AutovalidateMode.onUserInteraction,
          //                     controller: emailC,
          //                   ),
          //                 ),
          //               )
          //             ],
          //           ),
          //           actions: <Widget>[
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "CANCEL")!,
          //                 style: TextStyle(
          //                   color: lightBlack,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 setState(
          //                   () {
          //                     Navigator.pop(context);
          //                   },
          //                 );
          //               },
          //             ),
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "SAVE_LBL")!,
          //                 style: TextStyle(
          //                   color: fontColor,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 final form = emailKey.currentState!;
          //                 if (form.validate()) {
          //                   form.save();
          //                   setState(
          //                     () {
          //                       email = emailC!.text;
          //                       Navigator.pop(context);
          //                     },
          //                   );
          //                 }
          //               },
          //             ),
          //           ],
          //         );
          //       },
          //     );
          //   },
          // )
        ],
      ),
    );
  }

//==============================================================================
//============================ set Address =====================================

  setAddress() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.location_on_outlined,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated(context, "Addresh")!,
                  style: Theme.of(this.context).textTheme.caption!.copyWith(
                        color: lightBlack2,
                        fontWeight: FontWeight.normal,
                      ),
                ),
                address != "" && address != null
                    ? Container(
                        width: 200,
                        child: Text(
                          address!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(this.context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                                color: lightBlack,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      )
                    : Text(
                        getTranslated(context, "NotAdded")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              ],
            ),
          ),
          Spacer(),
          // IconButton(
          //   icon: Icon(
          //     Icons.edit,
          //     size: 20,
          //     color: lightBlack,
          //   ),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       barrierDismissible: false,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           contentPadding: const EdgeInsets.all(0),
          //           elevation: 2.0,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.all(
          //               Radius.circular(5.0),
          //             ),
          //           ),
          //           content: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
          //                 child: Text(
          //                   getTranslated(context, "AddAddress")!,
          //                   style: Theme.of(this.context)
          //                       .textTheme
          //                       .subtitle1!
          //                       .copyWith(color: fontColor),
          //                 ),
          //               ),
          //               Divider(color: lightBlack),
          //               Form(
          //                 key: addressKey,
          //                 child: Padding(
          //                   padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          //                   child: TextFormField(
          //                     maxLines: 2,
          //                     keyboardType: TextInputType.text,
          //                     style: Theme.of(this.context)
          //                         .textTheme
          //                         .subtitle1!
          //                         .copyWith(
          //                           color: lightBlack,
          //                           fontWeight: FontWeight.normal,
          //                         ),
          //                     validator: (val) => validateField(val, context),
          //                     autovalidateMode:
          //                         AutovalidateMode.onUserInteraction,
          //                     controller: addressC,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           actions: <Widget>[
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "CANCEL")!,
          //                 style: TextStyle(
          //                   color: lightBlack,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 setState(
          //                   () {
          //                     Navigator.pop(context);
          //                   },
          //                 );
          //               },
          //             ),
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "SAVE_LBL")!,
          //                 style: TextStyle(
          //                   color: fontColor,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 final form = addressKey.currentState!;
          //                 if (form.validate()) {
          //                   form.save();
          //                   setState(
          //                     () {
          //                       address = addressC!.text;
          //                       Navigator.pop(context);
          //                     },
          //                   );
          //                 }
          //               },
          //             )
          //           ],
          //         );
          //       },
          //     );
          //   },
          // )
        ],
      ),
    );
  }

//==============================================================================
//============================ Second Header ===================================

  getSecondHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 5.0),
      child: Container(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Column(
            children: <Widget>[
              setStoreName(),
              getDivider(),
              setStoreURL(),
              getDivider(),
              setDescription(),
            ],
          ),
        ),
      ),
    );
  }

//==============================================================================
//============================ Store Name  =====================================

  setStoreName() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.store_outlined,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Restaurant Name",
                  style: Theme.of(this.context).textTheme.caption!.copyWith(
                      color: lightBlack2, fontWeight: FontWeight.normal),
                ),
                storename != "" && storename != null
                    ? Text(
                        storename!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Text(
                        getTranslated(context, "NotAdded")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              ],
            ),
          ),
          Spacer(),
          // IconButton(
          //   icon: Icon(
          //     Icons.edit,
          //     size: 20,
          //     color: lightBlack,
          //   ),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       barrierDismissible: false,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           contentPadding: const EdgeInsets.all(0),
          //           elevation: 2.0,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.all(
          //               Radius.circular(5.0),
          //             ),
          //           ),
          //           content: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
          //                 child: Text(
          //                   getTranslated(context, "addStoreName")!,
          //                   style: Theme.of(this.context)
          //                       .textTheme
          //                       .subtitle1!
          //                       .copyWith(color: fontColor),
          //                 ),
          //               ),
          //               Divider(color: lightBlack),
          //               Form(
          //                 key: storenameKey,
          //                 child: Padding(
          //                   padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          //                   child: TextFormField(
          //                     keyboardType: TextInputType.text,
          //                     style: Theme.of(this.context)
          //                         .textTheme
          //                         .subtitle1!
          //                         .copyWith(
          //                           color: lightBlack,
          //                           fontWeight: FontWeight.normal,
          //                         ),
          //                     validator: (val) => validateField(val, context),
          //                     autovalidateMode:
          //                         AutovalidateMode.onUserInteraction,
          //                     controller: storenameC,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           actions: <Widget>[
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "CANCEL")!,
          //                 style: TextStyle(
          //                   color: lightBlack,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 setState(
          //                   () {
          //                     Navigator.pop(context);
          //                   },
          //                 );
          //               },
          //             ),
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "SAVE_LBL")!,
          //                 style: TextStyle(
          //                   color: fontColor,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 final form = storenameKey.currentState!;
          //                 if (form.validate()) {
          //                   form.save();
          //                   setState(
          //                     () {
          //                       storename = storenameC!.text;
          //                       Navigator.pop(context);
          //                     },
          //                   );
          //                 }
          //               },
          //             )
          //           ],
          //         );
          //       },
          //     );
          //   },
          // )
        ],
      ),
    );
  }

//==============================================================================
//============================= Store URL ======================================

  setStoreURL() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.link_outlined,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Restaurant URL",
                  style: Theme.of(this.context).textTheme.caption!.copyWith(
                      color: lightBlack2, fontWeight: FontWeight.normal),
                ),
                storeurl != "" && storeurl != null
                    ? Text(
                        storeurl!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Text(
                        getTranslated(context, "NoURL")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              ],
            ),
          ),
          Spacer(),
          // IconButton(
          //   icon: Icon(
          //     Icons.edit,
          //     size: 20,
          //     color: lightBlack,
          //   ),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       barrierDismissible: false,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           contentPadding: const EdgeInsets.all(0),
          //           elevation: 2.0,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.all(
          //               Radius.circular(5.0),
          //             ),
          //           ),
          //           content: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
          //                 child: Text(
          //                   getTranslated(context, "addURL")!,
          //                   style: Theme.of(this.context)
          //                       .textTheme
          //                       .subtitle1!
          //                       .copyWith(color: fontColor),
          //                 ),
          //               ),
          //               Divider(color: lightBlack),
          //               Form(
          //                 key: storeurlKey,
          //                 child: Padding(
          //                   padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          //                   child: TextFormField(
          //                     keyboardType: TextInputType.text,
          //                     style: Theme.of(this.context)
          //                         .textTheme
          //                         .subtitle1!
          //                         .copyWith(
          //                           color: lightBlack,
          //                           fontWeight: FontWeight.normal,
          //                         ),
          //                     validator: (val) => validateField(val, context),
          //                     autovalidateMode:
          //                         AutovalidateMode.onUserInteraction,
          //                     controller: storeurlC,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           actions: <Widget>[
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "CANCEL")!,
          //                 style: TextStyle(
          //                   color: lightBlack,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 setState(
          //                   () {
          //                     Navigator.pop(context);
          //                   },
          //                 );
          //               },
          //             ),
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "SAVE_LBL")!,
          //                 style: TextStyle(
          //                   color: fontColor,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 final form = storeurlKey.currentState!;
          //                 if (form.validate()) {
          //                   form.save();
          //                   setState(
          //                     () {
          //                       storeurl = storeurlC!.text;
          //                       Navigator.pop(context);
          //                     },
          //                   );
          //                 }
          //               },
          //             )
          //           ],
          //         );
          //       },
          //     );
          //   },
          // )
        ],
      ),
    );
  }

//==============================================================================
//============================ Description =====================================

  setDescription() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.description_outlined,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated(context, "Description")!,
                  style: Theme.of(this.context).textTheme.caption!.copyWith(
                      color: lightBlack2, fontWeight: FontWeight.normal),
                ),
                storeDesc != "" && storeDesc != null
                    ? Text(
                        storeDesc!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                        overflow: TextOverflow.ellipsis,
                      )
                    : Text(
                        getTranslated(context, "addDescription")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              ],
            ),
          ),
          Spacer(),
          // IconButton(
          //   icon: Icon(
          //     Icons.edit,
          //     size: 20,
          //     color: lightBlack,
          //   ),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       barrierDismissible: false,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           contentPadding: const EdgeInsets.all(0),
          //           elevation: 2.0,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.all(
          //               Radius.circular(5.0),
          //             ),
          //           ),
          //           content: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
          //                 child: Text(
          //                   getTranslated(context, "addDescription")!,
          //                   style: Theme.of(this.context)
          //                       .textTheme
          //                       .subtitle1!
          //                       .copyWith(color: fontColor),
          //                 ),
          //               ),
          //               Divider(color: lightBlack),
          //               Form(
          //                 key: storeDescKey,
          //                 child: Padding(
          //                   padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          //                   child: TextFormField(
          //                     keyboardType: TextInputType.text,
          //                     style: Theme.of(this.context)
          //                         .textTheme
          //                         .subtitle1!
          //                         .copyWith(
          //                           color: lightBlack,
          //                           fontWeight: FontWeight.normal,
          //                         ),
          //                     validator: (val) => validateField(val, context),
          //                     autovalidateMode:
          //                         AutovalidateMode.onUserInteraction,
          //                     controller: storeDescC,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           actions: <Widget>[
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "CANCEL")!,
          //                 style: TextStyle(
          //                   color: lightBlack,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 setState(
          //                   () {
          //                     Navigator.pop(context);
          //                   },
          //                 );
          //               },
          //             ),
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "SAVE_LBL")!,
          //                 style: TextStyle(
          //                   color: fontColor,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 final form = storeDescKey.currentState!;
          //                 if (form.validate()) {
          //                   form.save();
          //                   setState(
          //                     () {
          //                       storeDesc = storeDescC!.text;
          //                       Navigator.pop(context);
          //                     },
          //                   );
          //                 }
          //               },
          //             )
          //           ],
          //         );
          //       },
          //     );
          //   },
          // )
        ],
      ),
    );
  }

//==============================================================================
//============================ Third Header ====================================

  getThirdHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 5.0),
      child: Container(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              setAccountNumber(),
              getDivider(),
              setAccountName(),
              getDivider(),
              setBankCode(),
              getDivider(),
              setBankName(),
            ],
          ),
        ),
      ),
    );
  }

//==============================================================================
//============================ Account Number  =================================

  setAccountNumber() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.format_list_numbered_outlined,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated(context, "AccountNumber")!,
                  style: Theme.of(this.context).textTheme.caption!.copyWith(
                      color: lightBlack2, fontWeight: FontWeight.normal),
                ),
                accNo != "" && accNo != null && accNo != "null"
                    ? Text(
                        accNo!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Text(
                        getTranslated(context, "NotAdded")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 20,
              color: lightBlack,
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: const EdgeInsets.all(0),
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                          child: Text(
                            getTranslated(context, "addAccontNumber")!,
                            style: Theme.of(this.context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: fontColor),
                          ),
                        ),
                        Divider(color: lightBlack),
                        Form(
                          key: accnumberKey,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: Theme.of(this.context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: lightBlack,
                                    fontWeight: FontWeight.normal,
                                  ),
                              validator: (val) => validateField(val, context),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: accnumberC,
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      new MaterialButton(
                        child: Text(
                          getTranslated(context, "CANCEL")!,
                          style: TextStyle(
                            color: lightBlack,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          setState(
                            () {
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                      new MaterialButton(
                        child: Text(
                          getTranslated(context, "SAVE_LBL")!,
                          style: TextStyle(
                            color: fontColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          final form = accnumberKey.currentState!;
                          if (form.validate()) {
                            form.save();
                            setState(
                              () {
                                accNo = accnumberC!.text;
                                Navigator.pop(context);
                              },
                            );
                          }
                        },
                      )
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }

//==============================================================================
//============================ Account Name  ===================================

  setAccountName() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.import_contacts_outlined,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated(context, "AccountName")!,
                  style: Theme.of(this.context).textTheme.caption!.copyWith(
                      color: lightBlack2, fontWeight: FontWeight.normal),
                ),
                accname != "" && accname != null && accname != "null"
                    ? Text(
                        accname!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Text(
                        getTranslated(context, "NotAdded")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 20,
              color: lightBlack,
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: const EdgeInsets.all(0),
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                          child: Text(
                            getTranslated(context, "addAccountName")!,
                            style: Theme.of(this.context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: fontColor),
                          ),
                        ),
                        Divider(color: lightBlack),
                        Form(
                          key: accnameKey,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: Theme.of(this.context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: lightBlack,
                                    fontWeight: FontWeight.normal,
                                  ),
                              validator: (val) => validateField(val, context),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: accnameC,
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      new MaterialButton(
                        child: Text(
                          getTranslated(context, "CANCEL")!,
                          style: TextStyle(
                            color: lightBlack,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          setState(
                            () {
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                      new MaterialButton(
                        child: Text(
                          getTranslated(context, "SAVE_LBL")!,
                          style: TextStyle(
                            color: fontColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          final form = accnameKey.currentState!;
                          if (form.validate()) {
                            form.save();
                            setState(
                              () {
                                accname = accnameC!.text;
                                Navigator.pop(context);
                              },
                            );
                          }
                        },
                      )
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }

//==============================================================================
//============================ Account Number  =================================

  setBankCode() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.request_quote_outlined,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated(context, "BankCode")!,
                  style: Theme.of(this.context).textTheme.caption!.copyWith(
                      color: lightBlack2, fontWeight: FontWeight.normal),
                ),
                bankcode != "" && bankcode != null
                    ? Text(
                        bankcode!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Text(
                        getTranslated(context, "NotAdded")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 20,
              color: lightBlack,
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: const EdgeInsets.all(0),
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                          child: Text(
                            getTranslated(context, "addBankCode")!,
                            style: Theme.of(this.context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: fontColor),
                          ),
                        ),
                        Divider(color: lightBlack),
                        Form(
                          key: bankcodeKey,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: Theme.of(this.context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: lightBlack,
                                    fontWeight: FontWeight.normal,
                                  ),
                              validator: (val) => validateField(val, context),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: bankcodeC,
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      new MaterialButton(
                        child: Text(
                          getTranslated(context, "CANCEL")!,
                          style: TextStyle(
                            color: lightBlack,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          setState(
                            () {
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                      new MaterialButton(
                        child: Text(
                          getTranslated(context, "SAVE_LBL")!,
                          style: TextStyle(
                            color: fontColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          final form = bankcodeKey.currentState!;
                          if (form.validate()) {
                            form.save();
                            setState(
                              () {
                                bankcode = bankcodeC!.text;
                                Navigator.pop(context);
                              },
                            );
                          }
                        },
                      )
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }

//==============================================================================
//============================ setBankName =====================================

  setBankName() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.account_balance_outlined,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated(context, "BankName")!,
                  style: Theme.of(this.context).textTheme.caption!.copyWith(
                      color: lightBlack2, fontWeight: FontWeight.normal),
                ),
                bankname != "" && bankname != null
                    ? Text(
                        bankname!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Text(
                        getTranslated(context, "NotAdded")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              ],
            ),
          ),
          Spacer(),
          // IconButton(
          //   icon: Icon(
          //     Icons.edit,
          //     size: 20,
          //     color: lightBlack,
          //   ),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       barrierDismissible: false,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           contentPadding: const EdgeInsets.all(0),
          //           elevation: 2.0,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.all(
          //               Radius.circular(5.0),
          //             ),
          //           ),
          //           content: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
          //                 child: Text(
          //                   getTranslated(context, "addBankName")!,
          //                   style: Theme.of(this.context)
          //                       .textTheme
          //                       .subtitle1!
          //                       .copyWith(color: fontColor),
          //                 ),
          //               ),
          //               Divider(color: lightBlack),
          //               Form(
          //                 key: banknameKey,
          //                 child: Padding(
          //                   padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          //                   child: TextFormField(
          //                     keyboardType: TextInputType.text,
          //                     style: Theme.of(this.context)
          //                         .textTheme
          //                         .subtitle1!
          //                         .copyWith(
          //                           color: lightBlack,
          //                           fontWeight: FontWeight.normal,
          //                         ),
          //                     validator: (val) => validateField(val, context),
          //                     autovalidateMode:
          //                         AutovalidateMode.onUserInteraction,
          //                     controller: banknameC,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           actions: <Widget>[
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "CANCEL")!,
          //                 style: TextStyle(
          //                   color: lightBlack,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 setState(
          //                   () {
          //                     Navigator.pop(context);
          //                   },
          //                 );
          //               },
          //             ),
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "SAVE_LBL")!,
          //                 style: TextStyle(
          //                   color: fontColor,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 final form = banknameKey.currentState!;
          //                 if (form.validate()) {
          //                   form.save();
          //                   setState(
          //                     () {
          //                       bankname = banknameC!.text;
          //                       Navigator.pop(context);
          //                     },
          //                   );
          //                 }
          //               },
          //             )
          //           ],
          //         );
          //       },
          //     );
          //   },
          // )
        ],
      ),
    );
  }

//==============================================================================
//========================= Fourth Header ======================================

  getFurthHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 5.0),
      child: Container(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              // setLatitude(),
              // getDivider(),
              setLongitude(),
              getDivider(),
              setTaxName(),

              ////////////// address proof  /////////////////////

              getDivider(),
              setTaxNumber(),
              getDivider(),
              setPanNumber(),
              setFassai(),
            ],
          ),
        ),
      ),
    );
  }

  //=======================================================
  // ============= FSSAI Number

  setFassai() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.picture_in_picture_outlined,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Fssai Number",
                  style: Theme.of(this.context).textTheme.caption!.copyWith(
                      color: lightBlack2, fontWeight: FontWeight.normal),
                ),
                userfassai != "" && userfassai != null && userfassai != "null"
                    ? Text(
                        userfassai!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Text(
                        "Not added yet",
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              ],
            ),
          ),
          Spacer(),
          // IconButton(
          //   icon: Icon(
          //     Icons.edit,
          //     size: 20,
          //     color: lightBlack,
          //   ),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       barrierDismissible: false,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           contentPadding: const EdgeInsets.all(0),
          //           elevation: 2.0,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.all(
          //               Radius.circular(5.0),
          //             ),
          //           ),
          //           content: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
          //                 child: Text(
          //                   "Add Fassai Number",
          //                   style: Theme.of(this.context)
          //                       .textTheme
          //                       .subtitle1!
          //                       .copyWith(color: fontColor),
          //                 ),
          //               ),
          //               Divider(color: lightBlack),
          //               Form(
          //                 key: latitututeKey,
          //                 child: Padding(
          //                   padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          //                   child: TextFormField(
          //                     keyboardType: TextInputType.text,
          //                     style: Theme.of(this.context)
          //                         .textTheme
          //                         .subtitle1!
          //                         .copyWith(
          //                           color: lightBlack,
          //                           fontWeight: FontWeight.normal,
          //                         ),
          //                     validator: (val) => validateField(val, context),
          //                     autovalidateMode:
          //                         AutovalidateMode.onUserInteraction,
          //                     controller: fassaiC,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           actions: <Widget>[
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "CANCEL")!,
          //                 style: TextStyle(
          //                   color: lightBlack,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 setState(
          //                   () {
          //                     Navigator.pop(context);
          //                   },
          //                 );
          //               },
          //             ),
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "SAVE_LBL")!,
          //                 style: TextStyle(
          //                   color: fontColor,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 final form = latitututeKey.currentState!;
          //                 if (form.validate()) {
          //                   form.save();
          //                   setState(
          //                     () {
          //                       userfassai = fassaiC!.text;
          //                       Navigator.pop(context);
          //                     },
          //                   );
          //                 }
          //               },
          //             )
          //           ],
          //         );
          //       },
          //     );
          //   },
          // )
        ],
      ),
    );
  }
//==============================================================================
//============================== Latitude ======================================

  setLatitude() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.travel_explore_outlined,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated(context, "Latitute")!,
                  style: Theme.of(this.context).textTheme.caption!.copyWith(
                      color: lightBlack2, fontWeight: FontWeight.normal),
                ),
                latitutute != "" && latitutute != null
                    ? Text(
                        latitutute!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Text(
                        getTranslated(context, "NotAdded")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 20,
              color: lightBlack,
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: const EdgeInsets.all(0),
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                          child: Text(
                            getTranslated(context, "AddLatitute")!,
                            style: Theme.of(this.context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: fontColor),
                          ),
                        ),
                        Divider(color: lightBlack),
                        Form(
                          key: latitututeKey,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: Theme.of(this.context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: lightBlack,
                                    fontWeight: FontWeight.normal,
                                  ),
                              validator: (val) => validateField(val, context),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: latitututeC,
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      new MaterialButton(
                        child: Text(
                          getTranslated(context, "CANCEL")!,
                          style: TextStyle(
                            color: lightBlack,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          setState(
                            () {
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                      new MaterialButton(
                        child: Text(
                          getTranslated(context, "SAVE_LBL")!,
                          style: TextStyle(
                            color: fontColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          final form = latitututeKey.currentState!;
                          if (form.validate()) {
                            form.save();
                            setState(
                              () {
                                latitutute = latitututeC!.text;
                                Navigator.pop(context);
                              },
                            );
                          }
                        },
                      )
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }

//==============================================================================
//============================ Longitude =======================================

  setLongitude() {
    print('_____newAdhar______${newAdhar}__________');
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.language_outlined,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Adhar Number",
                  style: Theme.of(this.context).textTheme.caption!.copyWith(
                      color: lightBlack2, fontWeight: FontWeight.normal),
                ),
                newAdhar != "" && newAdhar != null && newAdhar != "null"
                    ? Text(
                        newAdhar!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Text(
                        getTranslated(context, "NotAdded")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              ],
            ),
          ),
          Spacer(),
          // IconButton(
          //   icon: Icon(
          //     Icons.edit,
          //     size: 20,
          //     color: lightBlack,
          //   ),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       barrierDismissible: false,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           contentPadding: const EdgeInsets.all(0),
          //           elevation: 2.0,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.all(
          //               Radius.circular(5.0),
          //             ),
          //           ),
          //           content: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
          //                 child: Text(
          //                   "Add Adhar",
          //                   style: Theme.of(this.context)
          //                       .textTheme
          //                       .subtitle1!
          //                       .copyWith(color: fontColor),
          //                 ),
          //               ),
          //               Divider(color: lightBlack),
          //               Form(
          //                 key: longituteKey,
          //                 child: Padding(
          //                   padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          //                   child: TextFormField(
          //                     keyboardType: TextInputType.text,
          //                     style: Theme.of(this.context)
          //                         .textTheme
          //                         .subtitle1!
          //                         .copyWith(
          //                           color: lightBlack,
          //                           fontWeight: FontWeight.normal,
          //                         ),
          //                     validator: (val) => validateField(val, context),
          //                     autovalidateMode:
          //                         AutovalidateMode.onUserInteraction,
          //                     controller: adharC,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           actions: <Widget>[
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "CANCEL")!,
          //                 style: TextStyle(
          //                   color: lightBlack,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 setState(
          //                   () {
          //                     Navigator.pop(context);
          //                   },
          //                 );
          //               },
          //             ),
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "SAVE_LBL")!,
          //                 style: TextStyle(
          //                   color: fontColor,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 final form = longituteKey.currentState!;
          //                 if (form.validate()) {
          //                   form.save();
          //                   setState(
          //                     () {
          //                       newAdhar = adharC!.text;
          //                       Navigator.pop(context);
          //                     },
          //                   );
          //                 }
          //               },
          //             )
          //           ],
          //         );
          //       },
          //     );
          //   },
          // )
        ],
      ),
    );
  }

//==============================================================================
//============================== Tax Name ======================================

  setTaxName() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.text_snippet_outlined,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "GST Name",
                  style: Theme.of(this.context).textTheme.caption!.copyWith(
                      color: lightBlack2, fontWeight: FontWeight.normal),
                ),
                taxname != "" && taxname != null
                    ? Text(
                        taxname!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Text(
                        getTranslated(context, "NotAdded")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              ],
            ),
          ),
          Spacer(),
          // IconButton(
          //   icon: Icon(
          //     Icons.edit,
          //     size: 20,
          //     color: lightBlack,
          //   ),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       barrierDismissible: false,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           contentPadding: const EdgeInsets.all(0),
          //           elevation: 2.0,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.all(
          //               Radius.circular(5.0),
          //             ),
          //           ),
          //           content: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
          //                 child: Text(
          //                   getTranslated(context, "addTaxName")!,
          //                   style: Theme.of(this.context)
          //                       .textTheme
          //                       .subtitle1!
          //                       .copyWith(color: fontColor),
          //                 ),
          //               ),
          //               Divider(color: lightBlack),
          //               Form(
          //                 key: taxnameKey,
          //                 child: Padding(
          //                   padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          //                   child: TextFormField(
          //                     keyboardType: TextInputType.text,
          //                     style: Theme.of(this.context)
          //                         .textTheme
          //                         .subtitle1!
          //                         .copyWith(
          //                           color: lightBlack,
          //                           fontWeight: FontWeight.normal,
          //                         ),
          //                     validator: (val) => validateField(val, context),
          //                     autovalidateMode:
          //                         AutovalidateMode.onUserInteraction,
          //                     controller: taxnameC,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           actions: <Widget>[
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "CANCEL")!,
          //                 style: TextStyle(
          //                   color: lightBlack,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 setState(
          //                   () {
          //                     Navigator.pop(context);
          //                   },
          //                 );
          //               },
          //             ),
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "SAVE_LBL")!,
          //                 style: TextStyle(
          //                   color: fontColor,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 final form = taxnameKey.currentState!;
          //                 if (form.validate()) {
          //                   form.save();
          //                   setState(
          //                     () {
          //                       taxname = taxnameC!.text;
          //                       Navigator.pop(context);
          //                     },
          //                   );
          //                 }
          //               },
          //             )
          //           ],
          //         );
          //       },
          //     );
          //   },
          // )
        ],
      ),
    );
  }

//==============================================================================
//========================== setTaxNumber ======================================

  setTaxNumber() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.assignment_outlined,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "GST Number",
                  style: Theme.of(this.context).textTheme.caption!.copyWith(
                      color: lightBlack2, fontWeight: FontWeight.normal),
                ),
                taxnumber != "" && taxnumber != null
                    ? Text(
                        taxnumber!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Text(
                        getTranslated(context, "NotAdded")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              ],
            ),
          ),
          Spacer(),
          // IconButton(
          //   icon: Icon(
          //     Icons.edit,
          //     size: 20,
          //     color: lightBlack,
          //   ),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       barrierDismissible: false,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           contentPadding: const EdgeInsets.all(0),
          //           elevation: 2.0,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.all(
          //               Radius.circular(5.0),
          //             ),
          //           ),
          //           content: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
          //                 child: Text(
          //                   getTranslated(context, "addTaxNumber")!,
          //                   style: Theme.of(this.context)
          //                       .textTheme
          //                       .subtitle1!
          //                       .copyWith(color: fontColor),
          //                 ),
          //               ),
          //               Divider(color: lightBlack),
          //               Form(
          //                 key: taxnumberKey,
          //                 child: Padding(
          //                   padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          //                   child: TextFormField(
          //                     keyboardType: TextInputType.text,
          //                     style: Theme.of(this.context)
          //                         .textTheme
          //                         .subtitle1!
          //                         .copyWith(
          //                           color: lightBlack,
          //                           fontWeight: FontWeight.normal,
          //                         ),
          //                     validator: (val) => validateField(val, context),
          //                     autovalidateMode:
          //                         AutovalidateMode.onUserInteraction,
          //                     controller: taxnumberC,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           actions: <Widget>[
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "CANCEL")!,
          //                 style: TextStyle(
          //                   color: lightBlack,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 setState(
          //                   () {
          //                     Navigator.pop(context);
          //                   },
          //                 );
          //               },
          //             ),
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "SAVE_LBL")!,
          //                 style: TextStyle(
          //                   color: fontColor,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 final form = taxnumberKey.currentState!;
          //                 if (form.validate()) {
          //                   form.save();
          //                   setState(
          //                     () {
          //                       taxnumber = taxnumberC!.text;
          //                       Navigator.pop(context);
          //                     },
          //                   );
          //                 }
          //               },
          //             )
          //           ],
          //         );
          //       },
          //     );
          //   },
          // )
        ],
      ),
    );
  }

//==============================================================================
//============================ Pan Number ======================================

  setPanNumber() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.picture_in_picture_outlined,
            color: primary,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated(context, "PanNumber")!,
                  style: Theme.of(this.context).textTheme.caption!.copyWith(
                      color: lightBlack2, fontWeight: FontWeight.normal),
                ),
                pannumber != "" && pannumber != null
                    ? Text(
                        pannumber!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    : Text(
                        getTranslated(context, "NotAdded")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle2!
                            .copyWith(
                              color: lightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
              ],
            ),
          ),
          Spacer(),
          // IconButton(
          //   icon: Icon(
          //     Icons.edit,
          //     size: 20,
          //     color: lightBlack,
          //   ),
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       barrierDismissible: false,
          //       builder: (BuildContext context) {
          //         return AlertDialog(
          //           contentPadding: const EdgeInsets.all(0),
          //           elevation: 2.0,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.all(
          //               Radius.circular(5.0),
          //             ),
          //           ),
          //           content: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Padding(
          //                 padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
          //                 child: Text(
          //                   getTranslated(context, "addPanNumber")!,
          //                   style: Theme.of(this.context)
          //                       .textTheme
          //                       .subtitle1!
          //                       .copyWith(color: fontColor),
          //                 ),
          //               ),
          //               Divider(color: lightBlack),
          //               Form(
          //                 key: pannumberKey,
          //                 child: Padding(
          //                   padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          //                   child: TextFormField(
          //                     keyboardType: TextInputType.text,
          //                     style: Theme.of(this.context)
          //                         .textTheme
          //                         .subtitle1!
          //                         .copyWith(
          //                           color: lightBlack,
          //                           fontWeight: FontWeight.normal,
          //                         ),
          //                     validator: (val) => validateField(val, context),
          //                     autovalidateMode:
          //                         AutovalidateMode.onUserInteraction,
          //                     controller: pannumberC,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           actions: <Widget>[
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "CANCEL")!,
          //                 style: TextStyle(
          //                   color: lightBlack,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 setState(
          //                   () {
          //                     Navigator.pop(context);
          //                   },
          //                 );
          //               },
          //             ),
          //             new MaterialButton(
          //               child: Text(
          //                 getTranslated(context, "SAVE_LBL")!,
          //                 style: TextStyle(
          //                   color: fontColor,
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               onPressed: () {
          //                 final form = pannumberKey.currentState!;
          //                 if (form.validate()) {
          //                   form.save();
          //                   setState(
          //                     () {
          //                       pannumber = pannumberC!.text;
          //                       Navigator.pop(context);
          //                     },
          //                   );
          //                 }
          //               },
          //             )
          //           ],
          //         );
          //       },
          //     );
          //   },
          // )
        ],
      ),
    );
  }

//==============================================================================
//============================ Change Pass =====================================

  changePass() {
    return Container(
      height: 60,
      width: width,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.0,
              top: 15.0,
              bottom: 15.0,
            ),
            child: Text(
              getTranslated(context, "CHANGE_PASS_LBL")!,
              style: Theme.of(this.context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: fontColor, fontWeight: FontWeight.bold),
            ),
          ),
          onTap: () {
            _showDialog();
          },
        ),
      ),
    );
  }

  /* _showDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                      child: Text(
                        getTranslated(context, "CHANGE_PASS_LBL")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: fontColor),
                      ),
                    ),
                    Divider(color: lightBlack),
                    Form(
                      key: _formKey,
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (val) => validatePass(val, context),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText:
                                    getTranslated(context, "CUR_PASS_LBL")!,
                                hintStyle: Theme.of(this.context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                        color: lightBlack,
                                        fontWeight: FontWeight.normal),
                                suffixIcon: IconButton(
                                  icon: Icon(_showCurPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  iconSize: 20,
                                  color: lightBlack,
                                  onPressed: () {
                                    setStater(
                                      () {
                                        _showCurPassword = !_showCurPassword;
                                      },
                                    );
                                  },
                                ),
                              ),
                              obscureText: !_showCurPassword,
                              controller: curPassC,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (val) => validatePass(val, context),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: new InputDecoration(
                                hintText:
                                    getTranslated(context, "NEW_PASS_LBL")!,
                                hintStyle: Theme.of(this.context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                        color: lightBlack,
                                        fontWeight: FontWeight.normal),
                                suffixIcon: IconButton(
                                  icon: Icon(_showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  iconSize: 20,
                                  color: lightBlack,
                                  onPressed: () {
                                    setStater(
                                      () {
                                        _showPassword = !_showPassword;
                                        newPass = newPassC.toString();
                                      },
                                    );

                                  },
                                ),
                              ),
                              obscureText: !_showPassword,
                              controller: newPassC,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                print("========$value");
                                if (value!.length == 0)
                                  return getTranslated(
                                      context, "CON_PASS_REQUIRED_MSG")!;
                                if (value != newPassC!.text) {
                                  return getTranslated(
                                      context, "CON_PASS_NOT_MATCH_MSG")!;
                                } else {
                                  return null;
                                }
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: new InputDecoration(
                                  hintText: getTranslated(
                                      context, "CONFIRMPASSHINT_LBL")!,
                                  hintStyle: Theme.of(this.context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          color: lightBlack,
                                          fontWeight: FontWeight.normal),
                                  suffixIcon: IconButton(
                                    icon: Icon(_showCmPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    iconSize: 20,
                                    color: lightBlack,
                                    onPressed: () {
                                      setStater(() {
                                        _showCmPassword = !_showCmPassword;
                                      });
                                    },
                                  )),
                              obscureText: !_showCmPassword,
                              controller: confPassC,
                              onChanged: (v) => setState(
                                () {
                                  confPass = v;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                new MaterialButton(
                    child: Text(
                      getTranslated(context, "CANCEL")!,
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: lightBlack, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                new MaterialButton(
                  child: Text(
                    getTranslated(context, "SAVE_LBL")!,
                    style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                        color: fontColor, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    final form = _formKey.currentState!;
                    if (form.validate()) {
                      curPass = curPassC!.text;
                      newPass = newPassC!.text;
                      form.save();
                      setState(
                        () {
                          Navigator.pop(context);
                        },
                      );
                       changePassWord();
                    }
                  },
                )
              ],
            );
          },
        );
      },
    );
  }*/
  _showDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                      child: Text(
                        getTranslated(context, "CHANGE_PASS_LBL")!,
                        style: Theme.of(this.context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: fontColor),
                      ),
                    ),
                    Divider(color: lightBlack),
                    Form(
                      key: _formKey,
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: TextField(
                              // cursorColor: Color(0xffFF00FF) ,
                              controller: curPassC,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Current Password",
                              ),
                              obscureText: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: TextField(
                              controller: newPassC,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "New Password",
                              ),
                              obscureText: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: TextField(
                              controller: confPassC,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Confirm Password",
                              ),
                              obscureText: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                new MaterialButton(
                    child: Text(
                      getTranslated(context, "CANCEL")!,
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: lightBlack, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                new MaterialButton(
                  child: Text(
                    getTranslated(context, "SAVE_LBL")!,
                    style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                        color: fontColor, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (curPassC!.text.isNotEmpty) {
                      if (newPassC!.text == confPassC!.text) {
                        changePassWord();
                      } else {
                        setSnackbar("Password Not Match");
                      }
                    } else {
                      setSnackbar("Current Password is Required");
                    }
                  },
                )
              ],
            );
          },
        );
      },
    );
  }
//==============================================================================
//==================== Same API But Only PassPassword ==========================

  Future<void> changePassWord() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var parameter = {
        Id: CUR_USERID,
        Name: name ?? "",
        Mobile: mobile ?? "",
        Email: email ?? "",
        Address: address ?? "",
        Storename: storename ?? "",
        Storeurl: storeurl ?? "",
        storeDescription: storeDesc ?? "",
        accountNumber: accNo ?? "",
        accountName: accname ?? "",
        bankCode: bankcode ?? "",
        bankName: bankname ?? "",
        Latitude: latitutute ?? "",
        Longitude: longitude ?? "",
        taxName: taxname ?? "",
        taxNumber: taxnumber ?? "",
        panNumber: pannumber ?? "",
        STATUS: status ?? "1",
        OLDPASS: curPassC,
        NEWPASS: newPassC,
        "adhar_no": newAdhar ?? "",
        'fassai_number': userfassai ?? "",
      };
      apiBaseHelper.postAPICall(updateUserApi, parameter).then(
        (getdata) async {
          bool error = getdata["error"];
          String? msg = getdata["message"];
          print("11111111111111111111111111${updateUserApi}");
          print("update paramters here" + parameter.toString());
          print(getdata["data"]);
          if (!error) {
            Navigator.pop(context);
            setSnackbar(msg!);
          } else {
            Navigator.pop(context);
            setSnackbar(msg!);
          }
        },
        onError: (error) {
          setSnackbar(error.toString());
        },
      );
    } else {
      Future.delayed(Duration(seconds: 2)).then(
        (_) async {
          await buttonController!.reverse();
          setState(
            () {
              _isNetworkAvail = false;
            },
          );
        },
      );
    }
  }
//==============================================================================
//============================== LoginBtn ======================================

  updateBtn() {
    return AppBtn(
      title: getTranslated(context, "Update Profile")!,
      btnAnim: buttonSqueezeanimation,
      btnCntrl: buttonController,
      onBtnSelected: () async {
        _playAnimation();
        checkNetwork();
      },
    );
  }
//==============================================================================
//========================= circular Progress ==================================

  Widget showCircularProgress(bool _isProgress, Color color) {
    if (_isProgress) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

//==============================================================================
//========================= everything is completed ============================

}
