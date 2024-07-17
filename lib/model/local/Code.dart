// JSON 파싱 함수
import 'dart:convert';

List<CodeType> codeTypeFromJson(dynamic jsonData) {
  return List<CodeType>.from(jsonData.map((item) => CodeType.fromJson(item)));
}

String codeTypeToJson(List<CodeType> data) {
  final jsonData = data.map((item) => item.toJson()).toList();
  return json.encode(jsonData);
}

class CodeType {
  final int id;
  final String title;
  final String info;
  final List<CodeCategory> codeCategories;

  CodeType({
    required this.id,
    required this.title,
    required this.info,
    required this.codeCategories,
  });

  factory CodeType.fromJson(Map<String, dynamic> json) {
    var codeCategoriesFromJson = json['codeCategories'] as List;
    List<CodeCategory> codeCategoriesList = codeCategoriesFromJson.map((i) => CodeCategory.fromJson(i)).toList();

    return CodeType(
      id: json['id'],
      title: json['title'],
      info: json['info'],
      codeCategories: codeCategoriesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'info': info,
      'codeCategories': codeCategories.map((e) => e.toJson()).toList(),
    };
  }
}


class CodeCategory {
  final int id;
  final String title;
  final String info;
  final List<CodeItem> codeItems;

  CodeCategory({
    required this.id,
    required this.title,
    required this.info,
    required this.codeItems,
  });

  factory CodeCategory.fromJson(Map<String, dynamic> json) {
    var codeItemsFromJson = json['codeItems'] as List;
    List<CodeItem> codeItemsList = codeItemsFromJson.map((i) => CodeItem.fromJson(i)).toList();

    return CodeCategory(
      id: json['id'],
      title: json['title'],
      info: json['info'],
      codeItems: codeItemsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'info': info,
      'codeItems': codeItems.map((e) => e.toJson()).toList(),
    };
  }
}


class CodeItem {
  final int id;
  final String title;
  final String info;

  CodeItem({
    required this.id,
    required this.title,
    required this.info,
  });

  factory CodeItem.fromJson(Map<String, dynamic> json) {
    return CodeItem(
      id: json['id'],
      title: json['title'],
      info: json['info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'info': info,
    };
  }
}