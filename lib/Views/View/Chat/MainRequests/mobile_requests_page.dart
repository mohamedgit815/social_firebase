import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Helper/Constance/const_text.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_button.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_widgets.dart';
import 'package:social_app/Model/requests_model.dart';
import 'package:social_app/Model/user_model.dart';
import 'package:social_app/Update/Functions/auth_functions.dart';
import 'package:social_app/Update/Functions/chat_functions.dart';
import 'package:social_app/Views/Main/condition_builder.dart';

class MobileRequestsPage extends StatefulWidget {
  const MobileRequestsPage({Key? key}) : super(key: key);

  @override
  _MobileRequestsPageState createState() => _MobileRequestsPageState();
}

class _MobileRequestsPageState extends State<MobileRequestsPage>
    with _MobileRequests{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),

      body: LayoutBuilder(
        builder:(context, constraints) => Column(
          children: [
            Expanded(
              child: _buildRequestsListView(constraints),
            ),
          ],
        ),
      ),
    );
  }

}

class _MobileRequests {
  final _fetchMyData = StreamProvider((ref)=>AuthFunctions.getUserData());
  final _fetchRequests = StreamProvider((ref)=>RequestsFunction.fetchRequests());

  /// Scaffold

  // Appbar
  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: const CustomText(
        text: 'Friends Requests',
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }


  /// Body

  // Show Requests to Accept or Refused
  Consumer _buildRequestsListView(BoxConstraints constraints) {
    return Consumer(
        builder: (context,prov,_) {
          return prov.watch(_fetchRequests).when(
              error: (err,stack)=>errorProvider(err),
              loading: ()=>loadingProvider() ,
              data: (data)=>AnimatedConditionalBuilder(
                  condition: data.docs.isEmpty,
                  builder: (context){
                    return notFoundData('You are\'t have any Requests');
                  },
                  fallback: (context){
                    return ListView.builder(
                        itemCount: data.docs.length,
                        itemBuilder: (context, i) {
                          final UserModel _data = UserModel.fromApp(data.docs.elementAt(i).data());

                          return Card(
                            child: Container(
                              height: constraints.maxHeight * 0.2,
                              width: double.infinity,
                              margin: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Visibility(
                                    visible: _data.image.isEmpty ? false : true ,
                                    child: Expanded(
                                        flex: 1,
                                        child: FadeInImage(
                                          fit: BoxFit.cover,
                                          placeholder: const AssetImage('assets/images/loading.gif'),
                                          image: NetworkImage(_data.image),
                                        )
                                    ),
                                  ) ,

                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [

                                        Expanded(
                                            child:  Align(
                                              alignment: Alignment.center,
                                              child: CustomText(
                                                text: 'Name: ${_data.first} ${_data.last}',
                                                fontSize: 18.0,
                                              ),
                                            )),


                                        Expanded(
                                            child:  Align(
                                                alignment: Alignment.center,
                                                child: AnimatedConditionalBuilder(
                                                  condition: _data.bio.isEmpty,
                                                  builder: (context)=>CustomText(
                                                    text: 'Email: ${_data.email}' ,
                                                    maxLine: 2,
                                                    fontSize: 18.0,
                                                  ),
                                                  fallback: (context)=>CustomText(
                                                    text: 'Bio: ${_data.bio}' ,
                                                    maxLine: 2,
                                                    fontSize: 18.0,
                                                  ),
                                                )
                                            )),


                                        Expanded(
                                          child: Consumer(
                                              builder: (context,prov,_) {
                                                return prov.watch(_fetchMyData).when(
                                                    error: (err,stack)=>errorProvider(err),
                                                    loading: ()=>loadingProvider() ,
                                                    data: (myData)=> Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        CustomElevatedButton(
                                                            onPressed: () async {
                                                              return _refusedRequests(context,_data.id);
                                                            }, child: const Text('Refused')),

                                                        CustomElevatedButton(
                                                            onPressed: () async {
                                                              final UserModel _myData = UserModel.fromApp(myData.data()!);
                                                              await RequestsFunction.acceptRequests(
                                                                  id: _data.id,
                                                                  model: _data ,
                                                                  myModel: _myData
                                                              );
                                                              await RequestsFunction.refusedRequests(_data.id);
                                                            }, child: const Text('Accept')),
                                                      ],)
                                                );
                                              }
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  })
          );
        }
    );
  }


  /// Functions
  Future<void> _refusedRequests(BuildContext context ,String id) async {
     return await showDialog(context: context, builder: (context)=>AlertDialog(
       title: Text('${TextTranslate.translateText(EnumLang.textSure.name, context)}'),
       actions: [
         CustomElevatedButton(onPressed: (){
           Navigator.of(context).pop();
         }, child: Text('${TextTranslate.translateText(EnumLang.textNo.name, context)}')),
         CustomElevatedButton(onPressed: () async {
             await RequestsFunction.refusedRequests(id);
             Navigator.of(context).pop();
         }, child: Text('${TextTranslate.translateText(EnumLang.textYes.name, context)}')),
       ],
     ));
  }

}