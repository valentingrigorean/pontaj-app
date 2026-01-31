// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'Pontaj PRO';

  @override
  String get appSubtitle => '10,000x Better Edition';

  @override
  String get login => 'Autentificare';

  @override
  String get loginTitle => 'Intra in cont';

  @override
  String get loginSubtitle => 'Gestioneaza pontajele rapid si intuitiv';

  @override
  String get loginButton => 'Intra in aplicatie';

  @override
  String get createAccount => 'Creeaza un cont nou';

  @override
  String get register => 'Inregistrare';

  @override
  String get createAccountButton => 'Creeaza cont';

  @override
  String get processing => 'Se proceseaza...';

  @override
  String get accountCreated => 'Cont creat. Autentificati-va.';

  @override
  String get email => 'Email';

  @override
  String get displayName => 'Nume afisat';

  @override
  String get optional => '(optional)';

  @override
  String get adminCode => 'Cod administrator';

  @override
  String get adminCodeOptional => 'Ai un cod de administrator?';

  @override
  String get adminCodeHelper =>
      'Introdu codul secret pentru a te inregistra ca admin';

  @override
  String get password => 'Parola';

  @override
  String get confirmPassword => 'Confirma parola';

  @override
  String get required => 'Obligatoriu';

  @override
  String minCharacters(int count) {
    return 'Minim $count caractere';
  }

  @override
  String get passwordsDoNotMatch => 'Parolele nu coincid';

  @override
  String get administrator => 'Administrator';

  @override
  String get settings => 'Setari';

  @override
  String get logout => 'Deconectare';

  @override
  String hello(String name) {
    return 'Salut, $name';
  }

  @override
  String get chooseAction => 'Alege actiunea dorita pentru a continua';

  @override
  String pontajAs(String name) {
    return 'Pontaj ca $name';
  }

  @override
  String get addPontajForToday => 'Adauga pontaj pentru ziua curenta';

  @override
  String get viewAllEntries => 'Vezi pontajele tuturor';

  @override
  String get manageAndAnalyze => 'Gestioneaza si analizeaza toate intrarile';

  @override
  String get manageSalaries => 'Gestioneaza salarii';

  @override
  String get configureAndCalculate => 'Configureaza si calculeaza salariile';

  @override
  String get addPontaj => 'Adauga pontaj';

  @override
  String get location => 'Locatie';

  @override
  String get locationHint => 'Ex: Casa A, Fabrica';

  @override
  String get enterLocation => 'Introdu locatia';

  @override
  String get quickHours => 'Ore lucrate rapide';

  @override
  String nHours(int count) {
    return '$count ore';
  }

  @override
  String get useCustomInterval => 'Foloseste interval personalizat';

  @override
  String get customInterval => 'Interval personalizat';

  @override
  String get startTime => 'Ora inceput';

  @override
  String get endTime => 'Ora sfarsit';

  @override
  String get breakTime => 'Pauza';

  @override
  String get noBreak => 'Fara pauza';

  @override
  String nMinutes(int count) {
    return '$count min';
  }

  @override
  String get totalHoursWorked => 'Total ore lucrate';

  @override
  String get savePontaj => 'Salveaza pontaj';

  @override
  String get pontajSaved => 'Pontaj salvat';

  @override
  String get pontajDeleted => 'Pontaj sters';

  @override
  String get workedTimeMustBePositive => 'Timpul lucrat trebuie sa fie pozitiv';

  @override
  String get existingPontajWarning =>
      'Ai deja un pontaj pentru ziua selectata!';

  @override
  String get delete => 'Sterge';

  @override
  String get otherDay => 'Alta zi';

  @override
  String get total => 'Total';

  @override
  String get pontajAdmin => 'Pontaje - Administrator';

  @override
  String get dashboard => 'Tablou de Bord';

  @override
  String get users => 'Utilizatori';

  @override
  String get table => 'Tabel';

  @override
  String get salaries => 'Salarii';

  @override
  String get noPontaj => 'Niciun pontaj';

  @override
  String get couldNotLoadData => 'Nu s-au putut incarca datele';

  @override
  String nDays(int count) {
    return '$count zile';
  }

  @override
  String nDaysRegistered(int count) {
    return '$count zile inregistrate';
  }

  @override
  String nDaysWorked(int count) {
    return '$count zile lucrate';
  }

  @override
  String get usersTable => 'Tabel Utilizatori';

  @override
  String get user => 'Utilizator';

  @override
  String get days => 'Zile';

  @override
  String get totalHours => 'Total ore';

  @override
  String get totalDays => 'Total Zile';

  @override
  String get averagePerDay => 'Medie/Zi';

  @override
  String pontajUser(String name) {
    return 'Pontaje - $name';
  }

  @override
  String get noPontajForUser => 'Nu exista pontaje pentru acest utilizator.';

  @override
  String get date => 'Data';

  @override
  String get interval => 'Interval';

  @override
  String get hoursPerUser => 'Ore pe utilizator';

  @override
  String get recentActivity => 'Activitate recenta';

  @override
  String get noActivity => 'Nicio activitate';

  @override
  String get salarySummary => 'Sumar Salarii';

  @override
  String get calculationBasedOnPontaj =>
      'Calcul pe baza pontajelor inregistrate';

  @override
  String get noPontajForSalary => 'Niciun pontaj pentru calcul salarii';

  @override
  String get hoursDecimal => 'Ore (decimal)';

  @override
  String get appearance => 'Aspect';

  @override
  String get darkMode => 'Mod intunecat';

  @override
  String get light => 'Luminos';

  @override
  String get dark => 'Intunecat';

  @override
  String get auto => 'Automat';

  @override
  String get accentColor => 'Culoare accent';

  @override
  String get current => 'Curent';

  @override
  String get information => 'Informatii';

  @override
  String get version => 'Versiune';

  @override
  String get developedBy => 'Dezvoltat de';

  @override
  String get status => 'Status';

  @override
  String get allSystemsOperational => 'Toate sistemele functionale';

  @override
  String get language => 'Limba';

  @override
  String get romanian => 'Romana';

  @override
  String get english => 'Engleza';

  @override
  String get italian => 'Italiana';

  @override
  String get unknownRoute => 'Ruta necunoscuta';

  @override
  String get routeNotDefined => 'Ruta solicitata nu este definita.';

  @override
  String get backToLogin => 'Inapoi la Login';

  @override
  String get invalidFormat => 'Format invalid';

  @override
  String get registrationError => 'Eroare la inregistrare';

  @override
  String get ok => 'OK';

  @override
  String get orContinueWith => 'sau continua cu';

  @override
  String get continueWithGoogle => 'Continua cu Google';
}
