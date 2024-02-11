import 'package:form_field_validator/form_field_validator.dart';

final nameValidator = MultiValidator([
  // 必須入力チェック
  RequiredValidator(errorText: "授業名は必須です"),
  // 最大長チェック
  MaxLengthValidator(5, errorText: "名前は5文字以内で入力してください")
]);
