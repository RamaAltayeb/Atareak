import 'package:atareak/controllers/users_controller.dart';
import 'package:atareak/views/components/primary_button.dart';
import 'package:atareak/views/components/dialogs.dart';
import 'package:atareak/views/components/form_fields.dart';
import 'package:atareak/views/components/snackbars.dart';
import 'package:atareak/views/utilities/assets_strings.dart';
import 'package:atareak/views/utilities/box_decoration_styles.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RateAUSer extends StatefulWidget {
  final String id;

  const RateAUSer({this.id});

  @override
  _RateAUSerState createState() => _RateAUSerState();
}

class _RateAUSerState extends State<RateAUSer> {
  final _formKey = GlobalKey<FormState>();

  double _rateValue = 50;

  bool _tappedFace = false;

  final _commentController = TextEditingController();

  final UsersController _usersController = Get.put(UsersController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: kBoxDecorationBottomSheet,
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                          'ما مدى رضاك عن سلوك هذا المستخدم خلال رحلتكما:',
                          style: kTextLabelStyle),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //
                          GestureDetector(
                            onTap: () => setState(() {
                              _rateValue = 0;
                              _tappedFace = true;
                            }),
                            child: _rateValue == 0
                                ? SvgPicture.asset(
                                    kImageVerySadFilled,
                                    color: kColorPrimary,
                                  )
                                : SvgPicture.asset(
                                    kImageVerySadOutlined,
                                    color: kColorSecondary,
                                  ),
                          ),
                          //
                          GestureDetector(
                            onTap: () => setState(() {
                              _rateValue = 25;
                              _tappedFace = true;
                            }),
                            child: _rateValue == 25
                                ? SvgPicture.asset(
                                    kImageSadFilled,
                                    color: kColorPrimary,
                                  )
                                : SvgPicture.asset(
                                    kImageSadOutlined,
                                    color: kColorSecondary,
                                  ),
                          ),
                          //
                          GestureDetector(
                            onTap: () => setState(() {
                              _rateValue = 50;
                              _tappedFace = true;
                            }),
                            child: _rateValue == 50 && _tappedFace
                                ? SvgPicture.asset(
                                    kImageNeutralFilled,
                                    color: kColorPrimary,
                                  )
                                : SvgPicture.asset(
                                    kImageNeutralOutlined,
                                    color: kColorSecondary,
                                  ),
                          ),
                          //
                          GestureDetector(
                            onTap: () => setState(() {
                              _rateValue = 75;
                              _tappedFace = true;
                            }),
                            child: _rateValue == 75
                                ? SvgPicture.asset(
                                    kImageSmilingFilled,
                                    color: kColorPrimary,
                                  )
                                : SvgPicture.asset(
                                    kImageSmilingOutlined,
                                    color: kColorSecondary,
                                  ),
                          ),
                          //
                          GestureDetector(
                            onTap: () => setState(() {
                              _rateValue = 100;
                              _tappedFace = true;
                            }),
                            child: _rateValue == 100
                                ? SvgPicture.asset(
                                    kImageLaughingFilled,
                                    color: kColorPrimary,
                                  )
                                : SvgPicture.asset(
                                    kImageLaughingOutlined,
                                    color: kColorSecondary,
                                  ),
                          ),
                          //
                        ],
                      ),
                      const SizedBox(height: 20),
                      stringField(
                        label: 'ملاحظات',
                        validator: true,
                        controller: _commentController,
                      ),
                      const SizedBox(height: 10),
                      ButtonPrimaryButton(
                        title: 'تأكيد التقييم',
                        color: kColorPrimary,
                        minWidth: 350,
                        hight: 42,
                        onPressed: () async {
                          if (!_tappedFace) {
                            setState(() {
                              _rateValue = 50;
                              _tappedFace = true;
                            });
                            return;
                          }
                          if (_formKey.currentState.validate() && _tappedFace) {
                            loadingDialog();
                            final bool result =
                                await _usersController.rateAUser(
                              id: widget.id,
                              value: _rateValue,
                              comment: _commentController.text,
                            );
                            Get.back();
                            if (result) {
                              Get.back(result: true);
                              mySnackbar(
                                  title:
                                      'شكراً لك، فمشاركتك تساعدنا على بناء تطبيق آمن للجميع');
                            } else {
                              mySnackbar(title: UsersController.errorMessage);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
