import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/Helper/Constance/const_colors.dart';
import 'package:social_app/Helper/Constance/const_firebase.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_widgets.dart';
import 'package:social_app/Helper/Widgets/Defaults/default_add_person.dart';
import 'package:social_app/Model/requests_model.dart';
import 'package:social_app/Model/user_model.dart';
import 'package:social_app/Update/Functions/chat_functions.dart';
import 'package:social_app/Views/Main/condition_builder.dart';
import 'package:social_app/Views/View/Chat/MainUsers/main_search_users_screen.dart';
import 'package:social_app/Views/View/Profile/Profile/main_profile_screen.dart';


class MobileUsersChatPage extends ConsumerStatefulWidget {
  const MobileUsersChatPage({Key? key}) : super(key: key);

  @override
  _MobileUsersChatPageState createState() => _MobileUsersChatPageState();
}

class _MobileUsersChatPageState extends ConsumerState<MobileUsersChatPage>
    with _MobileUsersChat{


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).unfocus();
    });
  }


  @override
  Directionality build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context,inner)=>[
              Builder(
                builder: (context) {
                  return _buildSliverAppBar(context);
                }
              )
          ],
          body:  Column(
            children: [

              Expanded(
                  child: _buildListViewUsers(ref: ref)
              )

            ],
          ),
        )
      ),
    );
  }

}

class _MobileUsersChat {
  final _fetchCartProv = FutureProvider((ref)=>ChatFunctions.fetchUserChat());

  /// Scaffold

  // SliverAppBar
  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      snap: true,
      floating: true,
      centerTitle: true,
      title: const CustomText(
          text: 'know new Friends' ,
          fontSize: 17.0
      ),

      actions: [
        IconButton(onPressed: () async {
          showSearch(context: context, delegate: SearchUsers());
        }, icon:  const Icon(Icons.search))
      ],
    );
  }


  /// Body

  // Show Data In ListView to Know new Friends
  Consumer _buildListViewUsers({
  required WidgetRef ref
}) {
    return Consumer(
        builder:(context,prov,_)=> prov.watch(_fetchCartProv).when(
          error: (err,stack)=>errorProvider(err),
          loading: ()=>loadingProvider() ,
          data: (data) {
            return RefreshIndicator(
                onRefresh: () async {
                  return await prov.refresh(_fetchCartProv);
                },
                child: AnimatedConditionalBuilder(
                    condition: data.docs.isEmpty,
                    builder: (context)=> notFoundData('No Users Now'),
                    fallback: (context) {
                      return ListView.separated(
                          separatorBuilder: (context,l) {
                            final RequestsModel _data = RequestsModel.fromApp(data.docs.elementAt(l).data());
                            final _checkRequests = StreamProvider((ref)=>RequestsFunction.checkRequests(_data.id));

                            return ref.read(_checkRequests).when(
                                error: (err,stack)=>errorProvider(err),
                                loading: ()=> loadingVisibilityProvider(),
                                data: (provCheck)=>Visibility(
                                  visible: _data.id == firebaseId || provCheck.exists ? false : true,
                                  child: const Divider(thickness: 1),
                                )
                            );
                          },
                          itemCount: data.docs.length ,
                          itemBuilder: (context,i){
                            final UserModel _data = UserModel.fromApp(data.docs.elementAt(i).data());
                            final _checkFriends = StreamProvider((ref)=>FriendsFunctions.checkFriends(_data.id));
                            final _checkBlock = StreamProvider((ref)=>BlockFunctions.checkUserBlockOrNo(_data.id));

                            return Consumer(
                              builder:(context,provCheck,_)=> provCheck.watch(_checkFriends).when(
                                  error: (err,stack)=>errorProvider(err) ,

                                  loading: ()=> loadingVisibilityProvider() ,

                                  data: (checkUsers)=> Consumer(
                                      builder: (context,provBlock,_) {
                                    return provBlock.watch(_checkBlock).when(
                                        error: (err,stack)=>errorProvider(err) ,

                                        loading: ()=> loadingVisibilityProvider() ,

                                        data: (checkBlock)=>Visibility(
                                        visible: _data.id == firebaseId || checkUsers.exists || checkBlock.exists? false : true ,
                                        child: ListTile(
                                          title: Text('${_data.first} ${_data.last}') ,
                                          subtitle: Align(
                                            alignment: Alignment.centerLeft ,
                                            child: AnimatedConditionalBuilder(
                                              condition: _data.bio.isEmpty ,
                                              builder: (context)=>Text(_data.email.toString()),
                                              fallback: (context)=>Text(_data.bio.toString()),
                                            ),
                                          ),

                                          leading: CircleAvatar(
                                            backgroundColor: _data.image.isNotEmpty ? null : lightMainColor,
                                            backgroundImage: _data.image.isEmpty ? null : NetworkImage(_data.image),
                                            child: Visibility(
                                              visible: _data.image.isNotEmpty ? false : true,
                                              child: CustomText(
                                                text: _data.first.substring(0,1).toString(),
                                                color: normalWhite,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ) ,

                                          trailing: DefaultAddPerson(data: _data),
                                          onTap: () {
                                            Navigator.of(context).pushNamed(MainProfileScreen.profile,arguments: _data);
                                          },
                                        ),
                                      )
                                    );
                                  })
                              ),
                            );
                          });
                    })
            );
          },
        )
    );
  }

}