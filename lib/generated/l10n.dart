// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `to`
  String get to {
    return Intl.message(
      'to',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `How do you want to use HostMI ?`
  String get whyDoYouUseHostmi {
    return Intl.message(
      'How do you want to use HostMI ?',
      name: 'whyDoYouUseHostmi',
      desc: '',
      args: [],
    );
  }

  /// `Look for rental house(s) ?`
  String get lookingForRental {
    return Intl.message(
      'Look for rental house(s) ?',
      name: 'lookingForRental',
      desc: '',
      args: [],
    );
  }

  /// `Publish rental houses`
  String get wantToPublish {
    return Intl.message(
      'Publish rental houses',
      name: 'wantToPublish',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get login {
    return Intl.message(
      'Sign in',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `password`
  String get password {
    return Intl.message(
      'password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `or use`
  String get orUse {
    return Intl.message(
      'or use',
      name: 'orUse',
      desc: '',
      args: [],
    );
  }

  /// `or sign in using`
  String get orLoginUsing {
    return Intl.message(
      'or sign in using',
      name: 'orLoginUsing',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phoneNumber {
    return Intl.message(
      'Phone number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Do not have an account ?`
  String get doNotHaveAccount {
    return Intl.message(
      'Do not have an account ?',
      name: 'doNotHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account ?`
  String get haveAccount {
    return Intl.message(
      'Already have an account ?',
      name: 'haveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please type your phone number`
  String get typePhoneNumber {
    return Intl.message(
      'Please type your phone number',
      name: 'typePhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Create an account`
  String get createAccount {
    return Intl.message(
      'Create an account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Map`
  String get mapTabText {
    return Intl.message(
      'Map',
      name: 'mapTabText',
      desc: '',
      args: [],
    );
  }

  /// `List`
  String get listTabText {
    return Intl.message(
      'List',
      name: 'listTabText',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get messageTabText {
    return Intl.message(
      'Messages',
      name: 'messageTabText',
      desc: '',
      args: [],
    );
  }

  /// `Publish`
  String get publishTabText {
    return Intl.message(
      'Publish',
      name: 'publishTabText',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menuTabText {
    return Intl.message(
      'Menu',
      name: 'menuTabText',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: 'Greeting for map.',
      args: [],
    );
  }

  /// `Find your dream house here`
  String get welcomeSlogan {
    return Intl.message(
      'Find your dream house here',
      name: 'welcomeSlogan',
      desc: '',
      args: [],
    );
  }

  /// `Search a city`
  String get searchCityPlaceholder {
    return Intl.message(
      'Search a city',
      name: 'searchCityPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Type a city name`
  String get searchCityErrorText {
    return Intl.message(
      'Type a city name',
      name: 'searchCityErrorText',
      desc: '',
      args: [],
    );
  }

  /// `Bds`
  String get bedsAbbreviation {
    return Intl.message(
      'Bds',
      name: 'bedsAbbreviation',
      desc: '',
      args: [],
    );
  }

  /// `bths`
  String get bathRoomsAbbreviation {
    return Intl.message(
      'bths',
      name: 'bathRoomsAbbreviation',
      desc: '',
      args: [],
    );
  }

  /// `Sector`
  String get sector {
    return Intl.message(
      'Sector',
      name: 'sector',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Virtual tour`
  String get virtualTour {
    return Intl.message(
      'Virtual tour',
      name: 'virtualTour',
      desc: '',
      args: [],
    );
  }

  /// `Save at least\n2000 Francs CFA here`
  String get listMotivationalWord {
    return Intl.message(
      'Save at least\n2000 Francs CFA here',
      name: 'listMotivationalWord',
      desc: '',
      args: [],
    );
  }

  /// `Sort`
  String get sort {
    return Intl.message(
      'Sort',
      name: 'sort',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `You received a new message`
  String get newMessage {
    return Intl.message(
      'You received a new message',
      name: 'newMessage',
      desc: '',
      args: [],
    );
  }

  /// `Add a house`
  String get addHouse {
    return Intl.message(
      'Add a house',
      name: 'addHouse',
      desc: '',
      args: [],
    );
  }

  /// `Manage`
  String get manage {
    return Intl.message(
      'Manage',
      name: 'manage',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Published houses`
  String get publishedProperties {
    return Intl.message(
      'Published houses',
      name: 'publishedProperties',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Base information`
  String get baseInformation {
    return Intl.message(
      'Base information',
      name: 'baseInformation',
      desc: '',
      args: [],
    );
  }

  /// `House type`
  String get propertyType {
    return Intl.message(
      'House type',
      name: 'propertyType',
      desc: '',
      args: [],
    );
  }

  /// `Single house`
  String get singleHouse {
    return Intl.message(
      'Single house',
      name: 'singleHouse',
      desc: '',
      args: [],
    );
  }

  /// `Common house`
  String get commonHouse {
    return Intl.message(
      'Common house',
      name: 'commonHouse',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Number of beds`
  String get numberOfBedRooms {
    return Intl.message(
      'Number of beds',
      name: 'numberOfBedRooms',
      desc: '',
      args: [],
    );
  }

  /// `Number of bathrooms`
  String get numberOfBathrooms {
    return Intl.message(
      'Number of bathrooms',
      name: 'numberOfBathrooms',
      desc: '',
      args: [],
    );
  }

  /// `Town`
  String get town {
    return Intl.message(
      'Town',
      name: 'town',
      desc: '',
      args: [],
    );
  }

  /// `Quarter`
  String get quarter {
    return Intl.message(
      'Quarter',
      name: 'quarter',
      desc: '',
      args: [],
    );
  }

  /// `Tenants type`
  String get tenantType {
    return Intl.message(
      'Tenants type',
      name: 'tenantType',
      desc: '',
      args: [],
    );
  }

  /// `Job`
  String get occupation {
    return Intl.message(
      'Job',
      name: 'occupation',
      desc: '',
      args: [],
    );
  }

  /// `Any`
  String get any {
    return Intl.message(
      'Any',
      name: 'any',
      desc: '',
      args: [],
    );
  }

  /// `Officials`
  String get officials {
    return Intl.message(
      'Officials',
      name: 'officials',
      desc: '',
      args: [],
    );
  }

  /// `Interns`
  String get interns {
    return Intl.message(
      'Interns',
      name: 'interns',
      desc: '',
      args: [],
    );
  }

  /// `Students`
  String get students {
    return Intl.message(
      'Students',
      name: 'students',
      desc: '',
      args: [],
    );
  }

  /// `Business owners`
  String get businessOwners {
    return Intl.message(
      'Business owners',
      name: 'businessOwners',
      desc: '',
      args: [],
    );
  }

  /// `Sex`
  String get sex {
    return Intl.message(
      'Sex',
      name: 'sex',
      desc: '',
      args: [],
    );
  }

  /// `Men`
  String get male {
    return Intl.message(
      'Men',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Women`
  String get female {
    return Intl.message(
      'Women',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Marital status`
  String get maritalStatus {
    return Intl.message(
      'Marital status',
      name: 'maritalStatus',
      desc: '',
      args: [],
    );
  }

  /// `Single`
  String get single {
    return Intl.message(
      'Single',
      name: 'single',
      desc: '',
      args: [],
    );
  }

  /// `Couples`
  String get couple {
    return Intl.message(
      'Couples',
      name: 'couple',
      desc: '',
      args: [],
    );
  }

  /// `Add pictures now`
  String get addPicturesNow {
    return Intl.message(
      'Add pictures now',
      name: 'addPicturesNow',
      desc: '',
      args: [],
    );
  }

  /// `House pictures`
  String get housePictures {
    return Intl.message(
      'House pictures',
      name: 'housePictures',
      desc: '',
      args: [],
    );
  }

  /// `Face picture`
  String get facePicture {
    return Intl.message(
      'Face picture',
      name: 'facePicture',
      desc: '',
      args: [],
    );
  }

  /// `Main room`
  String get mainRoom {
    return Intl.message(
      'Main room',
      name: 'mainRoom',
      desc: '',
      args: [],
    );
  }

  /// `Bedroom`
  String get bedroom {
    return Intl.message(
      'Bedroom',
      name: 'bedroom',
      desc: '',
      args: [],
    );
  }

  /// `Bathroom`
  String get bathRoom {
    return Intl.message(
      'Bathroom',
      name: 'bathRoom',
      desc: '',
      args: [],
    );
  }

  /// `Add a new room`
  String get addNewRoom {
    return Intl.message(
      'Add a new room',
      name: 'addNewRoom',
      desc: '',
      args: [],
    );
  }

  /// `Kitchen`
  String get kitchen {
    return Intl.message(
      'Kitchen',
      name: 'kitchen',
      desc: '',
      args: [],
    );
  }

  /// `Garden`
  String get garden {
    return Intl.message(
      'Garden',
      name: 'garden',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Define more characteristics`
  String get defineMoreChars {
    return Intl.message(
      'Define more characteristics',
      name: 'defineMoreChars',
      desc: '',
      args: [],
    );
  }

  /// `Characteristics`
  String get features {
    return Intl.message(
      'Characteristics',
      name: 'features',
      desc: '',
      args: [],
    );
  }

  /// `House features`
  String get houseFeatures {
    return Intl.message(
      'House features',
      name: 'houseFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Water`
  String get water {
    return Intl.message(
      'Water',
      name: 'water',
      desc: '',
      args: [],
    );
  }

  /// `Current`
  String get power {
    return Intl.message(
      'Current',
      name: 'power',
      desc: '',
      args: [],
    );
  }

  /// `Store`
  String get store {
    return Intl.message(
      'Store',
      name: 'store',
      desc: '',
      args: [],
    );
  }

  /// `Internal kitchen`
  String get internalKitchen {
    return Intl.message(
      'Internal kitchen',
      name: 'internalKitchen',
      desc: '',
      args: [],
    );
  }

  /// `Internal bathroom`
  String get internalBathroom {
    return Intl.message(
      'Internal bathroom',
      name: 'internalBathroom',
      desc: '',
      args: [],
    );
  }

  /// `Pool`
  String get pool {
    return Intl.message(
      'Pool',
      name: 'pool',
      desc: '',
      args: [],
    );
  }

  /// `Parking`
  String get parking {
    return Intl.message(
      'Parking',
      name: 'parking',
      desc: '',
      args: [],
    );
  }

  /// `Bar`
  String get bar {
    return Intl.message(
      'Bar',
      name: 'bar',
      desc: '',
      args: [],
    );
  }

  /// `Paved`
  String get paved {
    return Intl.message(
      'Paved',
      name: 'paved',
      desc: '',
      args: [],
    );
  }

  /// `Trees`
  String get trees {
    return Intl.message(
      'Trees',
      name: 'trees',
      desc: '',
      args: [],
    );
  }

  /// `Flowers`
  String get flowers {
    return Intl.message(
      'Flowers',
      name: 'flowers',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Describe the house with more details`
  String get houseDescHint {
    return Intl.message(
      'Describe the house with more details',
      name: 'houseDescHint',
      desc: '',
      args: [],
    );
  }

  /// `Access conditions`
  String get accessConditions {
    return Intl.message(
      'Access conditions',
      name: 'accessConditions',
      desc: '',
      args: [],
    );
  }

  /// `What do I have to do to get the house`
  String get accessConditionsHint {
    return Intl.message(
      'What do I have to do to get the house',
      name: 'accessConditionsHint',
      desc: '',
      args: [],
    );
  }

  /// `Nearby places`
  String get nearbyPlaces {
    return Intl.message(
      'Nearby places',
      name: 'nearbyPlaces',
      desc: '',
      args: [],
    );
  }

  /// `Example: School, Restaurant, Hospital,...`
  String get nearbyPlacesHint {
    return Intl.message(
      'Example: School, Restaurant, Hospital,...',
      name: 'nearbyPlacesHint',
      desc: '',
      args: [],
    );
  }

  /// `Publish now`
  String get publishNow {
    return Intl.message(
      'Publish now',
      name: 'publishNow',
      desc: '',
      args: [],
    );
  }

  /// `We are saving your house...`
  String get savingHouse {
    return Intl.message(
      'We are saving your house...',
      name: 'savingHouse',
      desc: '',
      args: [],
    );
  }

  /// `Your house will be published ! Relax. Read a newspaper and wait for your new tenants.`
  String get relaxMessage {
    return Intl.message(
      'Your house will be published ! Relax. Read a newspaper and wait for your new tenants.',
      name: 'relaxMessage',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get next {
    return Intl.message(
      'Continue',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Choose a town`
  String get chooseTown {
    return Intl.message(
      'Choose a town',
      name: 'chooseTown',
      desc: '',
      args: [],
    );
  }

  /// `Available now`
  String get availableNow {
    return Intl.message(
      'Available now',
      name: 'availableNow',
      desc: '',
      args: [],
    );
  }

  /// `More filters`
  String get moreFilter {
    return Intl.message(
      'More filters',
      name: 'moreFilter',
      desc: '',
      args: [],
    );
  }

  /// `To publish a property,\nyou must create a page`
  String get mustCreatePage {
    return Intl.message(
      'To publish a property,\nyou must create a page',
      name: 'mustCreatePage',
      desc: '',
      args: [],
    );
  }

  /// `Create now`
  String get createNow {
    return Intl.message(
      'Create now',
      name: 'createNow',
      desc: '',
      args: [],
    );
  }

  /// `Create a page`
  String get createPage {
    return Intl.message(
      'Create a page',
      name: 'createPage',
      desc: '',
      args: [],
    );
  }

  /// `Page name`
  String get pageName {
    return Intl.message(
      'Page name',
      name: 'pageName',
      desc: '',
      args: [],
    );
  }

  /// `Creating the page`
  String get creatingPage {
    return Intl.message(
      'Creating the page',
      name: 'creatingPage',
      desc: '',
      args: [],
    );
  }

  /// `Create your page`
  String get createYourPage {
    return Intl.message(
      'Create your page',
      name: 'createYourPage',
      desc: '',
      args: [],
    );
  }

  /// `Type your company name.`
  String get pageNameHint {
    return Intl.message(
      'Type your company name.',
      name: 'pageNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Required fields`
  String get requiredFieldsWithStar {
    return Intl.message(
      'Required fields',
      name: 'requiredFieldsWithStar',
      desc: '',
      args: [],
    );
  }

  /// `Covered towns`
  String get coveredTowns {
    return Intl.message(
      'Covered towns',
      name: 'coveredTowns',
      desc: '',
      args: [],
    );
  }

  /// `Towns in which you have properties`
  String get coveredTownsHint {
    return Intl.message(
      'Towns in which you have properties',
      name: 'coveredTownsHint',
      desc: '',
      args: [],
    );
  }

  /// `optional`
  String get optional {
    return Intl.message(
      'optional',
      name: 'optional',
      desc: '',
      args: [],
    );
  }

  /// `Briefly describe your company...`
  String get pageDescHint {
    return Intl.message(
      'Briefly describe your company...',
      name: 'pageDescHint',
      desc: '',
      args: [],
    );
  }

  /// `The legal references of your company`
  String get ifuHint {
    return Intl.message(
      'The legal references of your company',
      name: 'ifuHint',
      desc: '',
      args: [],
    );
  }

  /// `Step`
  String get step {
    return Intl.message(
      'Step',
      name: 'step',
      desc: '',
      args: [],
    );
  }

  /// `Discuss with`
  String get discussWith {
    return Intl.message(
      'Discuss with',
      name: 'discussWith',
      desc: '',
      args: [],
    );
  }

  /// `Type your message...`
  String get typeMessage {
    return Intl.message(
      'Type your message...',
      name: 'typeMessage',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
