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

  @override
  String get registrationError => 'Errore di registrazione';

  @override
  String get ok => 'OK';

  @override
  String get orContinueWith => 'oppure continua con';

  @override
  String get continueWithGoogle => 'Continua con Google';

  @override
  String get account => 'Account';

  @override
  String get adminUpgrade => 'Diventa Amministratore';

  @override
  String get adminUpgradeDesc =>
      'Inserisci il codice admin per aggiornare il tuo account';

  @override
  String get enterAdminCode => 'Inserisci codice admin';

  @override
  String get adminCodeRequired => 'Il codice admin e obbligatorio';

  @override
  String get invalidAdminCode => 'Codice admin non valido';

  @override
  String get upgradeSuccess =>
      'Account aggiornato ad amministratore con successo';

  @override
  String get confirmUpgrade => 'Conferma Aggiornamento';

  @override
  String get confirmUpgradeMessage =>
      'Sei sicuro di voler diventare amministratore?';

  @override
  String get youAreAdmin => 'Sei un amministratore';

  @override
  String get upgrade => 'Aggiorna';

  @override
  String get cancel => 'Annulla';

  @override
  String get pontaj => 'Foglio presenze';

  @override
  String get myEntries => 'Le mie registrazioni';

  @override
  String get logoutConfirmation => 'Conferma disconnessione';

  @override
  String get logoutConfirmationMessage =>
      'Sei sicuro di volerti disconnettere?';

  @override
  String get entriesTab => 'Registrazioni';

  @override
  String get addEntry => 'Aggiungi registrazione';

  @override
  String get timeOverlapError =>
      'Questo intervallo di tempo si sovrappone con una registrazione esistente';

  @override
  String get requireCustomInterval =>
      'Usa l\'intervallo personalizzato quando aggiungi più registrazioni per lo stesso giorno';

  @override
  String get thisWeek => 'Questa settimana';

  @override
  String get lastWeek => 'Settimana scorsa';

  @override
  String get thisMonth => 'Questo mese';

  @override
  String get topLocation => 'Posizione frequente';

  @override
  String get weeklyHours => 'Ore settimanali';

  @override
  String get dailyTarget => 'Obiettivo giornaliero';

  @override
  String get goodMorning => 'Buongiorno';

  @override
  String get goodAfternoon => 'Buon pomeriggio';

  @override
  String get goodEvening => 'Buonasera';

  @override
  String get hourlyRate => 'Tariffa oraria';

  @override
  String get editRate => 'Modifica tariffa';

  @override
  String get saveChanges => 'Salva modifiche';

  @override
  String get salarySettings => 'Impostazioni stipendio';

  @override
  String get selectSalaryType => 'Seleziona tipo di stipendio';

  @override
  String get selectCurrency => 'Seleziona valuta';

  @override
  String get invoices => 'Fatture';

  @override
  String get createInvoice => 'Crea fattura';

  @override
  String get period => 'Periodo';

  @override
  String get dueDate => 'Data di scadenza';

  @override
  String get notSet => 'Non impostato';

  @override
  String get change => 'Cambia';

  @override
  String get summary => 'Riepilogo';

  @override
  String get entries => 'Registrazioni';

  @override
  String get totalAmount => 'Importo totale';

  @override
  String get notes => 'Note';

  @override
  String get addNotesToInvoice => 'Aggiungi note alla fattura...';

  @override
  String get noEntriesForPeriod =>
      'Nessuna registrazione trovata per il periodo selezionato';

  @override
  String get week => 'Settimana';

  @override
  String get year => 'Anno';

  @override
  String get custom => 'Personalizzato';

  @override
  String get selectPeriod => 'Seleziona periodo';

  @override
  String get selectDateRange => 'Seleziona intervallo di date';

  @override
  String get timeOverlapDetected => 'Sovrapposizione di tempo rilevata';

  @override
  String get yourNewEntry => 'La tua nuova registrazione';

  @override
  String get conflictsWithEntry => 'Si sovrappone alla registrazione esistente';

  @override
  String get adjustTimesSuggestion =>
      'Regola l\'ora di inizio o di fine per evitare sovrapposizioni con le registrazioni esistenti.';

  @override
  String get editTimes => 'Modifica orari';

  @override
  String get thisPeriod => 'Questo periodo';

  @override
  String get lastPeriod => 'Periodo precedente';

  @override
  String get periodComparison => 'Confronto periodi';

  @override
  String get teamTrend => 'Tendenza del team';

  @override
  String get hoursByLocation => 'Ore per posizione';

  @override
  String get activeUsers => 'Utenti attivi';

  @override
  String get topUser => 'Utente top';

  @override
  String get daysWorked => 'Giorni lavorati';

  @override
  String get vsLastPeriod => 'vs Periodo precedente';
}
