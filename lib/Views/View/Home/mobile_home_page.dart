import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/Helper/Constance/const_colors.dart';
import 'package:social_app/Helper/Constance/const_firebase.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Helper/Constance/const_state.dart';
import 'package:social_app/Helper/Constance/const_text.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_button.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_widgets.dart';
import 'package:social_app/Helper/Widgets/Defaults/default_drawer.dart';
import 'package:social_app/Model/home_model.dart';
import 'package:social_app/Update/Functions/auth_functions.dart';
import 'package:social_app/Update/Functions/home_functions.dart';
import 'package:social_app/Update/State/switch_state.dart';
import 'package:social_app/Views/Main/condition_builder.dart';
import 'package:social_app/Views/View/Home/Comment/main_comment_screen.dart';
import 'package:social_app/Views/View/Profile/Profile/main_profile_screen.dart';


class MobileHomePage extends ConsumerStatefulWidget {
  const MobileHomePage({Key? key}) : super(key: key);

  @override
  _MobileHomePageState createState() => _MobileHomePageState();
}

class _MobileHomePageState extends ConsumerState<MobileHomePage> with _MobileHome{

  @override
  void initState() {
    super.initState();
    firebaseOnMessage(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).unfocus();
    });
    AuthFunctions.updateToken();
  }

  @override
  Scaffold build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey.shade300,
      drawer: const DefaultDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context,inner)=>[
          buildSliverAppBar()
        ],
        body: LayoutBuilder(
          builder:(context, constraints) => Column(
            children: [

              Expanded(
                  child: Consumer(
                    builder: (context,prov,_) {
                      return prov.watch(fetchHomeProv).when(
                          error: (err,stack)=>errorProvider(err),
                          loading: ()=> loadingProvider() ,
                        data: (data)=>RefreshIndicator(
                          onRefresh: () async {
                            return ref.refresh(fetchHomeProv);
                          },
                          child: ListView.builder(
                              itemCount: data.docs.length ,
                              itemBuilder: (context,i) {

                                final HomeModel _data = HomeModel.fromApp(data.docs.elementAt(i).data());
                                final _checkLikeProv = StreamProvider((ref)=>HomeFunctions.checkPost(data.docs.elementAt(i).id));
                                final bool _myPost = firebaseId == _data.myId;

                                return Card(
                                  color: normalWhite,
                                  child: Column(
                                    children: [

                                      Card(
                                          color: normalWhite ,
                                          child: buildUserUI(
                                              homeModel: _data ,
                                              myPost: _myPost ,
                                            i: i ,
                                            data: data ,
                                            context: context ,
                                            ref: prov
                                          )) ,


                                      GestureDetector(
                                        onTap: (){
                                          ref.read(_maxLineProv).switchMaxLine();
                                        },
                                        child: Column(
                                          children: [
                                            Visibility(
                                              visible: _data.post.isEmpty ? false : true,
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Card(
                                                  color: normalWhite,
                                                  child: Consumer(
                                                    builder:(context,provMaxLine,_)=> Padding(
                                                      padding: const EdgeInsets.all(5.0),
                                                      child: CustomText(
                                                        text: _data.post,
                                                        maxLine: provMaxLine.watch(_maxLineProv).maxLine,
                                                        fontSize: 19.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ) ,


                                            Visibility(
                                              visible: _data.image.isEmpty ? false : true,
                                              child: Card(
                                                color: normalWhite,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: FadeInImage(
                                                      placeholder: const AssetImage('assets/images/loading.gif'),
                                                      image: NetworkImage(_data.image),
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: constraints.maxHeight *0.5,
                                                  ),
                                                ),
                                              ),
                                            ) ,
                                          ],
                                        ),
                                      ) ,


                                      Row(
                                        children: [

                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 5.0,left: 5.0
                                              ),
                                              child: Builder(
                                                builder: (BuildContext buildContext) {
                                                  return buildBottomSheet(
                                                      context: context ,
                                                      data: data,
                                                      i: i
                                                  );
                                                 // return buildBottomSheet(context);
                                                }
                                              ),
                                            ),
                                          ),



                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 5.0,left: 5.0
                                              ),
                                              child: Consumer(
                                                builder: (context,provCheckLike,_) {
                                                  return provCheckLike.watch(_checkLikeProv).when(
                                                      error: (err,stack)=> errorProvider(err) ,
                                                      loading: ()=> loadingVisibilityProvider() ,
                                                    data: (checkLike)=> AnimatedConditionalBuilder(
                                                        condition: !checkLike.exists ,
                                                        builder: (BuildContext context){
                                                          return CustomOutlinedIconButton(
                                                              backGroundColor: normalWhite,
                                                              onPressed: () async {
                                                                await HomeFunctions.addPostToLike(
                                                                    data.docs.elementAt(i).id, _data);
                                                              },
                                                              child: const CustomText(
                                                                text: 'Like' ,
                                                                fontSize: 20.0,
                                                                color: lightMainColor,
                                                              ), icon: const Icon(
                                                            Icons.favorite_outline,
                                                            color: lightMainColor,
                                                            size: 20.0,
                                                            //color: Colors.red,
                                                          ));
                                                        },
                                                      fallback: (BuildContext context){
                                                        return CustomOutlinedIconButton(
                                                            backGroundColor: normalWhite,
                                                            onPressed: () async {
                                                              await HomeFunctions.removePostToLike(data.docs.elementAt(i).id);
                                                            },
                                                            child: const CustomText(
                                                              text: 'Like' ,
                                                              fontSize: 20.0 ,
                                                              color: Colors.red ,
                                                            ), icon: const Icon(
                                                          Icons.favorite ,
                                                          color: Colors.red ,
                                                          size: 20.0,
                                                          //color: Colors.red,
                                                        ));
                                                      },
                                                    )
                                                  );
                                                }
                                              ),
                                            ),
                                          ),

                                        ],
                                      )

                                    ],
                                  )
                              );
                              }
                          ),
                        )
                      );
                    }
                  )
              )

            ],
          ),
        ),
      ),
    );
  }

}

