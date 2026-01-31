// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pontaj PRO';

  @override
  String get appSubtitle => '10,000x Better Edition';

  @override
  String get login => 'Login';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle => 'Manage timesheets quickly and intuitively';

  @override
  String get loginButton => 'Sign in';

  @override
  String get createAccount => 'Create a new account';

  @override
  String get register => 'Register';

  @override
  String get createAccountButton => 'Create account';

  @override
  String get processing => 'Processing...';

  @override
  String get accountCreated => 'Account created. Please sign in.';

  @override
  String get email => 'Email';

  @override
  String get displayName => 'Display name';

  @override
  String get optional => '(optional)';

  @override
  String get adminCode => 'Admin code';

  @override
  String get adminCodeOptional => 'Have an admin code?';

  @override
  String get adminCodeHelper => 'Enter the secret code to register as admin';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get required => 'Required';

  @override
  String minCharacters(int count) {
    return 'Minimum $count characters';
  }

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get administrator => 'Administrator';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String hello(String name) {
    return 'Hello, $name';
  }

  @override
  String get chooseAction => 'Choose the desired action to continue';

  @override
  String pontajAs(String name) {
    return 'Timesheet as $name';
  }

  @override
  String get addPontajForToday => 'Add timesheet for today';

  @override
  String get viewAllEntries => 'View all entries';

  @override
  String get manageAndAnalyze => 'Manage and analyze all entries';

  @override
  String get manageSalaries => 'Manage salaries';

  @override
  String get configureAndCalculate => 'Configure and calculate salaries';

  @override
  String get addPontaj => 'Add timesheet';

  @override
  String get location => 'Location';

  @override
  String get locationHint => 'E.g.: House A, Factory';

  @override
  String get enterLocation => 'Enter location';

  @override
  String get quickHours => 'Quick hours worked';

  @override
  String nHours(int count) {
    return '$count hours';
  }

  @override
  String get useCustomInterval => 'Use custom interval';

  @override
  String get customInterval => 'Custom interval';

  @override
  String get startTime => 'Start time';

  @override
  String get endTime => 'End time';

  @override
  String get breakTime => 'Break';

  @override
  String get noBreak => 'No break';

  @override
  String nMinutes(int count) {
    return '$count min';
  }

  @override
  String get totalHoursWorked => 'Total hours worked';

  @override
  String get savePontaj => 'Save timesheet';

  @override
  String get pontajSaved => 'Timesheet saved';

  @override
  String get pontajDeleted => 'Timesheet deleted';

  @override
  String get workedTimeMustBePositive => 'Worked time must be positive';

  @override
  String get existingPontajWarning =>
      'You already have a timesheet for the selected day!';

  @override
  String get delete => 'Delete';

  @override
  String get otherDay => 'Other day';

  @override
  String get total => 'Total';

  @override
  String get pontajAdmin => 'Timesheets - Administrator';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get users => 'Users';

  @override
  String get table => 'Table';

  @override
  String get salaries => 'Salaries';

  @override
  String get noPontaj => 'No timesheets';

  @override
  String get couldNotLoadData => 'Could not load data';

  @override
  String nDays(int count) {
    return '$count days';
  }

  @override
  String nDaysRegistered(int count) {
    return '$count days registered';
  }

  @override
  String nDaysWorked(int count) {
    return '$count days worked';
  }

  @override
  String get usersTable => 'Users Table';

  @override
  String get user => 'User';

  @override
  String get days => 'Days';

  @override
  String get totalHours => 'Total hours';

  @override
  String get totalDays => 'Total Days';

  @override
  String get averagePerDay => 'Avg/Day';

  @override
  String pontajUser(String name) {
    return 'Timesheets - $name';
  }

  @override
  String get noPontajForUser => 'No timesheets for this user.';

  @override
  String get date => 'Date';

  @override
  String get interval => 'Interval';

  @override
  String get hoursPerUser => 'Hours per user';

  @override
  String get recentActivity => 'Recent activity';

  @override
  String get noActivity => 'No activity';

  @override
  String get salarySummary => 'Salary Summary';

  @override
  String get calculationBasedOnPontaj =>
      'Calculation based on registered entries';

  @override
  String get noPontajForSalary => 'No entries for salary calculation';

  @override
  String get hoursDecimal => 'Hours (decimal)';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get auto => 'Auto';

  @override
  String get accentColor => 'Accent color';

  @override
  String get current => 'Current';

  @override
  String get information => 'Information';

  @override
  String get version => 'Version';

  @override
  String get developedBy => 'Developed by';

  @override
  String get status => 'Status';

  @override
  String get allSystemsOperational => 'All systems operational';

  @override
  String get language => 'Language';

  @override
  String get romanian => 'Romanian';

  @override
  String get english => 'English';

  @override
  String get italian => 'Italian';

  @override
  String get unknownRoute => 'Unknown route';

  @override
  String get routeNotDefined => 'The requested route is not defined.';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get invalidFormat => 'Invalid format';

  @override
  String get registrationError => 'Registration Error';

  @override
  String get ok => 'OK';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get account => 'Account';

  @override
  String get adminUpgrade => 'Become Administrator';

  @override
  String get adminUpgradeDesc => 'Enter the admin code to upgrade your account';

  @override
  String get enterAdminCode => 'Enter admin code';

  @override
  String get adminCodeRequired => 'Admin code is required';

  @override
  String get invalidAdminCode => 'Invalid admin code';

  @override
  String get upgradeSuccess => 'Successfully upgraded to administrator';

  @override
  String get confirmUpgrade => 'Confirm Upgrade';

  @override
  String get confirmUpgradeMessage =>
      'Are you sure you want to upgrade to administrator?';

  @override
  String get youAreAdmin => 'You are an administrator';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get cancel => 'Cancel';

  @override
  String get pontaj => 'Timesheet';

  @override
  String get myEntries => 'My Entries';

  @override
  String get logoutConfirmation => 'Confirm Logout';

  @override
  String get logoutConfirmationMessage => 'Are you sure you want to log out?';

  @override
  String get entriesTab => 'Entries';

  @override
  String get addEntry => 'Add Entry';

  @override
  String get timeOverlapError =>
      'This time range overlaps with an existing entry';

  @override
  String get requireCustomInterval =>
      'Please use custom time interval when adding multiple entries for the same day';
}
