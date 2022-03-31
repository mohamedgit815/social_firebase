import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/Helper/Constance/const_colors.dart';
import 'package:social_app/Helper/Constance/const_firebase.dart';
import 'package:social_app/Helper/Constance/const_functions.dart';
import 'package:social_app/Helper/Constance/const_regexp.dart';
import 'package:social_app/Helper/Constance/const_state.dart';
import 'package:social_app/Helper/Constance/const_text.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_button.dart';
import 'package:social_app/Helper/Widgets/Customs/custom_widgets.dart';
import 'package:social_app/Model/comment_model.dart';
import 'package:social_app/Model/user_model.dart';
import 'package:social_app/Update/Functions/posts_functions.dart';
import 'package:social_app/Update/State/switch_state.dart';
import 'package:social_app/Views/Main/condition_builder.dart';


class MobileCommentPage extends ConsumerStatefulWidget {
  final String postId;
  const MobileCommentPage({Key? key, required this.postId}) : super(key: key);

  @override
  _MobileCommentPageState createState() => _MobileCommentPageState();
}

class _MobileCommentPageState extends ConsumerState<MobileCommentPage> with _MobileComment{

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _fetchCommentProv = StreamProvider((ref)=>PostsFunctions.fetchComment(widget.postId));
    return Scaffold(
      body: Column(
        children: [

          Expanded(
            child: Consumer(
              builder: (context,prov,_)=>prov.watch(_fetchCommentProv).when(
                  error: (err,stack)=>errorProvider(err),
                  loading: ()=> loadingVisibilityProvider() ,
                data: (data) {

                  return AnimatedConditionalBuilder(
                    condition: data.docs.isEmpty,
                    builder: (buildContext)=>notFoundData('No Comment Here'),
                      fallback: (buildContext) {
                      return ListView.separated(
                        separatorBuilder: (context,i)=>const Divider(thickness: 1,),
                        itemCount: data.docs.length ,
                        itemBuilder: (context , i) {
                          final CommentModel _data = CommentModel.fromApp(data.docs.elementAt(i).data());
                          final _fetchLikeComment = StreamProvider((ref)=>PostsFunctions.fetchLikeComment(
                              idComment: data.docs.elementAt(i).id, id: widget.postId));
                          final _checkLikeProv = StreamProvider((ref)=>PostsFunctions.checkLikeComment(
                               idComment: data.docs.elementAt(i).id, id: widget.postId));
                          final bool _isMe = firebaseId == _data.id;

                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0,bottom: 5.0
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start ,
                              crossAxisAlignment: CrossAxisAlignment.start ,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 7.0 , top: 5.0
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: _data.image.isEmpty ? lightMainColor : null,
                                    backgroundImage: _data.image.isEmpty ? null : NetworkImage(_data.image),
                                    child: CustomText(
                                      text: _data.name.substring(0,1).toString(),
                                      color: normalWhite ,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10.0,left: 10.0
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      CustomText(
                                        text: _data.name,
                                        fontWeight: FontWeight.bold,
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                                        child: CustomText(text: _data.comment),
                                      ),

                                      Consumer(
                                        builder:(context,myData,_)=> Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start ,
                                          children: [
                                            Consumer(
                                                builder: (context,provCheck,_) {
                                                  return provCheck.watch(_checkLikeProv).when(
                                                      error: (err,stack)=> errorProvider(err),
                                                      loading: ()=>const CustomText(text: 'Like',color: Colors.blue,) ,
                                                      data: (check)=>Padding(
                                                        padding: const EdgeInsets.only(
                                                            right: 10.0
                                                        ),
                                                        child: InkWell(
                                                            onTap: () async {
                                                              if(!check.exists){
                                                                return await PostsFunctions.likeComment(
                                                                  id: widget.postId,
                                                                  idComment: data.docs.elementAt(i).id,
                                                                );
                                                              } else {
                                                                return await PostsFunctions.removeLikeComment(
                                                                  id: widget.postId,
                                                                  idComment: data.docs.elementAt(i).id,
                                                                );
                                                              }
                                                            }, child: CustomText(
                                                          text:'Like',
                                                          color: check.exists ? Colors.red :Colors.blue,
                                                        )),
                                                      )
                                                  );
                                                }
                                            ) ,

                                            Consumer(
                                                builder: (context,provLikeComment,_) {
                                                  return provLikeComment.watch(_fetchLikeComment).when(
                                                      error: (err,stack)=>errorProvider(err),
                                                      loading: ()=>loadingVisibilityProvider() ,
                                                      data: (likeData) {
                                                        return AnimatedVisibility(
                                                            switchOutCurve: Curves.elasticIn,
                                                            switchInCurve: Curves.elasticIn,
                                                            visible: likeData.docs.isEmpty ? false : true,
                                                            child: AnimatedSwitcher(
                                                                duration: const Duration(milliseconds: 300),
                                                                child: CustomText(
                                                                  key: ValueKey<int>(likeData.docs.length),
                                                                  text: likeData.docs.length.toString(),
                                                                )));
                                                      }
                                                  );
                                                }
                                            )
                                          ],
                                        ),
                                      ) ,

                                    ],
                                  ),
                                ) ,


                                const Spacer(),


                                Visibility(
                                  visible: !_isMe ? false : true,
                                  child: IconButton(
                                      onPressed: (){
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext buildContext){
                                              return Column(
                                                children: [
                                                  InkWell(
                                                    onTap: (){
                                                      _commentController.text = _data.comment;
                                                      showDialog(context: context, builder: (context)=>AlertDialog(
                                                        alignment: Alignment.center,
                                                        title: Text(_data.comment),
                                                        actions: [
                                                          Consumer(
                                                              builder: (context,provComment,_) {
                                                                return TextField(
                                                                  controller: _commentController ,
                                                                  onChanged: (v){
                                                                    prov.watch(_commentProv).value = v;
                                                                  },
                                                                );
                                                              }
                                                          ) ,


                                                          Center(
                                                              child: CustomElevatedButton(
                                                                  size: const Size(double.infinity, 40.0),
                                                                  onPressed: () async {
                                                                    if( _commentController.text.isEmpty ){
                                                                      showDialog(context: context, builder: (context)=>AlertDialog(
                                                                        title: Text('${TextTranslate.translateText(EnumLang.textDelete.name, context)}'),
                                                                        actions: [

                                                                          CustomElevatedButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                                Navigator.pop(context);
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Text('${TextTranslate.translateText(EnumLang.textNo.name, context)}')) ,

                                                                          CustomElevatedButton(
                                                                              onPressed: () async {
                                                                                await PostsFunctions.deleteComment(
                                                                                    id: widget.postId, idComment: data.docs.elementAt(i).id);

                                                                                Navigator.pop(context);
                                                                                Navigator.pop(context);
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Text('${TextTranslate.translateText(EnumLang.textYes.name, context)}'))

                                                                        ],
                                                                      ));
                                                                    } else if( _commentController.text == _data.comment ) {
                                                                      Navigator.pop(context);
                                                                    } else {
                                                                      await PostsFunctions.updateComment(
                                                                          id: widget.postId,
                                                                          comment: _commentController.text,
                                                                          idComment: data.docs.elementAt(i).id
                                                                      );
                                                                      customSnackBar(text: 'Comment Updated', context: context);
                                                                      Navigator.pop(context);
                                                                      Navigator.pop(context);
                                                                    }
                                                                  },
                                                                  child: const Text('Google')
                                                              )),
                                                        ],
                                                      ));
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(15.0),
                                                      child: Row(
                                                        children: const [
                                                          CustomText(
                                                            text: 'Update Comment' ,
                                                            fontSize: 20.0,
                                                          ),
                                                          Spacer() ,

                                                          Icon(Icons.update,color: Colors.blue,),
                                                        ],
                                                      ),
                                                    ),
                                                  ),


                                                  InkWell(
                                                    onTap: (){
                                                      showDialog(context: context, builder: (BuildContext buildContext){
                                                        return AlertDialog(
                                                          title: Text('${TextTranslate.translateText(EnumLang.textSure.name, context)}'),
                                                          actions: [
                                                            CustomElevatedButton(
                                                                onPressed: () async {
                                                                  await PostsFunctions.updateComment(
                                                                      id: widget.postId,
                                                                      comment: _textController.text,
                                                                      idComment: data.docs.elementAt(i).id
                                                                  );
                                                                  Navigator.pop(context);
                                                                }, child: Text('${TextTranslate.translateText(EnumLang.textNo.name, context)}')),
                                                            CustomElevatedButton(
                                                                onPressed: () async {
                                                                  await PostsFunctions.deleteComment(
                                                                      id: widget.postId, idComment: data.docs.elementAt(i).id);
                                                                  Navigator.pop(context);
                                                                  Navigator.pop(context);
                                                                }, child: Text('${TextTranslate.translateText(EnumLang.textYes.name, context)}')),
                                                          ],
                                                        );
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(15.0),
                                                      child: Row(
                                                        children: const [
                                                          CustomText(
                                                            text: 'Delete Comment' ,
                                                            fontSize: 20.0,
                                                          ),
                                                          Spacer() ,

                                                          Icon(Icons.delete,color: Colors.red,),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                      }, icon: Icon(Icons.adaptive.more)),
                                ),

                              ],
                            ),
                          );
                        }
                );
                    }
                  );
                }
              )
            )
          ),

          Consumer(
            builder:(context,provMyData,_)=> provMyData.watch(myDataProv).when(
                error: (err,stack)=> errorProvider(err),
                loading: ()=> loadingVisibilityProvider() ,
              data: ( myData ) {
                  final UserModel _data = UserModel.fromApp(myData.data()!);
                return Row(
                children: [

                  // Build ChatTextField
                  Expanded(
                    child: _buildChatTextField(
                      context: context ,
                      ref: ref ,
                    ),
                  ),

                  // Build ChatSendTextButton
                   Builder(
                      builder: (context) {
                        return _buildSendTextButton(
                          ref: ref ,
                          userModel: _data ,
                          content: _textController.text ,
                          postID: widget.postId
                        );
                      }
                  )
                ],
              );
              }
            )
          )
        ],
      ),
    );
  }
}

class _MobileComment {
  final _commentProv = ChangeNotifierProvider<SwitchState>((ref)=>SwitchState());
  final _textProv = ChangeNotifierProvider<SwitchState>((ref)=>SwitchState());
  final _subTextProv = ChangeNotifierProvider<SwitchState>((ref)=>SwitchState());
  final _loadingProv = ChangeNotifierProvider<SwitchState>((ref)=>SwitchState());
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();


