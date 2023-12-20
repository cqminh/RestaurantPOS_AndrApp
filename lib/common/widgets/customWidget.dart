import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/common/config/app_color.dart';
import 'package:test/common/config/app_font.dart';

class CustomMiniWidget {
  CustomMiniWidget._();

  static Widget searchField(
      {String? placeholderText,
      Icon? prefixIcon,
      double? height,
      double? width,
      TextStyle? hintStyle}) {
    return Container(
      height: height ?? Get.height * 0.05,
      width: width ?? Get.width * 0.3,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: prefixIcon ??
                Icon(
                  Icons.search,
                  color: AppColors.iconColor,
                ),
            hintText: placeholderText ?? '',
            hintStyle: hintStyle ??
                AppFont.Body_Regular(color: AppColors.placeholderText),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            suffixIcon: InkWell(
              onTap: () {},
              child: Icon(
                Icons.cancel,
                color: AppColors.iconColor,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget listButton({String? title, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: Get.width * 0.03),
        height: Get.height * 0.04,
        width: Get.width * 0.25,
        decoration: BoxDecoration(
            color: AppColors.bgDark,
            // border: Border.all(color: AppColors.borderColor),
            borderRadius: BorderRadius.circular(5)),
        child: Center(
            child: Text(
          title ?? 'title',
          overflow: TextOverflow.ellipsis,
          style: AppFont.Body_Regular(color: AppColors.white),
        )),
      ),
    );
  }

  static Widget listButtonChosen({String? title}) {
    return Container(
      height: Get.height * 0.04,
      width: Get.width * 0.2,
      decoration: BoxDecoration(
          color: AppColors.chosenColor,
          // border: Border.all(color: AppColors.chosenColor),
          borderRadius: BorderRadius.circular(5)),
      child: Center(
          child: Text(
        title ?? 'title',
        overflow: TextOverflow.ellipsis,
        style: AppFont.Body_Regular(color: AppColors.white),
      )),
    );
  }

  static Widget searchAndChooseButton<T>(
      {double? height,
      double? width,
      String? title,
      String? hint,
      T? value,
      List<DropdownMenuItem<T>>? items,
      Function(T?)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title ?? 'Tiêu đề',
          style: AppFont.Title_TF_Regular(),
        ),
        SizedBox(
          height: Get.height * 0.008,
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            style: AppFont.Body_Regular(),
            buttonPadding: const EdgeInsets.only(left: 10),
            buttonDecoration: BoxDecoration(
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(10),
              color: AppColors.white,
            ),
            buttonHeight: height ?? Get.height * 0.05,
            buttonWidth: width ?? Get.width * 0.9,
            value: value,
            // value: choosablePartner[0],
            items: items,
            hint: Text(
              hint ?? '',
              overflow: TextOverflow.ellipsis,
            ),
            onChanged: onChanged,
            dropdownMaxHeight: Get.height * 0.4,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  static Widget searchAndChooseButtonFixed(
      {double? height, double? width, String? title, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title ?? 'Tiêu đề',
          style: AppFont.Title_TF_Regular(),
        ),
        SizedBox(
          height: Get.height * 0.008,
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 10),
          height: height ?? Get.height * 0.05,
          width: width,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.borderColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            hint ?? '',
            style: AppFont.Body_Regular(color: AppColors.borderColor),
          ),
        ),
      ],
    );
  }

  static Widget paymentButton(
      {String? name,
      double? height,
      double? width,
      Color? color,
      Color? textColor,
      Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        color: color ?? AppColors.bgDark,
        height: height,
        width: width ?? Get.width * 0.5,
        child: Text(
          name ?? '',
          style: AppFont.Title_H6_Bold(color: textColor ?? AppColors.white),
        ),
      ),
    );
  }

  static Widget paymentLine(
      {String? name,
      TextStyle? nameStyle,
      String? value,
      TextStyle? valueStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name ?? 'Tên',
          style: nameStyle ?? AppFont.Title_H5_Bold(),
        ),
        Text(
          '${value ?? 0} đ',
          style: valueStyle ?? AppFont.Title_H5_Bold(),
        ),
      ],
    );
  }

  static Widget titlePopUp({String? title, bool? exitButton}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title ?? '',
              style: AppFont.Title_H6_Bold(),
            ),
            exitButton == true
                ? InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.close),
                  )
                : const Text(''),
          ],
        ),
        Divider(
          color: AppColors.borderColor,
        ),
      ],
    );
  }

  static Widget loading({Color? color}) {
    return CircularProgressIndicator(
      color: color ?? AppColors.white,
    );
  }

  static Widget titleTableCell({String? name, double? width}) {
    return SizedBox(
      width: width ?? Get.width * 0.01,
      child: Text(
        name ?? '',
        style: AppFont.Title_H6_Bold(size: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  static Widget filterButton(
      {double? height,
      double? width,
      Color? color,
      String? title,
      Color? titleColor,
      Function()? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '',
          style: AppFont.Title_TF_Regular(),
        ),
        SizedBox(height: Get.height * 0.008),
        InkWell(
          onTap: onTap,
          child: Container(
            height: Get.height * 0.05,
            width: Get.width * 0.08,
            decoration: BoxDecoration(
                color: color ?? AppColors.white,
                // border: Border.all(color: AppColors.borderColor),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: Text(
              title ?? '',
              overflow: TextOverflow.ellipsis,
              style: AppFont.Body_Regular(color: titleColor),
            )),
          ),
        ),
      ],
    );
  }

  static Widget textFieldWithTitle(
      {double? height,
      double? width,
      String? title,
      String? hint,
      TextEditingController? controller,
      Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title ?? 'Tiêu đề',
          style: AppFont.Title_TF_Regular(),
        ),
        SizedBox(
          height: Get.height * 0.008,
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 10),
          height: height ?? Get.height * 0.05,
          width: width ?? Get.width * 0.9,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.borderColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppFont.Body_Regular(color: AppColors.borderColor),
                border: InputBorder.none),
          ),
        ),
      ],
    );
  }

  static Widget squareButton(
      {Widget? child,
      Color? color,
      Function()? onTap,
      double? height,
      double? width}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: height ?? Get.height * 0.04,
        width: width ?? Get.width * 0.2,
        decoration: BoxDecoration(
          color: color ?? AppColors.bgDark,
          borderRadius: BorderRadius.circular(5),
        ),
        child: child,
      ),
    );
  }
}
