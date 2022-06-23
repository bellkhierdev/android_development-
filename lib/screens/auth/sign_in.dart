//version 1.0.0+1

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:issue/export.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

enum Loading { loading, loaded }

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  late bool validate = false;
  final _formKey = GlobalKey<FormState>();
  late ThemeData themeData;

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    systemTheme(themeData);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: FuAppTheme.isDarkMode == false
              ? Colors.white
              : themeData.scaffoldBackgroundColor,
          body: Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -20.w,
                  right: -20.w,
                  child: Container(
                    width: 80.w,
                    height: 65.w,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [UtilsAuth.color1, UtilsAuth.color3],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                  ),
                ),
                Positioned(
                  top: -30.w,
                  left: -30.w,

                  child: Container(
                    child: Center(
                      child: Container(
                          alignment: const Alignment(0.2, 0.2),
                          child: Text(
                            'تسجيل دخول',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 11.sp,
                                fontFamily: 'Cairo',
                                color: StyleWidget.white),
                          )),
                    ),
                    width: context.width * 7 / 8,
                    height: context.width * 7 / 8,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [
                              UtilsAuth.color1,
                              UtilsAuth.color2,
                              UtilsAuth.color4
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                  ),
                ),
                Positioned(
                  bottom: -context.width * 7 / 8 / 2,
                  right: -context.width * 7 / 8 / 2,
                  child: Container(
                    width: context.width * 7 / 8,
                    height: context.width * 7 / 8,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xFFD0D4FF)),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: FuAppTheme.isDarkMode == false
                                ? Colors.white
                                : themeData.scaffoldBackgroundColor,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        margin: const EdgeInsets.fromLTRB(24, 300, 24, 10),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 25),
                        child: Column(
                          children: <Widget>[
                            //this is email
                            Consumer<StateAuth>(
                              builder: (context, provider, child) =>
                                  MyTextFormField(
                                      // autovalidate: null,
                                      controller: _email,
                                      input: InputDecoration(
                                          icon: const Icon(
                                            Icons.email,
                                            color: UtilsAuth.color2,
                                          ),
                                          labelText: "البريد الالكتروني",
                                          labelStyle: TextStyle(
                                            color:
                                                FuAppTheme.isDarkMode == false
                                                    ? UtilsAuth.color2
                                                    : themeData.textTheme
                                                        .bodyText1!.color,
                                          )),
                                      number: TextInputType.emailAddress,
                                      onChanged: () {
                                        return provider.autoValidationEmile(
                                            _email,
                                            "[\u0600-\u06ff]|[\u0750-\u077f]|[\ufb50-\ufc3f]|[\ufe70-\ufefc]");
                                      },
                                      autovalidate: provider.autoTextFieldEmile,
                                      // autovalidate: validate,
                                      validator: (String? val) =>
                                          ErrorResponse.autoValidationEmail(
                                              val,
                                              "يجب ادخال الايميل ",
                                              'الرجاء إدخال 6 احرف با الأقل',
                                              'الرجاء إدخال 255 حرف با الاكثر',
                                              6,
                                              255,
                                              _email,
                                              'يجب إدخال الايميل باللغة الانجليزية',
                                              "[\u0600-\u06ff]|[\u0750-\u077f]|[\ufb50-\ufc3f]|[\ufe70-\ufefc]")),
                            ).paddingAll(8),
                            //this is password
                            Consumer<StateAuth>(
                              builder: (context, provider, child) =>
                                  MyTextFormField(
                                obscureText: provider.obscureText!,
                                controller: _password,
                                input: InputDecoration(
                                    icon: const Icon(
                                      Icons.lock,
                                      color: UtilsAuth.color2,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        provider.obscureText != true
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: provider.obscureText!
                                            ? null
                                            : const Color(0xFFA3A3A3),
                                      ),
                                      onPressed: () {
                                        provider.showAndHidePassword();
                                      },
                                    ),
                                    labelText: "كلمة المرور",
                                    labelStyle: TextStyle(
                                      color: FuAppTheme.isDarkMode == false
                                          ? UtilsAuth.color2
                                          : themeData
                                              .textTheme.bodyText1!.color,
                                    )),
                                number: TextInputType.text,
                                onChanged: () {},
                                validator: (String? val) =>
                                    FuInputValidation.validationTextField(
                                        controller: val,
                                        error: "يجب ادخال كلمة المرور",
                                        lengthMin:
                                            'الرجاء إدخال 8 احرف با الأقل',
                                        lengthMax:
                                            'الرجاء إدخال 1024 حرف با الاكثر',
                                        main: 8,
                                        max: 1024),
                                autovalidate: AutovalidateMode.disabled,
                              ),
                            ).paddingAll(8),
                          ],
                        ),
                      ),
                      const Padding(padding: EdgeInsets.fromLTRB(0, 0, 24, 20)),
                   
                      Container(
                        margin: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) =>
                                        Colors.transparent,
                                  ),
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    singInInUsernamePassword(
                                        _email.text, _password.text);
                                  }
                                },
                                child: Ink(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: <Color>[
                                          UtilsAuth.color1,
                                          UtilsAuth.color2
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Container(
                                      constraints: const BoxConstraints(
                                          maxWidth: 190,
                                          minHeight:
                                              40), // min sizes for Material buttons
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "تسجيل",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      )),
                                )),
                            GestureDetector(
                              onTap: () => UtilsAuth.signInWithGoogle(context).then((value) async=>   await context.read<StateAuth>().isAccountTestIng()),
                              child: Image(
                                image: AssetImage(ImagesUrl.google),
                                width: 10.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          AlreadyHaveAnAccountCheck(
                            // login: false,
                            press: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                CostumeTransition(const SignUpScreen()),
                                (Route<dynamic> route) => false,
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

//this is for sigIn with username and password in firebase
  void singInInUsernamePassword(String email, String password) async {
    var dialogContext;

    bool check = true; //this is for opene or close howDialog

    try {
      //this is UtilsAuth waiting login
      showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (cont) {
            dialogContext = cont;
            // UtilsAuth.checkLoading(cont, loading: UtilsAuth.defaultLoading);
            check != true ? Navigator.pop(cont) : Container();
            return UtilsAuth.willPopScope();
          });

      if (_formKey.currentState!.validate()) {
        return await _auth
            .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((value) async {
          if (value != null) {
            Navigator.pop(dialogContext);
            await ServicesDatabase().clearAllDatabaseTables();
            Fluttertoast.showToast(msg: "تم تسجيل الدخول بنجاح");
            // await FuSharedPreferences.setString('Username',_username );
               await FuSharedPreferences.setBool('TestAccount', false);
                await context.read<StateAuth>().isAccountTestIng();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const NavigationBarScreen()),
              (Route<dynamic> route) => false,
            );
            //this is for save data in shardPreferences
            shaveDataInShardPerf(value);
          } else {
            ErrorResponse.customAwesomeDialog(
                'something wronging', context, DialogType.WARNING);
          }
        });
      }
    } catch (e) {
      if (dialogContext != null) {
        Navigator.pop(dialogContext);
      } else {
        setState(() {
          // UtilsAuth.checkLoading(context, loading: Loading.loaded);
          check = false;
        });
      }
      UtilsAuth.parseError(
        e,
        context,
      );
    }
  }

//this is for save data in shardPreferences
  shaveDataInShardPerf(UserCredential value) async {
    await FuSharedPreferences.setString('UserId', value.user!.uid);
  }
}