  /// Body...


  // This UI to Send Data
  TextField _buildChatTextField({
    required BuildContext context ,
    required WidgetRef ref
  }) {
    const OutlineInputBorder _outLineBorder = OutlineInputBorder(
        borderRadius:  BorderRadius.only(
          topRight: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
        borderSide: BorderSide.none
    );

    return TextField(
      controller: _textController,
      focusNode: _focusNode,
      textInputAction: TextInputAction.send,
      onSubmitted: (v) async {
        if(ref.read(_textProv).value.isEmpty){
          FocusScope.of(context).unfocus();
          return;
        } else {
          FocusScope.of(context).autofocus(_focusNode);
          //_scrollController.jumpTo(0);
          ref.read(_textProv).equalNull();
          ref.read(_subTextProv).equalNull();
          _textController.clear();
         // _scrollController.jumpTo(0);
        }
      },
      decoration: InputDecoration(
          border: _outLineBorder ,
          hintText: 'Enter your Comment Here',
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0.0),
              borderSide: const BorderSide(color: Colors.black,width: 1.0)
          ),
          disabledBorder: _outLineBorder ,
          focusedBorder: _outLineBorder
      ),
      onChanged: (v){
        ref.read(_textProv).funcChange(v);
      },
    );
  }

  // Send Text to DataBase
  Consumer _buildSendTextButton({
    required WidgetRef ref ,
    required String postID ,
    required UserModel userModel ,
    required String content ,
  }) {
    return Consumer(
        builder: (context,prov,_) {
          return AnimatedVisibility(
              visible: conditionEegExp.hasMatch(prov.watch(_textProv).value) ||
                  langEnArRegExp.hasMatch(prov.read(_textProv).value),
              child: AnimatedVisibility(
                  duration: const Duration(milliseconds: 100),
                  visible: prov.watch(_loadingProv).varSwitch,
                  child: IconButton(
                      onPressed: () async {
                        await PostsFunctions.writeComment(
                            id: postID ,
                            myId: userModel.id ,
                            name: '${userModel.first} ${userModel.last}' ,
                            image: userModel.image ,
                            comment: _textController.text
                        );
                        _textController.clear();
                        ref.read(_textProv).equalNull();
                        ref.read(_subTextProv).equalNull();
                        _textController.clear();
                      //  _scrollController.jumpTo(0);
                      }, icon: const Icon(Icons.send))
              )
          );
        }
    );
  }
}