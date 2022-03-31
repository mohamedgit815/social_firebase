import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/Helper/Constance/const_colors.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Helper/Constance/const_text.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_button.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_widgets.dart';
import 'package:social_app/Helper/Widgets/Defaults/default_drawer.dart';
import 'package:social_app/Model/requests_model.dart';
import 'package:social_app/Model/user_model.dart';
import 'package:social_app/Update/Functions/chat_functions.dart';
import 'package:social_app/Views/Main/condition_builder.dart';
import 'package:social_app/Views/View/Chat/MainChat/main_chat_screen.dart';
import 'package:social_app/Views/View/Chat/MainRequests/main_requests_screen.dart';
import 'package:social_app/Views/View/Chat/MainUsers/main_users_chat_screen.dart';


class MobileFriendsPage extends StatefulWidget {
  const MobileFriendsPage({Key? key}) : super(key: key);

  @override
  _MobileFriendsPageState createState() => _MobileFriendsPageState();
}

class _MobileFriendsPageState extends State<MobileFriendsPage> with _MobileFriends{


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).unfocus();
    });
  }


  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();

    return Scaffold(
      drawer: const DefaultDrawer(),
      floatingActionButton: _buildFloatingActionButton(context),
      appBar: _buildAppBar(context),


      body: Column(
        children: [
          Expanded(
              child:  _buildShowFriends()
          )
        ],
      ),
    );
  }




}

class _MobileFriends {
  final _fetchFriends = StreamProvider((ref)=>FriendsFunctions.fetchFriends());


  /// Build Scaffold

  // FloatingActionButton
  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: (){
        ConstNavigator.pushNamedRouter(route: MainRequestsScreen.requests, context: context);
      },
      child: const Icon(Icons.chat_outlined),
    );
  }

  // AppBar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const CustomText(
        text: 'Friends' ,
        fontSize: 20.0,
      ),
      actions: [
        IconButton(onPressed: (){
          ConstNavigator.pushNamedRouter(route: MainUsersChatScreen.chat, context: context);
        }, icon: const Icon(Icons.person_pin,size: 30.0,))
      ],
    );
  }

  /// Build Body

  // This UI Special to Show The Friends
  Consumer _buildShowFriends()  {
    return Consumer(
        builder: (context,prov,_) {
          return prov.watch(_fetchFriends).when(
              error: (err,stack)=> errorProvider(err),
              loading: ()=> loadingProvider(),
              data: (data) => AnimatedConditionalBuilder(
                  condition: data.docs.isEmpty,
                  builder: (context){
                    return notFoundData('You don\'t have any Friends');
                  },
                  fallback: (context){
                    return ListView.separated(
                      separatorBuilder: (context,l)=>const Divider(),
                      itemCount: data.docs.length,
                      itemBuilder: (context,i) {
                        final UserModel _data = UserModel.fromApp(data.docs.elementAt(i).data());
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _data.image.isEmpty ? lightMainColor : null,
                            backgroundImage: _data.image.isEmpty ? null : NetworkImage(_data.image),
                            child: CustomText(
                              text: _data.first.substring(0,1).toString(),
                              fontSize: 20.0,
                              color: normalWhite,
                            ),
                          ) ,
                          title: CustomText(
                              text: '${_data.first} ${_data.last}'
                          ) ,
                          subtitle: AnimatedVisibility(
                              visible: _data.bio.isEmpty ? false : true,
                              child: CustomText(text: _data.bio.toString(),)) ,
                          trailing: IconButton(
                            icon: Icon(Icons.adaptive.more , color: lightMainColor,),
                            onPressed: ()async {
                              showModalBottomSheet(context: context, builder: (context)=>Column(
                                children: [
                                  ListTile(
                                    title: Text('${_data.first} ${_data.last}'),
                                    trailing: CircleAvatar(
                                      backgroundColor: _data.image.isEmpty ? lightMainColor : null,
                                      backgroundImage: _data.image.isEmpty ? null : NetworkImage(_data.image),
                                      foregroundColor: normalWhite,
                                      child: CustomText(
                                        text: _data.first.substring(0,1).toString(),
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),

                                  const Divider(thickness: 2),

                                  ListTile(
                                    title: Text('Remove ${_data.first} ${_data.last}'),
                                    onTap: (){
                                      showDialog(context: context, builder: (context)=>AlertDialog(
                                        title: Text('${TextTranslate.translateText(EnumLang.textSure.name, context)}'),
                                        actions: [
                                          CustomElevatedButton(onPressed: (){
                                            Navigator.pop(context);
                                          }, child: Text('${TextTranslate.translateText(EnumLang.textNo.name, context)}')),
                                          CustomElevatedButton(onPressed: () async {
                                            await FriendsFunctions.removeFriends(_data.id);
                                            Navigator.pop(context);
                                          }, child: Text('${TextTranslate.translateText(EnumLang.textYes.name, context)}')),
                                        ],
                                      ));
                                    },
                                  ),

                                  const Divider(endIndent: 15.0,indent: 15.0,),

                                  ListTile(
                                    title: Text('Block ${_data.first} ${_data.last}'),
                                    onTap: () async {
                                      showDialog(context: context, builder: (context)=>AlertDialog(
                                        title: Text('${TextTranslate.translateText(EnumLang.textSure.name, context)}'),
                                        actions: [
                                          CustomElevatedButton(onPressed: (){
                                            Navigator.pop(context);
                                          }, child: Text('${TextTranslate.translateText(EnumLang.textNo.name, context)}')),
                                          CustomElevatedButton(onPressed: () async {
                                            await BlockFunctions.addToBlock(model: _data);
                                            await FriendsFunctions.removeFriends(_data.id);
                                            Navigator.pop(context);
                                          }, child: Text('${TextTranslate.translateText(EnumLang.textYes.name, context)}')),
                                        ],
                                      ));
                                    },
                                  ),
                                ],
                              ));
                            },
                          ),

                          onTap: () async {
                              await Navigator.of(context).pushNamed(MainChatScreen.chat,arguments: _data);
                          },
                        );
                      },

                    );
                  }
              )
          );
        }
    );
  }

}