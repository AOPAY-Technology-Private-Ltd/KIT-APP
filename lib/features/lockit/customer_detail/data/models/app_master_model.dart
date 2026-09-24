class SubActionModel {
  final String subactionName;
  final String packageName;
  final bool active;

  SubActionModel({
    required this.subactionName,
    required this.packageName,
    required this.active,
  });

  factory SubActionModel.fromJson(Map<String, dynamic> json) {
    return SubActionModel(
      subactionName: json['subactionName'] ?? '',
      packageName: json['packageName'] ?? '',
      active: json['active'] ?? false,
    );
  }
}

class AppMasterCategoryModel {
  final String actionName;
  final String notificationCode;
  final bool check;
  final List<SubActionModel> subactionList;

  AppMasterCategoryModel({
    required this.actionName,
    required this.notificationCode,
    required this.check,
    required this.subactionList,
  });

  factory AppMasterCategoryModel.fromJson(Map<String, dynamic> json) {
    var list = json['subactionList'] as List? ?? [];
    List<SubActionModel> subactions = list.map((i) => SubActionModel.fromJson(i)).toList();

    return AppMasterCategoryModel(
      actionName: json['actionName'] ?? '',
      notificationCode: json['notificationCode'] ?? '',
      check: json['check'] ?? false,
      subactionList: subactions,
    );
  }
}

class AppMasterModel {
  final List<AppMasterCategoryModel> categories;

  AppMasterModel({required this.categories});

  factory AppMasterModel.fromJson(Map<String, dynamic> json) {
    var catList = json['categories'] as List? ?? [];
    List<AppMasterCategoryModel> parsedCategories = catList
        .map((cat) => AppMasterCategoryModel.fromJson(cat))
        .toList();

    return AppMasterModel(categories: parsedCategories);
  }
}