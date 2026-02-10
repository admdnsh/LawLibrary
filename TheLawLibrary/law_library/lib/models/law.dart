// lib/models/law.dart

class Law {
  final String chapter;
  final String category;
  final String title;
  final String description;

  final String? compoundFine;
  final String? secondCompoundFine;
  final String? thirdCompoundFine;
  final String? fourthCompoundFine;
  final String? fifthCompoundFine;

  bool isFavorite;

  Law({
    required this.chapter,
    required this.category,
    required this.title,
    required this.description,
    this.compoundFine,
    this.secondCompoundFine,
    this.thirdCompoundFine,
    this.fourthCompoundFine,
    this.fifthCompoundFine,
    this.isFavorite = false,
  });

  // --- JSON Parsing (from API) ---
  factory Law.fromJson(Map<String, dynamic> json) {
    return Law(
      chapter: json['Chapter'] as String,
      category: json['Category'] as String,
      title: json['Title'] as String,
      description: json['Description'] as String,
      compoundFine: json['Compound_Fine']?.toString(),
      secondCompoundFine: json['Second_Compound_Fine']?.toString(),
      thirdCompoundFine: json['Third_Compound_Fine']?.toString(),
      fourthCompoundFine: json['Fourth_Compound_Fine']?.toString(),
      fifthCompoundFine: json['Fifth_Compound_Fine']?.toString(),
      isFavorite: json['isFavorite'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Chapter': chapter,
      'Category': category,
      'Title': title,
      'Description': description,
      'Compound_Fine': compoundFine,
      'Second_Compound_Fine': secondCompoundFine,
      'Third_Compound_Fine': thirdCompoundFine,
      'Fourth_Compound_Fine': fourthCompoundFine,
      'Fifth_Compound_Fine': fifthCompoundFine,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  // --- Database (Sqflite) Mapping ---
  factory Law.fromMap(Map<String, dynamic> map) {
    return Law(
      chapter: map['chapter'] as String,
      category: map['category'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      compoundFine: map['compound_fine']?.toString(),
      secondCompoundFine: map['second_compound_fine']?.toString(),
      thirdCompoundFine: map['third_compound_fine']?.toString(),
      fourthCompoundFine: map['fourth_compound_fine']?.toString(),
      fifthCompoundFine: map['fifth_compound_fine']?.toString(),
      isFavorite: true, // everything in favorites table is favorite
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chapter': chapter,
      'category': category,
      'title': title,
      'description': description,
      'compound_fine': compoundFine,
      'second_compound_fine': secondCompoundFine,
      'third_compound_fine': thirdCompoundFine,
      'fourth_compound_fine': fourthCompoundFine,
      'fifth_compound_fine': fifthCompoundFine,
      // isFavorite is implicit in favorites table, so not included
    };
  }

  // --- Copy method for immutability ---
  Law copyWith({
    String? chapter,
    String? category,
    String? title,
    String? description,
    String? compoundFine,
    String? secondCompoundFine,
    String? thirdCompoundFine,
    String? fourthCompoundFine,
    String? fifthCompoundFine,
    bool? isFavorite,
  }) {
    return Law(
      chapter: chapter ?? this.chapter,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      compoundFine: compoundFine ?? this.compoundFine,
      secondCompoundFine: secondCompoundFine ?? this.secondCompoundFine,
      thirdCompoundFine: thirdCompoundFine ?? this.thirdCompoundFine,
      fourthCompoundFine: fourthCompoundFine ?? this.fourthCompoundFine,
      fifthCompoundFine: fifthCompoundFine ?? this.fifthCompoundFine,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