class _MobileHome {
  final _maxLineProv = ChangeNotifierProvider<SwitchState>((ref)=>SwitchState());

  /// Scaffold...

  // Appbar
  SliverAppBar buildSliverAppBar() {
    return  SliverAppBar(
      snap: true,
      floating: true,
      centerTitle: true,
      title: const CustomText(
          text: 'Home' ,
          fontSize: 20.0
      ),

      actions: [
        IconButton(onPressed: (){
         // sendMessage(id: '', title: 'title', body: 'body');
    }, icon: const Icon(Icons.add))
      ],
    );
  }


  /// Body...

  // Build User UI to know User upload the posts
  Row buildUserUI({
    required HomeModel homeModel , required bool myPost ,
    required QuerySnapshot<Map<String,dynamic>> data ,
    required int i , required BuildContext context ,
    required WidgetRef ref
  }) {
    return Row(
      key: ValueKey(homeModel.myId),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          key: ValueKey(homeModel.myId),
          children: [

            Padding(
              padding:  const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: homeModel.myImage.isEmpty ? lightMainColor : null,
                backgroundImage: homeModel.myImage.isEmpty ? null : NetworkImage(homeModel.myImage),
                child: Visibility(
                  visible: homeModel.myImage.isNotEmpty ? false : true ,
                  child: CustomText(
                    text: homeModel.myName.substring(0,1),
                    color: normalWhite,
                    fontSize: 19.0,
                  ),
                ),
              ),
            ) ,

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(text: homeModel.myName,fontSize: 17.0,),
            )

          ],
        ),

        Visibility(
          visible: !myPost ? false : true,
          child: IconButton(
              onPressed: () async {
                showModalBottomSheet(context: context, builder: (context)=>Column(
                  children: [
                    ListTile(
                      title: const CustomText(
                        text: 'Delete your Post',
                        fontSize: 24.0,
                      ),
                      trailing: const Icon(Icons.delete,color: Colors.red,),
                      onTap: (){
                        showDialog(context: context, builder: (context)=>AlertDialog(
                          title: Text('${TextTranslate.translateText(EnumLang.textSure.name, context)}'),
                          actions: [
                            CustomElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  }, child: Text('${TextTranslate.translateText(EnumLang.textNo.name, context)}')),


                            CustomElevatedButton(
                                onPressed: () async {
                                  await HomeFunctions.removePosts(data.docs.elementAt(i).id);
                                  Navigator.pop(context);
                                  ref.refresh(fetchHomeProv);
                                  }, child: Text('${TextTranslate.translateText(EnumLang.textYes.name, context)}')),
                          ],
                        ));
                      },
                    ),
                  ],
                ));
              }, icon: Icon(Icons.adaptive.more)),
        )
      ],
    );
  }

  /// Build Bottom Sheet to Show Comment

  // BottomSheet
  CustomOutlinedIconButton buildBottomSheet({
    required BuildContext context ,
    required QuerySnapshot<Map<String,dynamic>> data ,
    required int i
}) {
    return CustomOutlinedIconButton(
        backGroundColor: normalWhite ,
        onPressed: () async {
          Navigator.of(context).pushNamed(
              MainCommentScreen.comment,arguments: data.docs.elementAt(i).id);
        } ,
        child: const FittedBox(
          child:  CustomText(
            text: 'Comment' ,
            color: lightMainColor ,
            fontSize: 15.0 ,
          ),
        ), icon: const Icon(
      Icons.comment_outlined ,
      color: lightMainColor ,
      size: 15.0,
    ));
  }

}