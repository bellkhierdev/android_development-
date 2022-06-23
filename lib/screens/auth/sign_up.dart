//version 1.0.0+1

import 'package:issue/export.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  late AutovalidateMode validate = AutovalidateMode.disabled;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _username.dispose();
    _email.dispose();
    _password.dispose();
  }

  // firebase
  final _auth = FirebaseAuth.instance;
  late ThemeData themeData;
  // string for displaying the error Message
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    double getSmallDiameter(BuildContext context) {
      return context.width * 2 / 3;
    }

    double getBigDiameter(BuildContext context) {
      return context.width * 7 / 8;
    }

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
                            'انشاء حساب جديد',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Cairo',
                                fontSize: 11.sp,
                                color: StyleWidget.white),
                          )),
                    ),
                    width: getBigDiameter(context),
                    height: getBigDiameter(context),
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
                  bottom: -getBigDiameter(context) / 2,
                  right: -getBigDiameter(context) / 2,
                  child: Container(
                    width: getBigDiameter(context),
                    height: getBigDiameter(context),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xFFD0D4FF)),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ListView(
                    padding: EdgeInsets.only(bottom: 24.sp),
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: FuAppTheme.isDarkMode == false
                                ? Colors.white
                                : themeData.scaffoldBackgroundColor,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        margin: const EdgeInsets.fromLTRB(24, 250, 24, 10),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 25),
                        child: Column(
                          children: <Widget>[
                            //this is user name
                            MyTextFormField(
                              controller: _username,
                              input: InputDecoration(
                                  icon: const Icon(
                                    Icons.person,
                                    color: UtilsAuth.color2,
                                  ),
                                  labelText: "اسم المستخدم",
                                  labelStyle: TextStyle(
                                      color: FuAppTheme.isDarkMode == false
                                          ? UtilsAuth.color2
                                          : themeData
                                              .textTheme.bodyText1!.color)),
                              number: TextInputType.text,
                              onChanged: () {
                                validate = AutovalidateMode.onUserInteraction;
                              },
                              validator: (String? val) =>
                                  ErrorResponse.customValidationTextField(
                                      val,
                                      "يجب ادخل  الاسم المستخدم",
                                      'الرجاء إدخال 3 احرف با الأقل',
                                      'الرجاء إدخال 35 حرف با الاكثر',
                                      3,
                                      35),
                              autovalidate: validate,
                            ).paddingAll(8),
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
                                                          .bodyText1!.color)),
                                      number: TextInputType.emailAddress,
                                      onChanged: () {
                                        return provider.autoValidationEmile(
                                            _email,
                                            "[\u0600-\u06ff]|[\u0750-\u077f]|[\ufb50-\ufc3f]|[\ufe70-\ufefc]");
                                      },
                                      autovalidate: provider.autoTextFieldEmile,
                                      validator: (String? val) =>
                                          ErrorResponse.autoValidationEmail(
                                              val,
                                              "يجب ادخال البريد الالكتروني",
                                              'الرجاء إدخال 6 احرف با الأقل',
                                              'الرجاء إدخال 255 حرف با الاكثر',
                                              6,
                                              255,
                                              _email,
                                              'يجب إدخال البريد الالكتروني باللغة الانجليزية',
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
                                                .textTheme.bodyText1!.color)),
                                number: TextInputType.text,
                                onChanged: () {},
                                autovalidate: AutovalidateMode.disabled,
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
                              ),
                            ).paddingAll(8),
                          ],
                        ),
                      ),
                      //this is widget doing create account
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
                                onPressed: () =>
                                    submitSignUp(_email.text, _password.text),
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
                                        "انشاء",
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
                      10.height,
                      //this is check already have account or no
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          AlreadyHaveAnAccountCheck(
                            login: false,
                            press: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                CostumeTransition(const SignInScreen()),
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

  //this is signUp with firebase
  void submitSignUp(String email, String password) async {
    //this is loading UtilsAuth
    var dialogContext;

    bool check = true;

    if (_formKey.currentState!.validate()) {
      try {
        //this is UtilsAuth waiting signup
        showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (cont) {
              dialogContext = cont;
              check != true ? Navigator.pop(cont) : Container();
              return UtilsAuth.willPopScope();
            });

        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          if (value != null) {
            await ServicesDatabase().clearAllDatabaseTables();
            await FuSharedPreferences.setString('UserId', value.user!.uid);
            await FuSharedPreferences.setString('Username', _username.text);
               await FuSharedPreferences.setBool('TestAccount', false);
                await context.read<StateAuth>().isAccountTestIng();
            Navigator.pop(dialogContext);
            Navigator.pushAndRemoveUntil(
              context,
              CostumeTransition(const NavigationBarScreen()),
              (Route<dynamic> route) => false,
            );
          }
        });

        
      } catch (e) {
        FuLog('Error createUserWithEmailAndPassword ===> $e');
        if (dialogContext != null) {
          Navigator.pop(dialogContext);
        } else {
          setState(() {
            check = false;
          });
          // UtilsAuth.checkLoading(context, loading: Loading.loaded);
        }
        UtilsAuth.parseError(
          e,
          context,
        );
      }
    }
  }
}
