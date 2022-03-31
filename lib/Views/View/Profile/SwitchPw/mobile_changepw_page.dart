import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Helper/Constance/const_text.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_button.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_widgets.dart';
import 'package:social_app/Helper/Widgets/Defaults/default_textformfield.dart';
import 'package:social_app/Helper/Widgets/Defaults/defualt_expandedauth.dart';
import 'package:social_app/Update/Functions/auth_functions.dart';
import 'package:social_app/Update/State/switch_state.dart';
import 'package:social_app/Views/Main/condition_builder.dart';

class MobileChangePwPage extends ConsumerStatefulWidget {
  const MobileChangePwPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileChangePwPage> createState() => _MobileChangePwPageState();
}

class _MobileChangePwPageState extends ConsumerState<MobileChangePwPage>
with _MobileChangePw {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(text: '${TextTranslate.translateText(EnumLang.textChange.name, context)}',
           fontSize: 20.0,
        ),
      ),
      body: Form(
        key: _globalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            DefaultExpandedAuth(
              child: Consumer(
                builder:(context,_prov,_)=> AnimatedConditionalBuilder(
                  duration: const Duration(milliseconds: 250),
                    condition: _prov.watch(_switchProv).varSwitch,
                    builder: (BuildContext nonContext){
                      return Consumer(
                        builder:(nonContext,provOld,_)=> DefaultTextFormField(
                          onChange: (String v){
                             oldPw = v;
                          },
                            validator: (v){
                            return ConstValidator.validatorPw(v);
                            },
                          password: provOld.watch(_visibilityProv).varSwitch,
                            inputType: TextInputType.visiblePassword,
                            inputAction: TextInputAction.done,
                          hint: 'Enter your old Password',
                          onSubmitted: (v) async {
                           return await AuthFunctions.checkOldPassword(
                                old: oldPw,
                                ref: ref,
                                state: _switchProv,
                                context: context,
                               globalKey: _globalKey,
                               indicatorState: _oldIndicatorProv
                            );
                          },
                          suffixIcon: IconButton(
                              onPressed: (){
                                provOld.read(_visibilityProv).funcSwitch();
                              },
                              icon: AnimatedConditionalBuilder(
                                condition: provOld.read(_visibilityProv).varSwitch,
                                builder: (BuildContext context)=>const Icon(Icons.visibility),
                                fallback: (BuildContext context)=>const Icon(Icons.visibility_off_sharp),
                              )
                          ),
                        ),
                      );
                    },
                    fallback: (BuildContext context){
                      return Consumer(
                        builder:(context,provNew,_)=> DefaultTextFormField(
                          onChange: (String v){
                            newPw = v;
                          },
                          validator: (v){
                            return ConstValidator.validatorPw(v);
                          },
                          suffixIcon: IconButton(
                              onPressed: (){
                                provNew.read(_visibilityProv).funcSwitch();
                              },
                              icon: AnimatedConditionalBuilder(
                                condition: provNew.read(_visibilityProv).varSwitch,
                                builder: (BuildContext context)=>const Icon(Icons.visibility),
                                fallback: (BuildContext context)=>const Icon(Icons.visibility_off_sharp),
                              )
                          ),
                          onSubmitted: (v) async {
                            await AuthFunctions.changePassword(
                                newPw: newPw,
                                context: context,
                                globalKey: _globalKey,
                                widgetRef: ref,
                                indicatorState: _newIndicatorProv
                            );
                          },
                          inputType: TextInputType.visiblePassword,
                          inputAction: TextInputAction.done,
                          hint: 'Enter New Password',
                        ),
                      );
                    },),
              ),
            ),



            DefaultExpandedAuth(
              child: Consumer(
                builder:(context,_checkPwProv,_)=> Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0
                  ),
                  child: AnimatedConditionalBuilder(
                    duration: const Duration(milliseconds: 250),
                    condition: _checkPwProv.watch(_switchProv).varSwitch,
                    builder:(context)=> CustomElevatedButton(
                      size: const Size(double.infinity,50.0),
                        onPressed: () async {
                          return await AuthFunctions.checkOldPassword(
                              old: oldPw ,
                              ref: _checkPwProv ,
                              state: _switchProv ,
                              context: context ,
                              globalKey: _globalKey,
                              indicatorState: _oldIndicatorProv
                          );
                    }, child: const CustomText(
                      text: 'Check Password',
                      fontSize: 18.0,
                    )),
                    fallback: (context)=>CustomElevatedButton(
                        onPressed: () async {
                          return await AuthFunctions.changePassword(
                              newPw: newPw ,
                              context: context ,
                              globalKey: _globalKey,
                              indicatorState: _newIndicatorProv,
                              widgetRef: _checkPwProv
                          );
                        }, child: const CustomText(text: 'Updated Password',)),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}

mixin _MobileChangePw {
  final _switchProv = ChangeNotifierProvider((ref)=>SwitchState());
  final _oldIndicatorProv = ChangeNotifierProvider((ref)=>SwitchState());
  final _newIndicatorProv = ChangeNotifierProvider((ref)=>SwitchState());
  final _visibilityProv = ChangeNotifierProvider((ref)=>SwitchState());
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  late String newPw = '' , oldPw = '';
}

