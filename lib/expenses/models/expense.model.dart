import 'package:flutter/material.dart';

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
      datum.hashCode + naam.hashCode + afBij.hashCode + bedrag.hashCode + mededeling.hashCode;

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
    afBij: FromTo.af.name,
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

enum FromTo { af, bij }

extension FromToExtension on FromTo {
  static const names = {
    FromTo.af: "Af",
    FromTo.bij: "Bij",
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
    ExpenseCategory.vasteLasten: "Vaste Lasten",
    ExpenseCategory.onderhoud: "Onderhoud",
    ExpenseCategory.boodschappen: "Boodschappen",
    ExpenseCategory.shoppen: "Shoppen",
    ExpenseCategory.verzorging: "Verzorging",
    ExpenseCategory.kids: "Kids",
    ExpenseCategory.meubilair: "Meubilair",
    ExpenseCategory.zorgkosten: "Zorgkosten",
    ExpenseCategory.opleiding: "Opleiding",
    ExpenseCategory.vakantie: "Vakantie",
    ExpenseCategory.reizen: "Reizen",
    ExpenseCategory.hobby: "Hobby",
    ExpenseCategory.overig: "Overig",
    ExpenseCategory.inkomen: "Inkomen",
    ExpenseCategory.investeren: "Investeren",
    ExpenseCategory.belastingdienst: "Belastingdienst",
    ExpenseCategory.extraMartin: "Extra (Martin)",
    ExpenseCategory.extraVera: "Extra (Vera)",
    ExpenseCategory.extraSamen: "Extra (M&V)",
    ExpenseCategory.onbekend: "Onbekend",
  };

  String get name => names[this]!;

  static final colors = {
    ExpenseCategory.geen: Colors.red[700],
    ExpenseCategory.vasteLasten: Colors.orange[700],
    ExpenseCategory.onderhoud: Colors.amber[700],
    ExpenseCategory.boodschappen: Colors.yellow[700],
    ExpenseCategory.shoppen: Colors.lime[700],
    ExpenseCategory.verzorging: Colors.green[700],
    ExpenseCategory.kids: Colors.cyan[700],
    ExpenseCategory.meubilair: Colors.blue[700],
    ExpenseCategory.zorgkosten: Colors.indigo[700],
    ExpenseCategory.opleiding: Colors.purple[700],
    ExpenseCategory.vakantie: Colors.pink[700],
    ExpenseCategory.reizen: Colors.red[400],
    ExpenseCategory.hobby: Colors.orange[400],
    ExpenseCategory.overig: Colors.amber[400],
    ExpenseCategory.inkomen: Colors.yellow[400],
    ExpenseCategory.investeren: Colors.lime[400],
    ExpenseCategory.belastingdienst: Colors.green[400],
    ExpenseCategory.extraMartin: Colors.teal[400],
    ExpenseCategory.extraVera: Colors.cyan[400],
    ExpenseCategory.extraSamen: Colors.blue[400],
    ExpenseCategory.onbekend: Colors.indigo[400],
  };

  Color get color => colors[this]!;
}
