import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:path/path.dart';
import 'package:shake_wallpaper/constants/keywords.dart';
import 'package:shake_wallpaper/models/userModel.dart';
import 'package:shake_wallpaper/services/firebaseStorageService.dart';
import 'package:shake_wallpaper/services/firestoreService.dart';
import 'package:shake_wallpaper/widgets/bottomSheet.dart';
import 'package:shake_wallpaper/widgets/custom_text_field.dart';

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class CustomerRegistration extends StatefulWidget {
  @override
  _CustomerRegistrationState createState() => _CustomerRegistrationState();
}

class _CustomerRegistrationState extends State<CustomerRegistration> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserData _userData = UserData();
  PickedFile _profilePic;

  bool imageError = false;
  FirestoreService _firestoreService;

  FocusNode _blankFocusNode = FocusNode();

  List<ListItem> _dropdownItems = [
    ListItem(1, APP_USER),
    ListItem(2, APP_ADMIN),
  ];

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = <DropdownMenuItem<ListItem>>[];
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
    _userData.role = _selectedItem.name;
  }

  String requiredValidator(value) {
    if (value.length == 0) {
      return 'field can not be empty';
    } else {
      _formKey.currentState.save();
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _firestoreService = Provider.of<FirestoreService>(context);
    var heightPiece = MediaQuery.of(context).size.height / 10;
    var widthPiece = MediaQuery.of(context).size.width / 10;
    return Scaffold(
      body: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(_blankFocusNode);
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: heightPiece / 2),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  circularProfilePicWithEditOption(widthPiece, context),
                  (imageError == true)
                      ? Text(
                          'Please Upload Image',
                          style: TextStyle(color: Colors.red),
                        )
                      : Container(),
                  SizedBox(height: 20),
                  customTextFieldForName(widthPiece),
                  SizedBox(height: 20),
                  customTextFieldForAddress(widthPiece),
                  SizedBox(height: 20),
                  buildDropdownButton(),
                  SizedBox(height: 20),
                  customButtonToUpdateUserDocInDatabase(widthPiece, context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  DropdownButton<ListItem> buildDropdownButton() {
    return DropdownButton(
      value: _selectedItem,
      items: _dropdownMenuItems,
      onChanged: (ListItem item) {
        _selectedItem = item;
        _userData.role = item.name;
        setState(() {});
      },
    );
  }

  Row circularProfilePicWithEditOption(
      double widthPiece, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: widthPiece / 2),
        circularProfilePic(widthPiece),
        camerButtonToEditPic(widthPiece, context),
      ],
    );
  }

  Padding camerButtonToEditPic(double widthPiece, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widthPiece * 3),
      child: IconButton(
        icon: Icon(
          Icons.camera_alt,
          size: 30.0,
        ),
        onPressed: () {
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: ((builder) => BottomSheetWidget((image) {
                    setState(() {
                      _profilePic = image;
                      print('${image}');
                    });
                  })));
        },
      ),
    );
  }

  Align circularProfilePic(double widthPiece) {
    return Align(
      alignment: Alignment.center,
      child: CircleAvatar(
        radius: (widthPiece * 2) + 5,
        backgroundColor: Color(0xff476cfb),
        child: ClipOval(
          child: new SizedBox(
            width: widthPiece * 4,
            height: widthPiece * 4,
            child: (_profilePic != null)
                ? Image.file(
                    File(_profilePic.path),
                    fit: BoxFit.fill,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Padding customButtonToUpdateUserDocInDatabase(
      double widthPiece, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthPiece),
      child: RaisedButton(
        padding: const EdgeInsets.only(bottom: 6.0, top: 8.0),
        color: Colors.white,
        onPressed: () async {
          // _firestoreService.natureWallpaperData();
          _firestoreService.currentUserDocData
              .then((value) => print(value.data()));
        if ( _formKey.currentState.validate()){

          var profilePicUrl;
          if (_profilePic != null) {
            try {
              //upload file as a profile pic for user
             profilePicUrl= await FirebaseStorageService().uploadProfilePicAndGetUrl(
                  imageName: _firestoreService.phoneNo, file: _profilePic);
                  _userData.profilePicUrl=profilePicUrl;
            } catch (e) {
              print(e);
            }
          } else {
            setState(() {
              imageError = true;
            });
            return;
          }
          _firestoreService.createUserDoc(_userData);}
        },
        child: Text(
          'Register',
          style: TextStyle(color: Color(0xffF57921)),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.white)),
      ),
    );
  }

  Padding customTextFieldForAddress(double widthPiece) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: widthPiece),
        child: CustomTextField(
          hintText: 'Enter your address',
          inputType: TextInputType.streetAddress,
          onSaved: ((value) {
            _userData.address = value;
          }),
          validator: requiredValidator,
        ));
  }

  Padding customTextFieldForName(double widthPiece) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: widthPiece),
        child: CustomTextField(
          hintText: 'Enter Full Name',
          inputType: TextInputType.name,
          onSaved: ((value) {
            _userData.name = value;
          }),
          validator: requiredValidator,
        ));
  }
}
