// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Pontaj PRO';

  @override
  String get appSubtitle => '10,000x Better Edition';

  @override
  String get login => 'Accesso';

  @override
  String get loginTitle => 'Accedi';

  @override
  String get loginSubtitle =>
      'Gestisci i fogli presenze in modo rapido e intuitivo';

  @override
  String get loginButton => 'Accedi';

  @override
  String get createAccount => 'Crea un nuovo account';

  @override
  String get register => 'Registrazione';

  @override
  String get createAccountButton => 'Crea account';

  @override
  String get processing => 'Elaborazione...';

  @override
  String get accountCreated => 'Account creato. Effettua l\'accesso.';

  @override
  String get email => 'Email';

  @override
  String get displayName => 'Nome visualizzato';

  @override
  String get optional => '(opzionale)';

  @override
  String get adminCode => 'Codice amministratore';

  @override
  String get adminCodeOptional => 'Hai un codice amministratore?';

  @override
  String get adminCodeHelper =>
      'Inserisci il codice segreto per registrarti come admin';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Conferma password';

  @override
  String get required => 'Obbligatorio';

  @override
  String minCharacters(int count) {
    return 'Minimo $count caratteri';
  }

  @override
  String get passwordsDoNotMatch => 'Le password non corrispondono';

  @override
  String get administrator => 'Amministratore';

  @override
  String get settings => 'Impostazioni';

  @override
  String get logout => 'Esci';

  @override
  String hello(String name) {
    return 'Ciao, $name';
  }

  @override
  String get chooseAction => 'Scegli l\'azione desiderata per continuare';

  @override
  String pontajAs(String name) {
    return 'Foglio presenze come $name';
  }

  @override
  String get addPontajForToday => 'Aggiungi foglio presenze per oggi';

  @override
  String get viewAllEntries => 'Visualizza tutte le voci';

  @override
  String get manageAndAnalyze => 'Gestisci e analizza tutte le voci';

  @override
  String get manageSalaries => 'Gestisci stipendi';

  @override
  String get configureAndCalculate => 'Configura e calcola gli stipendi';

  @override
  String get addPontaj => 'Aggiungi foglio presenze';

  @override
  String get location => 'Posizione';

  @override
  String get locationHint => 'Es: Casa A, Fabbrica';

  @override
  String get enterLocation => 'Inserisci posizione';

  @override
  String get quickHours => 'Ore lavorate rapide';

  @override
  String nHours(int count) {
    return '$count ore';
  }

  @override
  String get useCustomInterval => 'Usa intervallo personalizzato';

  @override
  String get customInterval => 'Intervallo personalizzato';

  @override
  String get startTime => 'Ora inizio';

  @override
  String get endTime => 'Ora fine';

  @override
  String get breakTime => 'Pausa';

  @override
  String get noBreak => 'Nessuna pausa';

  @override
  String nMinutes(int count) {
    return '$count min';
  }

  @override
  String get totalHoursWorked => 'Totale ore lavorate';

  @override
  String get savePontaj => 'Salva foglio presenze';

  @override
  String get pontajSaved => 'Foglio presenze salvato';

  @override
  String get pontajDeleted => 'Foglio presenze eliminato';

  @override
  String get workedTimeMustBePositive =>
      'Il tempo lavorato deve essere positivo';

  @override
  String get existingPontajWarning =>
      'Hai gia un foglio presenze per il giorno selezionato!';

  @override
  String get delete => 'Elimina';

  @override
  String get otherDay => 'Altro giorno';

  @override
  String get total => 'Totale';

  @override
  String get pontajAdmin => 'Fogli presenze - Amministratore';

  @override
  String get dashboard => 'Pannello di controllo';

  @override
  String get users => 'Utenti';

  @override
  String get table => 'Tabella';

  @override
  String get salaries => 'Stipendi';

  @override
  String get noPontaj => 'Nessun foglio presenze';

  @override
  String get couldNotLoadData => 'Impossibile caricare i dati';

  @override
  String nDays(int count) {
    return '$count giorni';
  }

  @override
  String nDaysRegistered(int count) {
    return '$count giorni registrati';
  }

  @override
  String nDaysWorked(int count) {
    return '$count giorni lavorati';
  }

  @override
  String get usersTable => 'Tabella Utenti';

  @override
  String get user => 'Utente';

  @override
  String get days => 'Giorni';

  @override
  String get totalHours => 'Ore totali';

  @override
  String get totalDays => 'Giorni Totali';

  @override
  String get averagePerDay => 'Media/Giorno';

  @override
  String pontajUser(String name) {
    return 'Fogli presenze - $name';
  }

  @override
  String get noPontajForUser => 'Nessun foglio presenze per questo utente.';

  @override
  String get date => 'Data';

  @override
  String get interval => 'Intervallo';

  @override
  String get hoursPerUser => 'Ore per utente';

  @override
  String get recentActivity => 'Attivita recente';

  @override
  String get noActivity => 'Nessuna attivita';

  @override
  String get salarySummary => 'Riepilogo Stipendi';

  @override
  String get calculationBasedOnPontaj => 'Calcolo basato sulle voci registrate';

  @override
  String get noPontajForSalary => 'Nessuna voce per il calcolo degli stipendi';

  @override
  String get hoursDecimal => 'Ore (decimale)';

  @override
  String get appearance => 'Aspetto';

  @override
  String get darkMode => 'Modalita scura';

  @override
  String get light => 'Chiaro';

  @override
  String get dark => 'Scuro';

  @override
  String get auto => 'Automatico';

  @override
  String get accentColor => 'Colore accento';

  @override
  String get current => 'Attuale';

  @override
  String get information => 'Informazioni';

  @override
  String get version => 'Versione';

  @override
  String get developedBy => 'Sviluppato da';

  @override
  String get status => 'Stato';

  @override
  String get allSystemsOperational => 'Tutti i sistemi operativi';

  @override
  String get language => 'Lingua';

  @override
  String get romanian => 'Rumeno';

  @override
  String get english => 'Inglese';

  @override
  String get italian => 'Italiano';

  @override
  String get unknownRoute => 'Percorso sconosciuto';

  @override
  String get routeNotDefined => 'Il percorso richiesto non e definito.';

  @override
  String get backToLogin => 'Torna al Login';

  @override
  String get invalidFormat => 'Formato non valido';
}
