import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Helper/Constance/const_text.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_button.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_widgets.dart';
import 'package:social_app/Helper/Widgets/Defaults/default_textformfield.dart';
import 'package:social_app/Helper/Widgets/Defaults/defualt_expandedauth.dart';
import 'package:social_app/Model/user_model.dart';
import 'package:social_app/Update/Functions/profile_funcations.dart';
import 'package:social_app/Update/State/image_state.dart';
import 'package:social_app/Update/State/switch_state.dart';
import 'package:social_app/Views/Main/condition_builder.dart';


class MobileProfileUpdatePage extends ConsumerStatefulWidget {
  final UserModel userModel;

  const MobileProfileUpdatePage({Key? key,required this.userModel}) : super(key: key);

  @override
  ConsumerState<MobileProfileUpdatePage> createState() => _MobileProfileUpdatePageState();
}

class _MobileProfileUpdatePageState extends ConsumerState<MobileProfileUpdatePage>
with _MobileProfileUpdate {

  @override
  void dispose() {
    super.dispose();
    _firstController.dispose();
    _lastController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _firstController.text = widget.userModel.first;
    _lastController.text = widget.userModel.last;
    _bioController.text = widget.userModel.bio;
     final ThemeData _theme = Theme.of(context);
     final Size _mediaQ = MediaQuery.of(context).size;


    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus() ,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: WillPopScope(
          onWillPop: () async {
            try {
              return await FunctionsProfile.willPopScope(
                  context: context,
                  ref: ref ,
                  provImage: _provImage ,
                  first: _firstController.text ,
                  last: _lastController.text ,
                  globalKey: _globalKey ,
                  bio: _bioController.text ,
                  userModel: widget.userModel ,
                  indicatorState: _indicatorProv
              );
            }catch(e){
              return false;
            }

          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: CustomText(text: '${TextTranslate.translateText(EnumLang.textUpdate.name, context)}',
              fontSize: 20.0,
              ),
            ),

            body: Form(
              key: _globalKey ,
              child: ListView(
                children: [

                  SizedBox(height: _mediaQ.height * 0.1,) ,


                  Consumer(
                     builder:(context,imageProv,_)=> GestureDetector(
                       onTap: () async {
                         await showDialog(context: context, builder: (context)=>AlertDialog(
                           title: const CustomText(text:'are you sure? '),
                           actions: [
                             CustomElevatedButton(
                               onPressed: (){
                                 imageProv.read(_provImage).getImagePicker(
                                     context: context,
                                     imageSource: ImageSource.gallery
                                 ).then((value)=>Navigator.maybePop(context));
                               },
                               child: const CustomText(text: 'Gallery',) ,
                             ),
                             CustomElevatedButton(
                               onPressed: (){
                                 imageProv.read(_provImage).getImagePicker(
                                     context: context,
                                     imageSource: ImageSource.camera
                                 ).then((value) => Navigator.of(context).maybePop());
                               },
                               child: const CustomText(text: 'Camera',) ,
                             ),
                           ],
                         ));

                       },
                       child: CircleAvatar(
                        radius: 70.0 ,
                        backgroundColor:imageProv.read(_provImage).fileImage == null ? _theme.scaffoldBackgroundColor : null,
                        backgroundImage:imageProv.watch(_provImage).fileImage == null ? null :  FileImage(imageProv.read(_provImage).fileImage!) ,
                        child: Visibility(
                          visible: imageProv.read(_provImage).fileImage == null ? true : false,
                          child: const Icon(Icons.image,size: 50.0,),
                        )),
                     ),
                   ) ,


                  SizedBox(height: _mediaQ.height * 0.05,) ,


                  Row(
                    children: [

                      const Spacer(flex: 1,),

                      Expanded(
                        flex: 12,
                        child: DefaultTextFormField(
                          controller: _firstController,
                            validator: (String? v){
                            return ConstValidator.validatorName(v);
                            },
                            inputType: TextInputType.name,
                            inputAction: TextInputAction.next ,
                          hint: 'First Name',
                        ),
                      ) ,

                      const Spacer(flex: 1,),

                      Expanded(
                        flex: 12,
                        child: DefaultTextFormField(
                          controller: _lastController,
                            validator: (String? v){
                              return ConstValidator.validatorName(v);
                            },
                            inputType: TextInputType.name,
                            inputAction: TextInputAction.next ,
                          hint: 'Last Name',
                        ),
                      ) ,

                      const Spacer(flex: 1,),

                    ],
                  ) ,


                  SizedBox(height: _mediaQ.height * 0.03,) ,


                  DefaultExpandedAuth(
                      child: DefaultTextFormField(
                        controller: _bioController,
                        validator: (String? v) {
                          return v!.isEmpty ? null : null;
                          },
                        inputType: TextInputType.text,
                        inputAction: TextInputAction.done ,
                        hint: 'Enter your bio',
                      )),


                  SizedBox(height: _mediaQ.height * 0.03,) ,


                  Consumer(
                    builder:(context,_provIndicator,_)=> AnimatedConditionalBuilder(
                        condition: _provIndicator.watch(_indicatorProv).varSwitch,
                        builder: (BuildContext context){
                          return CustomElevatedButton(
                              onPressed: () async {
                                FunctionsProfile.uploadedProfile(
                                    context: context,
                                    first: _firstController.text,
                                    last: _lastController.text,
                                    bio: _bioController.text,
                                    widgetRef: ref,
                                    globalKey: _globalKey,
                                    provImage: _provImage,
                                    userModel: widget.userModel ,
                                    indicatorState: _indicatorProv
                                );

                              }, child: const CustomText(text: 'Update',));
                        },
                        fallback: (BuildContext context)=>loadingProvider())
                  ) ,


                  Consumer(
                    builder:(context,_state,_)=> Visibility(
                      visible:_state.watch(_provImage).fileImage == null || !_state.watch(_indicatorProv).varSwitch ? false : true,
                      child: CustomElevatedButton(
                          onPressed: (){
                            _state.read(_provImage).deleteImagePicker();
                            }, child: const CustomText(text: 'Delete Image',)),
                    ),
                  ) ,

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

mixin _MobileProfileUpdate {
  final _provImage = ChangeNotifierProvider<ImageState>((ref)=>ImageState());
  final _indicatorProv =  ChangeNotifierProvider<SwitchState>((ref)=>SwitchState());
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
}

