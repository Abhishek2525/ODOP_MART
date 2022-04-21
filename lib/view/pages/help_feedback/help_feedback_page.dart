import 'package:flutter/material.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

import '../../../core/utils/toast/flutter_toast.dart';
import '../../../core/validetor/app_validetor.dart';
import '../../../core/view_models/feedback_view_model.dart';
import '../../../core/view_models/profile_view_model.dart';
import '../../../core/view_models/theme_view_model.dart';
import '../../widgets/dialogs/progress_dialog.dart';
import '../../widgets/round_border_button.dart';
import 'help_text_field_widget.dart';

class HelpFeedbackPage extends StatefulWidget {
  @override
  _HelpFeedbackPageState createState() => _HelpFeedbackPageState();
}

class _HelpFeedbackPageState extends State<HelpFeedbackPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  FocusNode _nameNode = FocusNode();
  FocusNode _phoneNode = FocusNode();
  FocusNode _emailNode = FocusNode();
  FocusNode _messageNode = FocusNode();

  String _name;

  String _phone;

  String _email;

  String _message;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    feedbackController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help & Feedback',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'poppins_medium',
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.center,
            child: ImageIcon(
              AssetImage('images/backIcon.png'),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: GetBuilder<ProfileViewModel>(
          builder: (profileController) {
            nameController.text =
                profileController?.profileModel?.data?.name ?? "null";
            phoneController.text =
                profileController?.profileModel?.data?.phone ?? 'null';
            emailController.text =
                profileController?.profileModel?.data?.email ?? 'null';
            return Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  GetBuilder<ThemeController>(
                    builder: (controller) => Center(
                      child: Image.asset(
                        controller.themeMode.index == 2
                            ? 'images/helpImg.png'
                            : "assets/images/help_and_feedBack/helpFeedLight.png",
                        height: hp(26),
                        width: wp(60),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        HelpTextField(
                          nameField: 'User Name',
                          initialValue:
                              profileController?.profileModel?.data?.name ?? "",
                          controller: nameController,
                          validator: (value) => AppValidTor.isEmpty(value),
                          hintField: 'Ex. Shakib',
                          onSave: (value) {
                            _name = value ?? '';
                          },
                          focusNode: _nameNode,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        HelpTextField(
                          nameField: 'Phone Number',
                          initialValue:
                              profileController?.profileModel?.data?.phone ??
                                  "",
                          controller: phoneController,
                          validator: (value) {
                            if (GetUtils.isPhoneNumber(value)) {
                              return null;
                            }
                            return 'Enter a valid phone number';
                          },
                          onSave: (value) {
                            _phone = value ?? '';
                          },
                          hintField: '+880',
                          focusNode: _phoneNode,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        HelpTextField(
                          nameField: 'Email Address',
                          initialValue:
                              profileController?.profileModel?.data?.email ??
                                  "",
                          controller: emailController,
                          validator: (value) {
                            if (GetUtils.isEmail(value)) {
                              return null;
                            }
                            return 'Enter a valid email';
                          },
                          onSave: (value) {
                            _email = value ?? '';
                          },
                          hintField: 'example@mail.com',
                          focusNode: _emailNode,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        HelpTextField(
                          nameField: 'Detail Massage',
                          hintField: 'Type here',
                          feedbackMsgController: feedbackController,
                          validator: (value) => AppValidTor.isEmpty(value),
                          onSave: (value) {
                            _message = value ?? '';
                          },
                          maxLine: 4,
                          focusNode: _messageNode,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GetBuilder<FeedbackViewModel>(
                    builder: (feedbackViewController) => Container(
                      width: wp(80),
                      child: RoundBoarderButton(
                        text: 'SEND',
                        padding: 8,
                        onPress: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();

                            _nameNode.unfocus();
                            _phoneNode.unfocus();
                            _emailNode.unfocus();
                            _messageNode.unfocus();

                            print('$_name');
                            print('$_phone');
                            print('$_email');
                            print('$_message');

                            Get.to(ProgressDialog(), opaque: false);

                            await feedbackViewController.getFeedbackMethod(
                              name: _name,
                              phone: _phone,
                              email: _email,
                              feedback: _message,
                            );
                            Get.back();
                            if (feedbackViewController.feedbackModel.success ==
                                true) {
                              FlutterToast.showSuccess(
                                message: "Thank you for your feedback.",
                                context: context,
                              );
                              // feedbackViewController.feedbackModel.success = false;
                            } else {
                              FlutterToast.showSuccess(
                                message: "Thank you for your feedback.",
                                context: context,
                              );
                            }
                            setState(() {
                              nameController.clear();
                              phoneController.clear();
                              emailController.clear();
                              feedbackController.clear();
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
