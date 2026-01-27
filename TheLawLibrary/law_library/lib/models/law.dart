// lib/models/law.dart

// Ensure this is present if needed elsewhere

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

  // ADD THIS NEW factory Law.fromMap constructor
  factory Law.fromMap(Map<String, dynamic> map) {
    return Law(
      // Assuming map keys are similar to JSON keys from your API for consistency.
      // Adjust map['Key'] if your database column names are different (e.g., all lowercase).
      chapter: map['Chapter'] as String,
      category: map['Category'] as String,
      title: map['Title'] as String,
      description: map['Description'] as String,
      compoundFine:
          map['Compound_Fine']?.toString(), // Safely convert to String
      secondCompoundFine: map['Second_Compound_Fine']?.toString(),
      thirdCompoundFine: map['Third_Compound_Fine']?.toString(),
      fourthCompoundFine: map['Fourth_Compound_Fine']?.toString(),
      fifthCompoundFine: map['Fifth_Compound_Fine']?.toString(),
      isFavorite: map['isFavorite'] ==
          1, // Or map['is_favorite'] == 1 if column name is different
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
