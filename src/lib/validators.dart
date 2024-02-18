import 'package:form_field_validator/form_field_validator.dart';

final nameValidator = MultiValidator([
  // 必須入力チェック
  RequiredValidator(errorText: "授業名は必須です"),
  // 最大長チェック
  MaxLengthValidator(20, errorText: "20文字以内で入力してください")
]);

//単位数1以上