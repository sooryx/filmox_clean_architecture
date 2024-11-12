class DTInfoFormEntity {
  final int dtID; // Made non-nullable
  final int? step; // Keep as nullable if it's optional
  final List<CategoryEntity> categories;
  final List<CategoryEntity> genres;
  final List<CategoryEntity> languages;

  DTInfoFormEntity({
    required this.dtID,
    this.step,
    required this.categories,
    required this.genres,
    required this.languages,
  });
}

class CategoryEntity {
  final int id;
  final String? title;

  CategoryEntity({
    required this.id,
    this.title,
  });
}
