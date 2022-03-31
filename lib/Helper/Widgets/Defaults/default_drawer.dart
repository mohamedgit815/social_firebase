import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/Helper/Constance/const_colors.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Helper/Constance/const_state.dart';
import 'package:social_app/Helper/Constance/const_text.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_widgets.dart';
import 'package:social_app/Model/user_model.dart';
import 'package:social_app/Update/Functions/auth_functions.dart';
import 'package:social_app/Views/Main/condition_builder.dart';
import 'package:social_app/Views/View/Post/main_posts_screen.dart';
import 'package:social_app/Views/View/Profile/SwitchPw/main_changepw_screen.dart';
import 'package:social_app/Views/View/Profile/Update/main_profileupdate_screen.dart';



class DefaultDrawer extends ConsumerStatefulWidget {
   const DefaultDrawer({Key? key}) : super(key: key);

  @override
  ConsumerState<DefaultDrawer> createState() => _DefaultDrawerState();
}

class _DefaultDrawerState extends ConsumerState<DefaultDrawer>  with _DefaultDrawerClass {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Consumer(
            builder: (context,prov,_) => prov.watch(_myData).when(
                  error: (err,stack)=>errorProvider(err),
                  loading: () => loadingProvider() ,
                data: (myData) {
                  final UserModel _data = UserModel.fromApp(myData.data()!);

                  return UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: _data.image.isEmpty ? normalWhite : null,
                      backgroundImage: _data.image.isEmpty ? null: NetworkImage(_data.image),
                      child: AnimatedConditionalBuilder(
                        condition: _data.image.isEmpty,
                        builder: (context)=> CustomText(
                            text: _data.first.substring(0,1).toString() ,
                          fontSize: 24.0,
                          color: normalBlack,
                          fontWeight: FontWeight.bold,
                        ),
                        fallback: null,
                      ),
                    ),
                    accountName: Text('${_data.first} ${_data.last}') ,
                    accountEmail: AnimatedConditionalBuilder(
                      condition: _data.bio.isEmpty,
                      builder: (context)=>Text(_data.email.toString()),
                      fallback: (context)=>Text(_data.bio.toString()),
                    )
                  );
                }
              )
          ),

          Expanded(
            flex: 1,
            child: Card(
              child: InkWell(
                  onTap: (){
                    showDialog(context: context, builder: (context)=>SimpleDialog(
                      alignment: Alignment.center,
                      title: Align(
                          alignment: Alignment.center,
                          child: Text('${TextTranslate.translateText(EnumLang.textChooseLang.name, context)}')),

                      children: [

                        const Divider(thickness: 1,),

                        _buildLangButton(langName: 'Arabic', ref: ref, lang: EnumLang.arabic.name),
                        _buildLangButton(langName: 'English', ref: ref, lang: EnumLang.english.name),
                        _buildLangButton(langName: 'Español', ref: ref, lang: EnumLang.espanol.name),
                      ],
                    ));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: _langName!,
                      fontSize: 20.0,
                    ),
                  )
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Card(
              child: InkWell(
                  onTap: (){
                    ConstNavigator.pushNamedRouter(route: MainPostsScreen.posts, context: context);
                  },
                  child:Container(
                    margin: const EdgeInsets.all(10.0),
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: '${TextTranslate.translateText(EnumLang.textWrite.name, context)}',
                      fontSize: 20.0,
                    ),
                  )

              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Card(
              child: InkWell(
                  onTap: (){
                    ConstNavigator.pushNamedRouter(route: MainChangePwScreen.changePw, context: context);
                  },
                  child:Container(
                    margin: const EdgeInsets.all(10.0),
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: '${TextTranslate.translateText(EnumLang.textChange.name, context)}',
                      fontSize: 20.0,
                    ),
                  )

              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Consumer(
              builder: (context,prov,_) {

                return prov.watch(_myData).when(
                    error: (err,stack)=>errorProvider(err),
                    loading: ()=>loadingProvider() ,
                  data: (myData) {
                    final UserModel _data = UserModel.fromApp(myData.data()!);

                    return Card(
                    child: InkWell(
                        onTap: (){
                          Navigator.of(context).pushNamed(MainProfileUpdateScreen.profileUpdate,arguments: _data);
                        },
                        child:Container(
                          margin: const EdgeInsets.all(10.0),
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            text: '${TextTranslate.translateText(EnumLang.textUpdate.name, context)}',
                            fontSize: 20.0,
                          ),
                        )

                    ),
                  );
                  }
                );
              }
            ),
          ),

          Expanded(
            flex: 1,
            child: Card(
              child: InkWell(
                  onTap: () async{
                    return await AuthFunctions.signOut(context);
                  },
                  child:Container(
                    margin: const EdgeInsets.all(10.0),
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: '${TextTranslate.translateText(EnumLang.textLogOut.name, context)}',
                      fontSize: 20.0,
                    ),
                  )

              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}




class _DefaultDrawerClass {
  final _myData = StreamProvider((ref)=> AuthFunctions.getUserData() );
  late String? _langName = 'English';

  Widget _buildLangButton({
    required String langName ,
    required WidgetRef ref ,
    required String lang
  }) {
    return InkWell(
        onTap: (){
          ref.read(langProv).toggleLang(lang);
          _langName = langName;
        },
        child: Container(
            margin: const EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: CustomText(text: langName,
              fontSize: 18.0,
            ))
    );
  }
}