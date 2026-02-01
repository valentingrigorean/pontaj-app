import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ro.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ro'),
    Locale('en'),
    Locale('it'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ro, this message translates to:
  /// **'Pontaj PRO'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In ro, this message translates to:
  /// **'10,000x Better Edition'**
  String get appSubtitle;

  /// No description provided for @login.
  ///
  /// In ro, this message translates to:
  /// **'Autentificare'**
  String get login;

  /// No description provided for @loginTitle.
  ///
  /// In ro, this message translates to:
  /// **'Intra in cont'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In ro, this message translates to:
  /// **'Gestioneaza pontajele rapid si intuitiv'**
  String get loginSubtitle;

  /// No description provided for @loginButton.
  ///
  /// In ro, this message translates to:
  /// **'Intra in aplicatie'**
  String get loginButton;

  /// No description provided for @createAccount.
  ///
  /// In ro, this message translates to:
  /// **'Creeaza un cont nou'**
  String get createAccount;

  /// No description provided for @register.
  ///
  /// In ro, this message translates to:
  /// **'Inregistrare'**
  String get register;

  /// No description provided for @createAccountButton.
  ///
  /// In ro, this message translates to:
  /// **'Creeaza cont'**
  String get createAccountButton;

  /// No description provided for @processing.
  ///
  /// In ro, this message translates to:
  /// **'Se proceseaza...'**
  String get processing;

  /// No description provided for @accountCreated.
  ///
  /// In ro, this message translates to:
  /// **'Cont creat. Autentificati-va.'**
  String get accountCreated;

  /// No description provided for @email.
  ///
  /// In ro, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @displayName.
  ///
  /// In ro, this message translates to:
  /// **'Nume afisat'**
  String get displayName;

  /// No description provided for @optional.
  ///
  /// In ro, this message translates to:
  /// **'(optional)'**
  String get optional;

  /// No description provided for @adminCode.
  ///
  /// In ro, this message translates to:
  /// **'Cod administrator'**
  String get adminCode;

  /// No description provided for @adminCodeOptional.
  ///
  /// In ro, this message translates to:
  /// **'Ai un cod de administrator?'**
  String get adminCodeOptional;

  /// No description provided for @adminCodeHelper.
  ///
  /// In ro, this message translates to:
  /// **'Introdu codul secret pentru a te inregistra ca admin'**
  String get adminCodeHelper;

  /// No description provided for @password.
  ///
  /// In ro, this message translates to:
  /// **'Parola'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In ro, this message translates to:
  /// **'Confirma parola'**
  String get confirmPassword;

  /// No description provided for @required.
  ///
  /// In ro, this message translates to:
  /// **'Obligatoriu'**
  String get required;

  /// No description provided for @minCharacters.
  ///
  /// In ro, this message translates to:
  /// **'Minim {count} caractere'**
  String minCharacters(int count);

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In ro, this message translates to:
  /// **'Parolele nu coincid'**
  String get passwordsDoNotMatch;

  /// No description provided for @administrator.
  ///
  /// In ro, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// No description provided for @settings.
  ///
  /// In ro, this message translates to:
  /// **'Setari'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In ro, this message translates to:
  /// **'Deconectare'**
  String get logout;

  /// No description provided for @hello.
  ///
  /// In ro, this message translates to:
  /// **'Salut, {name}'**
  String hello(String name);

  /// No description provided for @chooseAction.
  ///
  /// In ro, this message translates to:
  /// **'Alege actiunea dorita pentru a continua'**
  String get chooseAction;

  /// No description provided for @pontajAs.
  ///
  /// In ro, this message translates to:
  /// **'Pontaj ca {name}'**
  String pontajAs(String name);

  /// No description provided for @addPontajForToday.
  ///
  /// In ro, this message translates to:
  /// **'Adauga pontaj pentru ziua curenta'**
  String get addPontajForToday;

  /// No description provided for @viewAllEntries.
  ///
  /// In ro, this message translates to:
  /// **'Vezi pontajele tuturor'**
  String get viewAllEntries;

  /// No description provided for @manageAndAnalyze.
  ///
  /// In ro, this message translates to:
  /// **'Gestioneaza si analizeaza toate intrarile'**
  String get manageAndAnalyze;

  /// No description provided for @manageSalaries.
  ///
  /// In ro, this message translates to:
  /// **'Gestioneaza salarii'**
  String get manageSalaries;

  /// No description provided for @configureAndCalculate.
  ///
  /// In ro, this message translates to:
  /// **'Configureaza si calculeaza salariile'**
  String get configureAndCalculate;

  /// No description provided for @addPontaj.
  ///
  /// In ro, this message translates to:
  /// **'Adauga pontaj'**
  String get addPontaj;

  /// No description provided for @location.
  ///
  /// In ro, this message translates to:
  /// **'Locatie'**
  String get location;

  /// No description provided for @locationHint.
  ///
  /// In ro, this message translates to:
  /// **'Ex: Casa A, Fabrica'**
  String get locationHint;

  /// No description provided for @enterLocation.
  ///
  /// In ro, this message translates to:
  /// **'Introdu locatia'**
  String get enterLocation;

  /// No description provided for @quickHours.
  ///
  /// In ro, this message translates to:
  /// **'Ore lucrate rapide'**
  String get quickHours;

  /// No description provided for @nHours.
  ///
  /// In ro, this message translates to:
  /// **'{count} ore'**
  String nHours(int count);

  /// No description provided for @useCustomInterval.
  ///
  /// In ro, this message translates to:
  /// **'Foloseste interval personalizat'**
  String get useCustomInterval;

  /// No description provided for @customInterval.
  ///
  /// In ro, this message translates to:
  /// **'Interval personalizat'**
  String get customInterval;

  /// No description provided for @startTime.
  ///
  /// In ro, this message translates to:
  /// **'Ora inceput'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In ro, this message translates to:
  /// **'Ora sfarsit'**
  String get endTime;

  /// No description provided for @breakTime.
  ///
  /// In ro, this message translates to:
  /// **'Pauza'**
  String get breakTime;

  /// No description provided for @noBreak.
  ///
  /// In ro, this message translates to:
  /// **'Fara pauza'**
  String get noBreak;

  /// No description provided for @nMinutes.
  ///
  /// In ro, this message translates to:
  /// **'{count} min'**
  String nMinutes(int count);

  /// No description provided for @totalHoursWorked.
  ///
  /// In ro, this message translates to:
  /// **'Total ore lucrate'**
  String get totalHoursWorked;

  /// No description provided for @savePontaj.
  ///
  /// In ro, this message translates to:
  /// **'Salveaza pontaj'**
  String get savePontaj;

  /// No description provided for @pontajSaved.
  ///
  /// In ro, this message translates to:
  /// **'Pontaj salvat'**
  String get pontajSaved;

  /// No description provided for @pontajDeleted.
  ///
  /// In ro, this message translates to:
  /// **'Pontaj sters'**
  String get pontajDeleted;

  /// No description provided for @workedTimeMustBePositive.
  ///
  /// In ro, this message translates to:
  /// **'Timpul lucrat trebuie sa fie pozitiv'**
  String get workedTimeMustBePositive;

  /// No description provided for @existingPontajWarning.
  ///
  /// In ro, this message translates to:
  /// **'Ai deja un pontaj pentru ziua selectata!'**
  String get existingPontajWarning;

  /// No description provided for @delete.
  ///
  /// In ro, this message translates to:
  /// **'Sterge'**
  String get delete;

  /// No description provided for @otherDay.
  ///
  /// In ro, this message translates to:
  /// **'Alta zi'**
  String get otherDay;

  /// No description provided for @total.
  ///
  /// In ro, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @pontajAdmin.
  ///
  /// In ro, this message translates to:
  /// **'Pontaje - Administrator'**
  String get pontajAdmin;

  /// No description provided for @dashboard.
  ///
  /// In ro, this message translates to:
  /// **'Tablou de Bord'**
  String get dashboard;

  /// No description provided for @users.
  ///
  /// In ro, this message translates to:
  /// **'Utilizatori'**
  String get users;

  /// No description provided for @table.
  ///
  /// In ro, this message translates to:
  /// **'Tabel'**
  String get table;

  /// No description provided for @salaries.
  ///
  /// In ro, this message translates to:
  /// **'Salarii'**
  String get salaries;

  /// No description provided for @noPontaj.
  ///
  /// In ro, this message translates to:
  /// **'Niciun pontaj'**
  String get noPontaj;

  /// No description provided for @couldNotLoadData.
  ///
  /// In ro, this message translates to:
  /// **'Nu s-au putut incarca datele'**
  String get couldNotLoadData;

  /// No description provided for @nDays.
  ///
  /// In ro, this message translates to:
  /// **'{count} zile'**
  String nDays(int count);

  /// No description provided for @nDaysRegistered.
  ///
  /// In ro, this message translates to:
  /// **'{count} zile inregistrate'**
  String nDaysRegistered(int count);

  /// No description provided for @nDaysWorked.
  ///
  /// In ro, this message translates to:
  /// **'{count} zile lucrate'**
  String nDaysWorked(int count);

  /// No description provided for @usersTable.
  ///
  /// In ro, this message translates to:
  /// **'Tabel Utilizatori'**
  String get usersTable;

  /// No description provided for @user.
  ///
  /// In ro, this message translates to:
  /// **'Utilizator'**
  String get user;

  /// No description provided for @days.
  ///
  /// In ro, this message translates to:
  /// **'Zile'**
  String get days;

  /// No description provided for @totalHours.
  ///
  /// In ro, this message translates to:
  /// **'Total ore'**
  String get totalHours;

  /// No description provided for @totalDays.
  ///
  /// In ro, this message translates to:
  /// **'Total Zile'**
  String get totalDays;

  /// No description provided for @averagePerDay.
  ///
  /// In ro, this message translates to:
  /// **'Medie/Zi'**
  String get averagePerDay;

  /// No description provided for @pontajUser.
  ///
  /// In ro, this message translates to:
  /// **'Pontaje - {name}'**
  String pontajUser(String name);

  /// No description provided for @noPontajForUser.
  ///
  /// In ro, this message translates to:
  /// **'Nu exista pontaje pentru acest utilizator.'**
  String get noPontajForUser;

  /// No description provided for @date.
  ///
  /// In ro, this message translates to:
  /// **'Data'**
  String get date;

  /// No description provided for @interval.
  ///
  /// In ro, this message translates to:
  /// **'Interval'**
  String get interval;

  /// No description provided for @hoursPerUser.
  ///
  /// In ro, this message translates to:
  /// **'Ore pe utilizator'**
  String get hoursPerUser;

  /// No description provided for @recentActivity.
  ///
  /// In ro, this message translates to:
  /// **'Activitate recenta'**
  String get recentActivity;

  /// No description provided for @noActivity.
  ///
  /// In ro, this message translates to:
  /// **'Nicio activitate'**
  String get noActivity;

  /// No description provided for @salarySummary.
  ///
  /// In ro, this message translates to:
  /// **'Sumar Salarii'**
  String get salarySummary;

  /// No description provided for @calculationBasedOnPontaj.
  ///
  /// In ro, this message translates to:
  /// **'Calcul pe baza pontajelor inregistrate'**
  String get calculationBasedOnPontaj;

  /// No description provided for @noPontajForSalary.
  ///
  /// In ro, this message translates to:
  /// **'Niciun pontaj pentru calcul salarii'**
  String get noPontajForSalary;

  /// No description provided for @hoursDecimal.
  ///
  /// In ro, this message translates to:
  /// **'Ore (decimal)'**
  String get hoursDecimal;

  /// No description provided for @appearance.
  ///
  /// In ro, this message translates to:
  /// **'Aspect'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In ro, this message translates to:
  /// **'Mod intunecat'**
  String get darkMode;

  /// No description provided for @light.
  ///
  /// In ro, this message translates to:
  /// **'Luminos'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In ro, this message translates to:
  /// **'Intunecat'**
  String get dark;

  /// No description provided for @auto.
  ///
  /// In ro, this message translates to:
  /// **'Automat'**
  String get auto;

  /// No description provided for @accentColor.
  ///
  /// In ro, this message translates to:
  /// **'Culoare accent'**
  String get accentColor;

  /// No description provided for @current.
  ///
  /// In ro, this message translates to:
  /// **'Curent'**
  String get current;

  /// No description provided for @information.
  ///
  /// In ro, this message translates to:
  /// **'Informatii'**
  String get information;

  /// No description provided for @version.
  ///
  /// In ro, this message translates to:
  /// **'Versiune'**
  String get version;

  /// No description provided for @developedBy.
  ///
  /// In ro, this message translates to:
  /// **'Dezvoltat de'**
  String get developedBy;

  /// No description provided for @status.
  ///
  /// In ro, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @allSystemsOperational.
  ///
  /// In ro, this message translates to:
  /// **'Toate sistemele functionale'**
  String get allSystemsOperational;

  /// No description provided for @language.
  ///
  /// In ro, this message translates to:
  /// **'Limba'**
  String get language;

  /// No description provided for @romanian.
  ///
  /// In ro, this message translates to:
  /// **'Romana'**
  String get romanian;

  /// No description provided for @english.
  ///
  /// In ro, this message translates to:
  /// **'Engleza'**
  String get english;

  /// No description provided for @italian.
  ///
  /// In ro, this message translates to:
  /// **'Italiana'**
  String get italian;

  /// No description provided for @unknownRoute.
  ///
  /// In ro, this message translates to:
  /// **'Ruta necunoscuta'**
  String get unknownRoute;

  /// No description provided for @routeNotDefined.
  ///
  /// In ro, this message translates to:
  /// **'Ruta solicitata nu este definita.'**
  String get routeNotDefined;

  /// No description provided for @backToLogin.
  ///
  /// In ro, this message translates to:
  /// **'Inapoi la Login'**
  String get backToLogin;

  /// No description provided for @invalidFormat.
  ///
  /// In ro, this message translates to:
  /// **'Format invalid'**
  String get invalidFormat;

  /// No description provided for @registrationError.
  ///
  /// In ro, this message translates to:
  /// **'Eroare la inregistrare'**
  String get registrationError;

  /// No description provided for @ok.
  ///
  /// In ro, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @orContinueWith.
  ///
  /// In ro, this message translates to:
  /// **'sau continua cu'**
  String get orContinueWith;

  /// No description provided for @continueWithGoogle.
  ///
  /// In ro, this message translates to:
  /// **'Continua cu Google'**
  String get continueWithGoogle;

  /// No description provided for @account.
  ///
  /// In ro, this message translates to:
  /// **'Cont'**
  String get account;

  /// No description provided for @adminUpgrade.
  ///
  /// In ro, this message translates to:
  /// **'Devino Administrator'**
  String get adminUpgrade;

  /// No description provided for @adminUpgradeDesc.
  ///
  /// In ro, this message translates to:
  /// **'Introdu codul de admin pentru a-ti actualiza contul'**
  String get adminUpgradeDesc;

  /// No description provided for @enterAdminCode.
  ///
  /// In ro, this message translates to:
  /// **'Introdu codul admin'**
  String get enterAdminCode;

  /// No description provided for @adminCodeRequired.
  ///
  /// In ro, this message translates to:
  /// **'Codul admin este obligatoriu'**
  String get adminCodeRequired;

  /// No description provided for @invalidAdminCode.
  ///
  /// In ro, this message translates to:
  /// **'Cod admin invalid'**
  String get invalidAdminCode;

  /// No description provided for @upgradeSuccess.
  ///
  /// In ro, this message translates to:
  /// **'Cont actualizat la administrator cu succes'**
  String get upgradeSuccess;

  /// No description provided for @confirmUpgrade.
  ///
  /// In ro, this message translates to:
  /// **'Confirma Actualizarea'**
  String get confirmUpgrade;

  /// No description provided for @confirmUpgradeMessage.
  ///
  /// In ro, this message translates to:
  /// **'Esti sigur ca vrei sa devii administrator?'**
  String get confirmUpgradeMessage;

  /// No description provided for @youAreAdmin.
  ///
  /// In ro, this message translates to:
  /// **'Esti administrator'**
  String get youAreAdmin;

  /// No description provided for @upgrade.
  ///
  /// In ro, this message translates to:
  /// **'Actualizeaza'**
  String get upgrade;

  /// No description provided for @cancel.
  ///
  /// In ro, this message translates to:
  /// **'Anuleaza'**
  String get cancel;

  /// No description provided for @pontaj.
  ///
  /// In ro, this message translates to:
  /// **'Pontaj'**
  String get pontaj;

  /// No description provided for @myEntries.
  ///
  /// In ro, this message translates to:
  /// **'Inregistrarile mele'**
  String get myEntries;

  /// No description provided for @logoutConfirmation.
  ///
  /// In ro, this message translates to:
  /// **'Confirma deconectarea'**
  String get logoutConfirmation;

  /// No description provided for @logoutConfirmationMessage.
  ///
  /// In ro, this message translates to:
  /// **'Esti sigur ca vrei sa te deconectezi?'**
  String get logoutConfirmationMessage;

  /// No description provided for @entriesTab.
  ///
  /// In ro, this message translates to:
  /// **'Inregistrari'**
  String get entriesTab;

  /// No description provided for @addEntry.
  ///
  /// In ro, this message translates to:
  /// **'Adauga pontaj'**
  String get addEntry;

  /// No description provided for @timeOverlapError.
  ///
  /// In ro, this message translates to:
  /// **'Acest interval de timp se suprapune cu o inregistrare existenta'**
  String get timeOverlapError;

  /// No description provided for @requireCustomInterval.
  ///
  /// In ro, this message translates to:
  /// **'Foloseste intervalul personalizat cand adaugi mai multe inregistrari pentru aceeasi zi'**
  String get requireCustomInterval;

  /// No description provided for @thisWeek.
  ///
  /// In ro, this message translates to:
  /// **'Saptamana aceasta'**
  String get thisWeek;

  /// No description provided for @lastWeek.
  ///
  /// In ro, this message translates to:
  /// **'Saptamana trecuta'**
  String get lastWeek;

  /// No description provided for @thisMonth.
  ///
  /// In ro, this message translates to:
  /// **'Luna aceasta'**
  String get thisMonth;

  /// No description provided for @topLocation.
  ///
  /// In ro, this message translates to:
  /// **'Locatie frecventa'**
  String get topLocation;

  /// No description provided for @weeklyHours.
  ///
  /// In ro, this message translates to:
  /// **'Ore saptamanale'**
  String get weeklyHours;

  /// No description provided for @dailyTarget.
  ///
  /// In ro, this message translates to:
  /// **'Tinta zilnica'**
  String get dailyTarget;

  /// No description provided for @goodMorning.
  ///
  /// In ro, this message translates to:
  /// **'Buna dimineata'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In ro, this message translates to:
  /// **'Buna ziua'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In ro, this message translates to:
  /// **'Buna seara'**
  String get goodEvening;

  /// No description provided for @hourlyRate.
  ///
  /// In ro, this message translates to:
  /// **'Tarif pe ora'**
  String get hourlyRate;

  /// No description provided for @editRate.
  ///
  /// In ro, this message translates to:
  /// **'Editeaza tarif'**
  String get editRate;

  /// No description provided for @saveChanges.
  ///
  /// In ro, this message translates to:
  /// **'Salveaza modificarile'**
  String get saveChanges;

  /// No description provided for @salarySettings.
  ///
  /// In ro, this message translates to:
  /// **'Setari salariu'**
  String get salarySettings;

  /// No description provided for @selectSalaryType.
  ///
  /// In ro, this message translates to:
  /// **'Selecteaza tipul de salariu'**
  String get selectSalaryType;

  /// No description provided for @selectCurrency.
  ///
  /// In ro, this message translates to:
  /// **'Selecteaza moneda'**
  String get selectCurrency;

  /// No description provided for @invoices.
  ///
  /// In ro, this message translates to:
  /// **'Facturi'**
  String get invoices;

  /// No description provided for @createInvoice.
  ///
  /// In ro, this message translates to:
  /// **'Creeaza factura'**
  String get createInvoice;

  /// No description provided for @period.
  ///
  /// In ro, this message translates to:
  /// **'Perioada'**
  String get period;

  /// No description provided for @dueDate.
  ///
  /// In ro, this message translates to:
  /// **'Data scadenta'**
  String get dueDate;

  /// No description provided for @notSet.
  ///
  /// In ro, this message translates to:
  /// **'Nesetat'**
  String get notSet;

  /// No description provided for @change.
  ///
  /// In ro, this message translates to:
  /// **'Schimba'**
  String get change;

  /// No description provided for @summary.
  ///
  /// In ro, this message translates to:
  /// **'Sumar'**
  String get summary;

  /// No description provided for @entries.
  ///
  /// In ro, this message translates to:
  /// **'Inregistrari'**
  String get entries;

  /// No description provided for @totalAmount.
  ///
  /// In ro, this message translates to:
  /// **'Suma totala'**
  String get totalAmount;

  /// No description provided for @notes.
  ///
  /// In ro, this message translates to:
  /// **'Note'**
  String get notes;

  /// No description provided for @addNotesToInvoice.
  ///
  /// In ro, this message translates to:
  /// **'Adauga note la factura...'**
  String get addNotesToInvoice;

  /// No description provided for @noEntriesForPeriod.
  ///
  /// In ro, this message translates to:
  /// **'Nicio inregistrare gasita pentru perioada selectata'**
  String get noEntriesForPeriod;

  /// No description provided for @week.
  ///
  /// In ro, this message translates to:
  /// **'Saptamana'**
  String get week;

  /// No description provided for @year.
  ///
  /// In ro, this message translates to:
  /// **'An'**
  String get year;

  /// No description provided for @custom.
  ///
  /// In ro, this message translates to:
  /// **'Personalizat'**
  String get custom;

  /// No description provided for @selectPeriod.
  ///
  /// In ro, this message translates to:
  /// **'Selecteaza perioada'**
  String get selectPeriod;

  /// No description provided for @selectDateRange.
  ///
  /// In ro, this message translates to:
  /// **'Selecteaza intervalul de date'**
  String get selectDateRange;

  /// No description provided for @timeOverlapDetected.
  ///
  /// In ro, this message translates to:
  /// **'Suprapunere de timp detectata'**
  String get timeOverlapDetected;

  /// No description provided for @yourNewEntry.
  ///
  /// In ro, this message translates to:
  /// **'Noua ta inregistrare'**
  String get yourNewEntry;

  /// No description provided for @conflictsWithEntry.
  ///
  /// In ro, this message translates to:
  /// **'Se suprapune cu inregistrarea existenta'**
  String get conflictsWithEntry;

  /// No description provided for @adjustTimesSuggestion.
  ///
  /// In ro, this message translates to:
  /// **'Ajusteaza ora de inceput sau sfarsit pentru a evita suprapunerea cu inregistrarile existente.'**
  String get adjustTimesSuggestion;

  /// No description provided for @editTimes.
  ///
  /// In ro, this message translates to:
  /// **'Editeaza orele'**
  String get editTimes;

  /// No description provided for @thisPeriod.
  ///
  /// In ro, this message translates to:
  /// **'Aceasta perioada'**
  String get thisPeriod;

  /// No description provided for @lastPeriod.
  ///
  /// In ro, this message translates to:
  /// **'Perioada trecuta'**
  String get lastPeriod;

  /// No description provided for @periodComparison.
  ///
  /// In ro, this message translates to:
  /// **'Comparatie perioade'**
  String get periodComparison;

  /// No description provided for @teamTrend.
  ///
  /// In ro, this message translates to:
  /// **'Tendinta echipa'**
  String get teamTrend;

  /// No description provided for @hoursByLocation.
  ///
  /// In ro, this message translates to:
  /// **'Ore pe locatie'**
  String get hoursByLocation;

  /// No description provided for @activeUsers.
  ///
  /// In ro, this message translates to:
  /// **'Utilizatori activi'**
  String get activeUsers;

  /// No description provided for @topUser.
  ///
  /// In ro, this message translates to:
  /// **'Utilizator top'**
  String get topUser;

  /// No description provided for @daysWorked.
  ///
  /// In ro, this message translates to:
  /// **'Zile lucrate'**
  String get daysWorked;

  /// No description provided for @vsLastPeriod.
  ///
  /// In ro, this message translates to:
  /// **'vs Perioada trecuta'**
  String get vsLastPeriod;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it', 'ro'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
    case 'ro':
      return AppLocalizationsRo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
