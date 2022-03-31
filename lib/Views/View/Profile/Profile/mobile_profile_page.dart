import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/Helper/Constance/const_colors.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Helper/Constance/const_state.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_button.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_widgets.dart';
import 'package:social_app/Helper/Widgets/Defaults/default_add_person.dart';
import 'package:social_app/Model/requests_model.dart';
import 'package:social_app/Model/user_model.dart';
import 'package:social_app/Update/Functions/auth_functions.dart';
import 'package:social_app/Update/Functions/chat_functions.dart';
import 'package:social_app/Views/Main/condition_builder.dart';


class MobileProfilePage extends StatefulWidget {
  final UserModel requestsModel;
  const MobileProfilePage({Key? key,required this.requestsModel}) : super(key: key);

  @override
  _MobileProfilePageState createState() => _MobileProfilePageState();
}

class _MobileProfilePageState extends State<MobileProfilePage>
 with SingleTickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _checkRequests = StreamProvider((ref)=>RequestsFunction.checkRequests(widget.requestsModel.id));
    final _fetchMyData = StreamProvider((ref)=>AuthFunctions.getUserDataById(widget.requestsModel.id));
    //RequestsModel _data = RequestsModel.fromApp(widget.model);

    return Consumer(
      builder: (context,provMyData,_) {
        return provMyData.watch(myDataProv).when(
            error: (err,stack)=>errorProvider(err),
            loading: ()=>loadingVisibilityProvider() ,
          data: (myData) {

            return Scaffold(
            // appBar: AppBar(),
              body: NestedScrollView(
                headerSliverBuilder: (context,inner)=>[
                  SliverList(delegate: SliverChildListDelegate([
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0
                          ),
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundColor: widget.requestsModel.image.isEmpty? lightMainColor: null,
                            backgroundImage: widget.requestsModel.image.isEmpty? null: NetworkImage(widget.requestsModel.image),
                            child: CustomText(
                              text: widget.requestsModel.first.substring(0,1).toString(),
                              fontSize: 40.0,
                              color: normalWhite,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:  CustomText(
                            text: 'Name: ${widget.requestsModel.first} ${widget.requestsModel.last}' ,
                            fontSize: 20.0,
                          ),
                        ),


                        AnimatedConditionalBuilder(
                          condition: widget.requestsModel.bio.isEmpty,
                          builder: (context)=> CustomText(
                            text: 'Email: ${widget.requestsModel.email}' ,
                            fontSize: 17.0,
                          ),
                          fallback: (context)=> CustomText(
                            text: 'Bio: ${widget.requestsModel.bio}' ,
                            fontSize: 17.0,
                          ),

                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: CustomElevatedButton(onPressed: (){
                                Navigator.pop(context);
                              }, child: const Text('Back')),
                            ),


                            Expanded(
                                child: DefaultAddPerson(data: widget.requestsModel))
                          ],
                        )
                      ],
                    )
                  ]))],
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: lightMainColor,
                        labelColor: lightMainColor,
                        unselectedLabelColor: normalGrey.shade400,
                        tabs: const [
                          CustomText(
                            text:'Likes',
                            fontSize: 20.0,
                          ),

                          CustomText(
                            text:'Uploaded',
                            fontSize: 20.0,
                          )
                        ],
                      ),
                    ),

                    Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Container(color: Colors.blue,),
                            Container(color: Colors.amber,),
                          ],
                        )
                    )
                  ],
                ),
              )
          );
          }
        );
      }
    );
  }
}

