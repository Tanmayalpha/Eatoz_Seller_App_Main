import 'dart:convert';
import 'dart:io';
import 'package:eshopmultivendor/Helper/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:eshopmultivendor/Model/ProductModel/Product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Helper/Color.dart';
import '../Helper/Session.dart';

class AddonEdit extends StatefulWidget {
  final List<AddOnModel>? addOnModel;
  final int? index;

  AddonEdit({this.addOnModel,this.index});

  @override
  State<AddonEdit> createState() => _AddonEditState();
}

class _AddonEditState extends State<AddonEdit> {

  TextEditingController addonNameController = TextEditingController();
  TextEditingController addonPriceController = TextEditingController();
  File? addonImage;

  List<String> addonImageList = [];

  updateProduct()async{
    print("updates add on api worikngg");
    var headers = {
      'Cookie': 'ci_session=2a1db53a991ef210a3d9bb520ce95ba387710edf'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}update_addon'));
    request.fields.addAll({
      'add_name_app': addonNameController.text,
      'add_price_app': addonPriceController.text,
      'add_on_id': '${widget.addOnModel![widget.index!].id}'
    });
   print("Aaddd onn parametyeer ${request.fields}");
  // if(addonImageList.length != 0){
  //   print("addon list here now ${addonImageList[0]}");
  //   for(var i=0;i<addonImageList.length;i++){
  //     addonImageList == null ? addonImageList.length == 0 :  request.files.add(await http.MultipartFile.fromPath('addon_images[]', addonImageList[i]));
  //   }
  // }
  print("checking parameters are here ${request.fields} and ${request.files}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResult);
      setState(() {
        var snackBar = SnackBar(
          content: Text('${jsonResponse['message']}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
      Navigator.pop(context);
    }
    else {
      print(response.reasonPhrase);
    }
  }
  final picker =  ImagePicker();

  _getFromGallery() async {
    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        addonImage = File(pickedFile.path);
        addonImagevalue = null;
      });
      Navigator.of(context).pop();
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
        addonImage = File(pickedFile.path);
        addonImagevalue = null;
      });
      Navigator.of(context).pop();
    }
  }

  String? addonImagevalue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addonNameController.text = widget.addOnModel![widget.index!].name.toString();
    addonPriceController.text = widget.addOnModel![widget.index!].price.toString();
    addonImageList.add(widget.addOnModel![widget.index!].image.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        "Edit Addon",
        context,
      ),
      body:
      Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all()
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Product Add on",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15),),
                SizedBox(height: 10,),
                Container(
                  child: TextFormField(controller: addonNameController,decoration: InputDecoration(
                      hintText: "Product Name",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),),
                ),
                SizedBox(height: 10,),
                Container(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: addonPriceController,decoration: InputDecoration(
                      hintText: "Product Price",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),),
                ),
                SizedBox(height: 6,),
                // addonImage == null ?
                // MaterialButton(onPressed: ()async{
                //   showDialog(context: context, builder: (context){
                //     return AlertDialog(
                //       title: Text("Select Image option"),
                //       content: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           InkWell(
                //               onTap:(){
                //                 _getFromCamera();
                //               },
                //               child: Text("Click Image from Camera",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),)),
                //           SizedBox(height: 10,),
                //           InkWell(
                //               onTap:(){
                //                 _getFromGallery();
                //               },
                //               child: Text("Upload Image from Gallery",style: TextStyle(color:Colors.black,fontWeight: FontWeight.w500),))
                //         ],
                //       ),
                //     );
                //   });
                // },child:Text("Add Image",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),),color: primary,) :

                Row(
                  children: [
                    addonImageList == null ?    Container(
                      height:50,
                      width: 60,
                      child: Image.file(addonImage!,fit: BoxFit.fill),
                    ) : Container(
                  height: 60,
                  width: 60,
                  child: Image.network("${addonImageList[0]}"),
                ),
                  SizedBox(width: 10,),
                    addonImageList == null ? SizedBox() :  MaterialButton(onPressed: ()async{
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          title: Text("Select Image option"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                  onTap:(){
                                    _getFromCamera();
                                  },
                                  child: Text("Click Image from Camera",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),)),
                              SizedBox(height: 10,),
                              InkWell(
                                  onTap:(){
                                    _getFromGallery();
                                  },
                                  child: Text("Upload Image from Gallery",style: TextStyle(color:Colors.black,fontWeight: FontWeight.w500),))
                            ],
                          ),
                        );
                      });
                    },child:Text("Update Image",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),),color: primary,)

                  ],
                ),

                Align(
                    alignment: Alignment.center,
                    child: MaterialButton(onPressed: (){
                      if(addonPriceController.text.isEmpty && addonPriceController.text.isEmpty && addonImage == null){
                        var snackBar = SnackBar(
                          content: Text('Enter all details'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      else{
                        setState(() {
                          // addonList.add({
                          //   "add_name":addonNameController.text,
                          //   "add_price":addonPriceController.text,
                          //   "addon_images": addonImage!.path.toString(),
                          // });
                          // addonNameList.add(addonNameController[i].text);
                          // addonPriceList.add(addonPriceController[i].text);
                           addonImageList.add(addonImage!.path.toString());

                        });
                      }
                    },child: Text("Upload Addon Product",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15),),color: primary,minWidth: MediaQuery.of(context).size.width/2,)),


              ],
            ),

          ),
          SizedBox(height: 10,),
          MaterialButton(onPressed: (){
            updateProduct();
          },child: Text("Submit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),color: primary,)
        ],

      ),

    );
  }
}
