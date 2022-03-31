import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Helper/Constance/const_state.dart';
import 'package:social_app/Helper/Constance/const_text.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_button.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_widgets.dart';
import 'package:social_app/Model/user_model.dart';
import 'package:social_app/Update/Functions/posts_functions.dart';
import 'package:social_app/Update/State/image_state.dart';
import 'package:social_app/Update/State/switch_state.dart';
import 'package:social_app/Views/Main/condition_builder.dart';

class MobilePostsPage extends ConsumerStatefulWidget {
  const MobilePostsPage({Key? key}) : super(key: key);

  @override
  _MobileChatPageState createState() => _MobileChatPageState();
}

class _MobileChatPageState extends ConsumerState<MobilePostsPage>
    with _MobilePosts{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).autofocus(_focusNode);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  GestureDetector build(BuildContext context) {
    final bool _keyBoard = MediaQuery.of(context).viewInsets.bottom == 0;
    final Size _mediaQ = MediaQuery.of(context).size;
    final ThemeData _theme = Theme.of(context);

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldState ,

        appBar: _buildAppBar(context , _scaffoldState),

        body: LayoutBuilder(
          builder:(BuildContext context, constraints) => ListView(
            children: [
              Builder(
                builder: (BuildContext context) {
                  return _buildWritePosts(
                  keyBoard: _keyBoard ,
                      constraints: constraints ,
                      mediaQ: _mediaQ ,
                      theme: _theme ,
                    ref: ref ,
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }


}


class _MobilePosts {
  final _imageProv = ChangeNotifierProvider<ImageState>((ref)=>ImageState());
  final _textProv = ChangeNotifierProvider<SwitchState>((ref)=>SwitchState());
  final _indicatorProv = ChangeNotifierProvider<SwitchState>((ref)=>SwitchState());
  final GlobalKey<ScaffoldMessengerState> _scaffoldState = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _postsController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final InputBorder _borderNone = InputBorder.none;

  /// Scaffold

  // Appbar
  AppBar _buildAppBar(BuildContext context , GlobalKey<ScaffoldMessengerState> messengerState) {
    return AppBar(
      centerTitle: true ,
      title: const CustomText(
        text: 'Posts',
        fontSize: 24.0,
      ),
      actions: [
        Consumer(
          builder:(BuildContext context,prov,_)=> AnimatedVisibility(
            visible: prov.read(_imageProv).fileImage == null && prov.watch(_textProv).value.isEmpty? false : true,
            child: _uploadData(context, prov, messengerState),
          ),
        ),

        Consumer(
          builder:(context,prov,_)=> AnimatedConditionalBuilder(
            condition: prov.watch(_imageProv).fileImage == null,
            builder: (context){
              return _getImagePicker(context, prov);
            },
            fallback: (context){
              return IconButton(
                  onPressed: (){
                    prov.read(_imageProv).deleteImagePicker();
                  },
                  icon: const Icon(Icons.close));
            },
          ),
        ),

      ],
    );
  }

  /// Body... Build Posts UI

  // Build Posts UI
  SizedBox _buildWritePosts({
    required bool keyBoard ,
    required BoxConstraints constraints ,
    required Size mediaQ ,
    required ThemeData theme ,
    required WidgetRef ref

  }) {
    return SizedBox(
      height:keyBoard ?constraints.maxHeight : mediaQ.height * 0.7,
      child: Consumer(
          builder: (context,pro,_) {
            return Column(
              children: [
                Expanded(
                  child: Card(
                    child: TextFormField(
                      focusNode: _focusNode ,
                      controller: _postsController ,
                      maxLines: 50 ,
                      cursorColor: theme.primaryColor ,
                      textInputAction: TextInputAction.unspecified ,
                      keyboardType: TextInputType.text ,
                      onChanged: (v){
                        ref.read(_textProv).funcChange(v);
                      },
                      style: const TextStyle(
                          fontSize: 19.0
                      ),
                      decoration: InputDecoration(
                        hintText: 'Write a Posts',
                        border:  _borderNone ,
                        focusedBorder: _borderNone ,
                        disabledBorder: _borderNone ,
                        enabledBorder: _borderNone ,
                        errorBorder: _borderNone ,
                        focusedErrorBorder: _borderNone ,
                      ),
                    ),
                  ),
                ),

                Consumer(
                  builder:(context,prov,_)=> AnimatedVisibility(
                    visible: prov.watch(_imageProv).fileImage == null ? false : true,
                    child: Builder(
                      builder:(context)=> AnimatedContainer(
                        height: keyBoard ? constraints.maxHeight * 0.5 : mediaQ.height * 0.3,
                        width: double.infinity ,
                        duration: const Duration(milliseconds: 500),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(prov.read(_imageProv).fileImage!)
                            )
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          }
      ),
    );
  }

  /// Functions

  IconButton _getImagePicker(BuildContext context,WidgetRef ref){
    return IconButton(
        onPressed: (){
          showDialog(context: context, builder: (context){
            return AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceAround,
              actions: [

                CustomElevatedButton(
                    onPressed: (){
                      ref.read(_imageProv).getImagePicker(
                          context: context,
                          imageSource: ImageSource.gallery
                      );
                    }, child: const Text('Gallery')),

                CustomElevatedButton(onPressed: (){
                  ref.read(_imageProv).getImagePicker(
                      context: context,
                      imageSource: ImageSource.camera
                  );
                }, child: const Text('Camera')),
              ],
            );
          });
        },
        icon: const Icon(Icons.image)
    );
  }


  IconButton _uploadData(BuildContext mainContext,WidgetRef ref , GlobalKey<ScaffoldMessengerState> messengerState){
    return IconButton(
        onPressed: (){
          showDialog(context: mainContext, builder: (BuildContext context){
            return Builder(
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('${TextTranslate.translateText(EnumLang.textSure.name, context)}'),
                  actionsAlignment: MainAxisAlignment.spaceAround,
                  actions: [
                    CustomElevatedButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        }, child: Text('${TextTranslate.translateText(EnumLang.textNo.name, context)}')) ,


                    AnimatedConditionalBuilder(
                        condition: ref.read(_indicatorProv).varSwitch,
                        builder: (BuildContext context){
                          return Consumer(
                            builder: (BuildContext context,provMyData,_) {
                              return provMyData.watch(myDataProv).when(
                                  error: (err,stack)=> errorProvider(err) ,
                                  loading: ()=> loadingVisibilityProvider() ,
                                data: (myData) {
                                    final UserModel _myData = UserModel.fromApp(myData.data()!);
                                  return CustomElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        await PostsFunctions.uploadPosts(
                                            file: ref.read(_imageProv).fileImage ,
                                            post: _postsController.text ,
                                            state: ref ,
                                            indicatorState: _indicatorProv ,
                                            context: context ,
                                            userModel: _myData
                                        );
                                        _postsController.clear();
                                        ref.read(_textProv).equalNull();
                                        ref.read(_imageProv).deleteImagePicker();
                                       customSnackBar(text: 'The Post Uploaded', context: mainContext);
                                        ref.refresh(fetchHomeProv);
                                        Navigator.pop(mainContext);
                                      }, child: Text('${TextTranslate.translateText(EnumLang.textYes.name, context)}'));
                                }
                              );
                            }
                          );
                        },
                        fallback: (context){
                          return const CircularProgressIndicator.adaptive();
                        }
                    )
                  ],
                );
              }
            );
          });
        },
        icon: const Icon(Icons.cloud_upload)
    );
  }
}