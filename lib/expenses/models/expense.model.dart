class Expense {
  int? id;
  DateTime datum;
  String naam;
  String rekening;
  String tegenRekening;
  String code;
  String afBij;
  num bedrag;
  String mutatieSoort;
  String mededeling;
  ExpenseCategory category;

  @override
  bool operator ==(Object other) =>
      other is Expense &&
      other.datum == datum &&
      other.naam == naam &&
      other.afBij == afBij &&
      other.bedrag == bedrag &&
      other.mededeling == mededeling;

  @override
  int get hashCode =>
      datum.hashCode +
      naam.hashCode +
      afBij.hashCode +
      bedrag.hashCode +
      mededeling.hashCode;

  Expense({
    this.id,
    required this.datum,
    required this.naam,
    required this.rekening,
    required this.tegenRekening,
    required this.code,
    required this.afBij,
    required this.bedrag,
    required this.mutatieSoort,
    required this.mededeling,
    this.category = ExpenseCategory.geen,
  });

  Map<String, dynamic> toMap() {
    return {
      'datum': datum.millisecondsSinceEpoch,
      'naam': naam,
      'rekening': rekening,
      'tegenRekening': tegenRekening,
      'code': code,
      'afBij': afBij,
      'bedrag': bedrag,
      'mutatieSoort': mutatieSoort,
      'mededeling': mededeling,
      'category': category.toString(),
    };
  }

  @override
  String toString() {
    return 'Uitgave{id: $id, datum: $datum, naam: $naam, rekening: $rekening, tegenrekening: $tegenRekening, code: $code, afBij: $afBij, bedrag: $bedrag, mutatieSoort: $mutatieSoort, mededeling: $mededeling, category: $category}';
  }

  static final uitgave1 = Expense(
    datum: DateTime.now(),
    naam: 'Odin Deventer DEVENTER NLD',
    rekening: 'rekening',
    tegenRekening: 'tegenrekening',
    code: 'code',
    afBij: AfBij.af.name,
    bedrag: 25,
    mutatieSoort: 'mutatiesoort',
    mededeling: 'mededeling',
    category: ExpenseCategory.geen,
  );

  static final uitgave1modified = Expense(
    datum: uitgave1.datum,
    naam: uitgave1.naam,
    rekening: uitgave1.rekening,
    tegenRekening: uitgave1.tegenRekening,
    code: uitgave1.code,
    afBij: uitgave1.afBij,
    bedrag: uitgave1.bedrag + 20,
    mutatieSoort: uitgave1.mutatieSoort,
    mededeling: uitgave1.mededeling,
  );
}

enum AfBij { af, bij }

extension AfBijExtension on AfBij {
  static const names = {
    AfBij.af: "Af",
    AfBij.bij: "Bij",
  };

  String get name => names[this]!;
}

enum ExpenseCategory {
  geen,
  vasteLasten,
  onderhoud,
  boodschappen,
  shoppen,
  verzorging,
  kids,
  meubilair,
  zorgkosten,
  opleiding,
  vakantie,
  reizen,
  hobby,
  overig,
  inkomen,
  investeren,
  belastingdienst,
  extraMartin,
  extraVera,
  extraSamen,
  onbekend
}

extension ExpenseCategoryExtension on ExpenseCategory {
  static const names = {
    ExpenseCategory.geen: "Geen",
    ExpenseCategory.inkomen: "Inkomen",
    ExpenseCategory.onderhoud: "Onderhoud",
    ExpenseCategory.vasteLasten: "Vaste Lasten",
    ExpenseCategory.meubilair: "Meubilair",
    ExpenseCategory.boodschappen: "Boodschappen",
    ExpenseCategory.shoppen: "Shoppen",
    ExpenseCategory.verzorging: "Verzorging",
    ExpenseCategory.zorgkosten: "Zorgkosten",
    ExpenseCategory.kids: "Kids",
    ExpenseCategory.reizen: "Reizen",
    ExpenseCategory.vakantie: "Vakantie",
    ExpenseCategory.hobby: "Hobby",
    ExpenseCategory.investeren: "Investeren",
    ExpenseCategory.extraMartin: "Extra (Martin)",
    ExpenseCategory.extraVera: "Extra (Vera)",
    ExpenseCategory.extraSamen: "Extra (M&V)",
    ExpenseCategory.opleiding: "Opleiding",
    ExpenseCategory.belastingdienst: "Belastingdienst",
    ExpenseCategory.overig: "Overig",
    ExpenseCategory.onbekend: "Onbekend",
  };

  String get name => names[this]!;
}
