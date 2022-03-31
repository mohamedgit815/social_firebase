import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/Helper/Constance/const_firebase.dart';
import 'package:social_app/Helper/Constance/const_text.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_button.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_widgets.dart';
import 'package:social_app/Model/user_model.dart';
import 'package:social_app/Update/State/switch_state.dart';




class AuthFunctions {
   static Future<void> updateToken() async {
       return await fireStore.collection(fireStoreUser).doc(firebaseId).update({
         'token': '${await firebaseMessaging.getToken()}'
       });
  }

  static Future<void> loginAuth({
    required String email, required String password,
    required GlobalKey<FormState> globalKey , required String route ,
    required BuildContext context , required WidgetRef state ,
    required ChangeNotifierProvider<SwitchState> indicatorState
  }) async {
    try {
      FocusScope.of(context).unfocus();
       globalKey.currentState!.save();
      if (globalKey.currentState!.validate()) {
        state.read(indicatorState).falseSwitch();
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);

        await Navigator.of(context).pushNamedAndRemoveUntil(
            route, (route) => false);

        state.read(indicatorState).trueSwitch();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        customSnackBar(text: '${e.message}', context: context);
      } else if (e.code == 'wrong-password') {
        customSnackBar(text: '${e.message}', context: context);
      } else if (e.code == 'email-already-in-use') {
        customSnackBar(text: '${e.message}', context: context);
      } else if (e.code == 'network-request-failed') {
        customSnackBar(text: '${e.message}', context: context);
      } else if(e.code == 'invalid-email'){
        customSnackBar(text: '${e.message}', context: context);
      }
      state.read(indicatorState).trueSwitch();
    }
  }

  static Future<void> registerAuth({
    required GlobalKey<FormState> globalKey, required String route,
    required String first, required String email, required String last,
    required String password, required BuildContext context ,
    required ChangeNotifierProvider<SwitchState> indicatorState,
    required WidgetRef state ,
  }) async {
    try {
      globalKey.currentState!.save();
      if (globalKey.currentState!.validate()) {
        state.read(indicatorState).falseSwitch();
        await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          await _postUserData(
            user: value,
            first: first,
            last: last ,
          );
          await value.user!.sendEmailVerification();
        });

        state.read(indicatorState).trueSwitch();

        globalKey.currentState!.reset();

        await Navigator.of(context).pushNamedAndRemoveUntil(
            route, (route) => false);
        customSnackBar(text: 'Account Created', context: context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        customSnackBar(text: '${e.message}', context: context);
      } else if (e.code == 'user-not-found') {
        customSnackBar(text: '${e.message}', context: context);
      } else if (e.code == 'wrong-password') {
        customSnackBar(text: '${e.message}', context: context);
      } else if (e.code == 'email-already-in-use') {
        customSnackBar(text: '${e.message}', context: context);
      } else if (e.code == 'network-request-failed') {
        customSnackBar(text: '${e.message}', context: context);
      }
      state.read(indicatorState).trueSwitch();
    }
  }



  static Future<void> resetEmailAuth({
    required GlobalKey<FormState> globalKey ,
    required String email ,
    required BuildContext context ,
    required ChangeNotifierProvider<SwitchState> indicatorState,
    required WidgetRef state ,
    required String route
  }) async {
    try {
      globalKey.currentState!.save();
      if (globalKey.currentState!.validate()) {
        state.read(indicatorState).falseSwitch();

        await firebaseAuth.sendPasswordResetEmail(email: email);

        await updateToken();

        customSnackBar(text: 'Request Send', context: context);

        state.read(indicatorState).trueSwitch();

        globalKey.currentState!.reset();

        customSnackBar(text: 'Check your Email', context: context);

        Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        customSnackBar(text: 'User Not Found', context: context);
      }
      state.read(indicatorState).trueSwitch();
    }
  }


  static Future<void> checkOldPassword({
    required String old , required WidgetRef ref ,
    required ChangeNotifierProvider<SwitchState> state ,
    required BuildContext context ,required GlobalKey<FormState> globalKey ,
    required ChangeNotifierProvider<SwitchState> indicatorState
  }) async {
    if(globalKey.currentState!.validate()) {
      ref.read(indicatorState).falseSwitch();
      final User? user = FirebaseAuth.instance.currentUser;
      final AuthCredential credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: old
      );
      await user.reauthenticateWithCredential(credential).then((value) {
        ref.read(state).falseSwitch();
        ref.read(indicatorState).trueSwitch();
      }).catchError((err) {
        ref.read(indicatorState).trueSwitch();
        customSnackBar(
            text: 'Enter your old password by right form', context: context);
      });
      ref.read(indicatorState).trueSwitch();
    }
  }


  static Future<void> changePassword({
    required String newPw , required BuildContext context,
    required GlobalKey<FormState> globalKey , required WidgetRef widgetRef,
    required ChangeNotifierProvider<SwitchState> indicatorState
  }) async {
    if(globalKey.currentState!.validate()) {
      widgetRef.read(indicatorState).falseSwitch();
      return await firebaseAuth.currentUser!.updatePassword(newPw)
          .then((value) async {
        customSnackBar(text: 'Success Updated', context: context);
        widgetRef.read(indicatorState).trueSwitch();
        // await Navigator.pushNamedAndRemoveUntil(
        //     context, OnGenerateRoute.mainScreen, (route) => false);
      }).catchError((err) {
        widgetRef.read(indicatorState).trueSwitch();
        customSnackBar(text: err.toString(), context: context);
      }
      );
    }
  }



  static Future<void> signOut(BuildContext context) async {
    return await showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
      title: CustomText(text: '${TextTranslate.translateText(EnumLang.textSure.name, context)}',),
      actions: [
        CustomElevatedButton(onPressed: (){
          Navigator.pop(context);
        }, child: CustomText(text: '${TextTranslate.translateText(EnumLang.textNo.name, context)}',)),


        CustomElevatedButton(onPressed: ()async {
          await firebaseAuth.signOut();
          return await SystemNavigator.pop();
        }, child: CustomText(text: '${TextTranslate.translateText(EnumLang.textYes.name, context)}',)),
      ],
    ));

  }


  /// Firebase Authentications \\\

  static Future<void> _postUserData({required UserCredential user,required String first ,required String last})async {
    final UserModel userModel = UserModel(
      first: first,
      last: last,
      email: user.user!.email.toString(),
      image: '',
      id: user.user!.uid,
      bio: '',
      date: Timestamp.now(),
      token: '${await firebaseMessaging.getToken()}'
    );
    await fireStore.collection('User').doc(user.user!.uid).set(userModel.toApp());
  }



  static final fetchUserData = StreamProvider<DocumentSnapshot<Map<String,dynamic>>>((ref)  {
    return  fireStore.collection(fireStoreUser).doc(firebaseId).snapshots();
  });


  static Stream<DocumentSnapshot<Map<String,dynamic>>> getUserData() {
    return  fireStore.collection(fireStoreUser).doc(firebaseId).snapshots();
  }

   static Stream<DocumentSnapshot<Map<String,dynamic>>> getUserDataById(String id) {
     return  fireStore.collection(fireStoreUser).doc(id).snapshots();
   }

  /// Firebase Authentications \\\
}