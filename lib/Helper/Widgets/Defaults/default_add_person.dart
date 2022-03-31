import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/Helper/Constance/const_colors.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Model/requests_model.dart';
import 'package:social_app/Model/user_model.dart';
import 'package:social_app/Update/Functions/auth_functions.dart';
import 'package:social_app/Update/Functions/chat_functions.dart';
import 'package:social_app/Views/Main/condition_builder.dart';


class DefaultAddPerson extends StatelessWidget {
  final UserModel data;

  const DefaultAddPerson({
    Key? key ,
    required this.data
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final _checkUserBlock = StreamProvider((ref)=>BlockFunctions.checkUserBlock(data.id));
    final _checkRequests = StreamProvider((ref)=>RequestsFunction.checkRequests(data.id));
    final _checkMyRequests = StreamProvider((ref)=>RequestsFunction.checkMyRequests(data.id));

    return LayoutBuilder(
      builder:(context, constraints) => SizedBox(
          width: constraints.maxWidth * 0.15,
          child: Consumer(
            builder: (context,provMyData,_){
              return provMyData.watch(_fetchMyData).when(
                  error: (err,stack)=>errorProvider(err),
                  loading: ()=>loadingVisibilityProvider() ,
                  data: (myData){
                    final UserModel _myData = UserModel.fromApp(myData.data()!);

                    return Consumer(
                      builder: (context,provCheckBlock,_) {
                        return provCheckBlock.watch(_checkUserBlock).when(
                            error: (err,stack)=>errorProvider(err) ,
                            loading: ()=>loadingVisibilityProvider() ,
                          data: (checkBlocks)=> AnimatedConditionalBuilder(
                              condition: checkBlocks.exists,
                              builder: (context){
                                return IconButton(onPressed: () async {
                                  return await BlockFunctions.removeFromBlock(data.id);
                                }, icon: const Icon(Icons.person_add_disabled));
                              },
                              fallback: (context){
                                return Consumer(
                                    builder:(context , provCheck , _) {
                                      return provCheck.watch(_checkMyRequests).when(
                                          error: (err,stack)=>errorProvider(err),
                                          loading: ()=>loadingVisibilityProvider(),
                                          data: (checkMyRequests)=> AnimatedConditionalBuilder(
                                            condition: checkMyRequests.exists ,
                                            builder: (context){
                                              return IconButton(
                                                  onPressed: () async {
                                                    await RequestsFunction.acceptRequests(
                                                        id: data.id,
                                                        model: data ,
                                                        myModel: _myData
                                                    );
                                                    await RequestsFunction.refusedRequests(data.id);
                                                    await RequestsFunction.removeRequests(data.id);
                                                  }, icon: const Icon(Icons.person_add,color: lightMainColor,));
                                            },
                                            fallback: (BuildContext context){
                                              return Consumer(
                                                  builder:(context,provCheck,_)=>
                                                      provCheck.watch(_checkRequests).when(
                                                        error: (err,stack)=> errorProvider(err),
                                                        loading: ()=> loadingVisibilityProvider(),
                                                        data: (checkRequests)=> AnimatedConditionalBuilder(
                                                            duration: const Duration(milliseconds: 500),
                                                            switchOutCurve: Curves.easeInOutCubic,
                                                            switchInCurve: Curves.easeInOutCubic,
                                                            condition: !checkRequests.exists ,
                                                            builder:(context)=> IconButton(
                                                                onPressed: () async {

                                                                  return await RequestsFunction.sendRequest(id: data.id,model: _myData);

                                                                }, icon: const Icon(Icons.send,color: lightMainColor,)) ,
                                                            fallback:(context)=> IconButton(
                                                                onPressed: () async {
                                                                  return await RequestsFunction.removeRequests(data.id);
                                                                }, icon: const Icon(Icons.delete_outline,color: lightMainColor,))
                                                        ),
                                                      )

                                              );
                                            },
                                          )
                                      );
                                    }
                                );
                              }
                          )
                        );
                      }
                    );
                  }
              );
            },
          )
      ),
    );
  }
}

final _fetchMyData = StreamProvider((ref)=>AuthFunctions.getUserData());
