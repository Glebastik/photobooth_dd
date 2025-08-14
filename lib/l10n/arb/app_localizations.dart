import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_te.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
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
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hu'),
    Locale('id'),
    Locale('ne'),
    Locale('te'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
  ];

  /// Heading shown on the landing page.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the I∕O Photo Booth'**
  String get landingPageHeading;

  /// Subheading shown on the landing page.
  ///
  /// In en, this message translates to:
  /// **'Take a photo and share it with the community!'**
  String get landingPageSubheading;

  /// Button text shown on the landing page which navigates to the photo booth.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get landingPageTakePhotoButtonText;

  /// Text shown on the footer which mentions technologies used to build the app.
  ///
  /// In en, this message translates to:
  /// **'Made with '**
  String get footerMadeWithText;

  /// Text on the link shown on the footer which navigates to the Flutter page
  ///
  /// In en, this message translates to:
  /// **'Flutter'**
  String get footerMadeWithFlutterLinkText;

  /// Text on the link shown on the footer which navigates to the Firebase page
  ///
  /// In en, this message translates to:
  /// **'Firebase'**
  String get footerMadeWithFirebaseLinkText;

  /// Text on the link shown on the footer which navigates to the Google I∕O page.
  ///
  /// In en, this message translates to:
  /// **'Google I∕O'**
  String get footerGoogleIOLinkText;

  /// Text on the link shown on the footer which navigates to the Codelab page.
  ///
  /// In en, this message translates to:
  /// **'Codelab'**
  String get footerCodelabLinkText;

  /// Text on the link shown on the footer which navigates to the How It's Made page.
  ///
  /// In en, this message translates to:
  /// **'How It\'s Made'**
  String get footerHowItsMadeLinkText;

  /// Text on the link shown on the footer which navigates to the Terms of Service page.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get footerTermsOfServiceLinkText;

  /// Text on the link shown on the footer which navigates to the Privacy Policy page.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get footerPrivacyPolicyLinkText;

  /// Heading shown on the share page.
  ///
  /// In en, this message translates to:
  /// **'Share your photo with the community!'**
  String get sharePageHeading;

  /// Subheading shown on the share page.
  ///
  /// In en, this message translates to:
  /// **'Share your photo with the community!'**
  String get sharePageSubheading;

  /// Heading shown on the share page after successful share.
  ///
  /// In en, this message translates to:
  /// **'Photo Shared!'**
  String get sharePageSuccessHeading;

  /// Subheading shown on the share page after successful share.
  ///
  /// In en, this message translates to:
  /// **'Thanks for using our Flutter web app! Your photo has been published at this unique URL'**
  String get sharePageSuccessSubheading;

  /// First part of the caption shown at the bottom of the share page after successful share.
  ///
  /// In en, this message translates to:
  /// **'Your photo will be available at that URL for 30 days and then automatically deleted. To request early deletion of your photo, please contact '**
  String get sharePageSuccessCaption1;

  /// Second part of the caption shown at the bottom of the share page after successful share.
  ///
  /// In en, this message translates to:
  /// **'flutter-photo-booth@google.com'**
  String get sharePageSuccessCaption2;

  /// Third part of the caption shown at the bottom of the share page after successful share.
  ///
  /// In en, this message translates to:
  /// **' and be sure to include your unique URL in your request.'**
  String get sharePageSuccessCaption3;

  /// Button text shown on the share page which navigates back to the photo booth.
  ///
  /// In en, this message translates to:
  /// **'Take new photo'**
  String get sharePageRetakeButtonText;

  /// Button text shown on the share page which opens a dialog to share the taken photo.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get sharePageShareButtonText;

  /// Button text shown on the share page which downloads the taken photo.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get sharePageDownloadButtonText;

  /// Text that is put into the social media share URL link.
  ///
  /// In en, this message translates to:
  /// **'Just took a selfie at the #IOPhotoBooth. See you at #GoogleIO!'**
  String get socialMediaShareLinkText;

  /// Text shown when user denies camera permission
  ///
  /// In en, this message translates to:
  /// **'You have denied camera permissions. Please grant access in order to use app.'**
  String get previewPageCameraNotAllowedText;

  /// First part of the text shown at the bottom of the share page that clarifies how photos are stored on the backend when shared on social medias
  ///
  /// In en, this message translates to:
  /// **'If you choose to share your photo on social media, it will be available at a unique URL for 30 days and then automatically deleted. Photos that are not shared, are not stored. To request early deletion of your photo, please contact '**
  String get sharePageSocialMediaShareClarification1;

  /// Second part of the text shown at the bottom of the share page that clarifies how photos are stored on the backend when shared on social medias
  ///
  /// In en, this message translates to:
  /// **'flutter-photo-booth@google.com'**
  String get sharePageSocialMediaShareClarification2;

  /// Third part of the text shown at the bottom of the share page that clarifies how photos are stored on the backend when shared on social medias
  ///
  /// In en, this message translates to:
  /// **' and be sure to include your unique URL in your request.'**
  String get sharePageSocialMediaShareClarification3;

  /// Title of the button used to copy the share link.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get sharePageCopyLinkButton;

  /// Title of the button used to indicate that the link has been copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get sharePageLinkedCopiedButton;

  /// Heading shown on the share page when an error occurs.
  ///
  /// In en, this message translates to:
  /// **'We\'re having trouble processing your image'**
  String get sharePageErrorHeading;

  /// Subheading shown on the share page when an error occurs.
  ///
  /// In en, this message translates to:
  /// **'Please make sure your device and browser are up to date. If this issue persists, please contact flutter-photo-booth@google.com.'**
  String get sharePageErrorSubheading;

  /// Heading shown on the share dialog.
  ///
  /// In en, this message translates to:
  /// **'Share your photo!'**
  String get shareDialogHeading;

  /// Subheading shown on the share dialog.
  ///
  /// In en, this message translates to:
  /// **'Let everyone know you\'re at Google I∕O by sharing your photo & updating your profile picture during the event!'**
  String get shareDialogSubheading;

  /// Heading shown on the share error dialog.
  ///
  /// In en, this message translates to:
  /// **'Oops!'**
  String get shareErrorDialogHeading;

  /// Title of the button displayed on the share error dialog used to retry the upload operation.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get shareErrorDialogTryAgainButton;

  /// Subheading shown on the share error dialog.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong and we couldn\'t load your photo.'**
  String get shareErrorDialogSubheading;

  /// Heading shown on the share page progress overlay.
  ///
  /// In en, this message translates to:
  /// **'We\'re making your photo pixel perfect with Flutter! '**
  String get sharePageProgressOverlayHeading;

  /// Subheading shown on the share page progress overlay.
  ///
  /// In en, this message translates to:
  /// **'Please do not close this tab.'**
  String get sharePageProgressOverlaySubheading;

  /// Button text shown on the share dialog which shares on Twitter the photo.
  ///
  /// In en, this message translates to:
  /// **'Twitter'**
  String get shareDialogTwitterButtonText;

  /// Button text shown on the share dialog which shares on Facebook the photo.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get shareDialogFacebookButtonText;

  /// Text displayed on headline on the photobooth page when camera permissions is not granted
  ///
  /// In en, this message translates to:
  /// **'Camera access denied'**
  String get photoBoothCameraAccessDeniedHeadline;

  /// Text displayed on subheadline on the photobooth page when camera permissions is not granted
  ///
  /// In en, this message translates to:
  /// **'To take a photo, you must allow browser access to your camera.'**
  String get photoBoothCameraAccessDeniedSubheadline;

  /// Text displayed on headline on the photobooth page when camera is not found
  ///
  /// In en, this message translates to:
  /// **'We can’t find your camera'**
  String get photoBoothCameraNotFoundHeadline;

  /// Text displayed on the first subheadline on the photobooth page when camera is not found
  ///
  /// In en, this message translates to:
  /// **'Looks like your device does not have a camera or it is not working.'**
  String get photoBoothCameraNotFoundSubheadline1;

  /// Text displayed on the second subheadline on the photobooth page when camera is not found
  ///
  /// In en, this message translates to:
  /// **'To take a photo, please revisit I∕O Photo Booth from a device with a camera.'**
  String get photoBoothCameraNotFoundSubheadline2;

  /// Text displayed on headline on the photobooth page when unknown error occurs
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong'**
  String get photoBoothCameraErrorHeadline;

  /// Text displayed on the first subheadline on the photobooth page when unknown error occurs
  ///
  /// In en, this message translates to:
  /// **'Please refresh your browser and try again.'**
  String get photoBoothCameraErrorSubheadline1;

  /// Text displayed on the second subheadline on the photobooth page when unknown error occurs
  ///
  /// In en, this message translates to:
  /// **'If this issue persists, please contact flutter-photo-booth@google.com'**
  String get photoBoothCameraErrorSubheadline2;

  /// Text displayed on headline on the photobooth page when camera is not supported
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong'**
  String get photoBoothCameraNotSupportedHeadline;

  /// Text displayed on subheadline on the photobooth page when camera is not supported
  ///
  /// In en, this message translates to:
  /// **'Please make sure your device and browser are up to date.'**
  String get photoBoothCameraNotSupportedSubheadline;

  /// Text displayed on the stickers drawer as title
  ///
  /// In en, this message translates to:
  /// **'Add Props'**
  String get stickersDrawerTitle;

  /// Text displayed on the tooltip for the open stickers button
  ///
  /// In en, this message translates to:
  /// **'Add Props'**
  String get openStickersTooltip;

  /// Text displayed on the tooltip for the retake button
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retakeButtonTooltip;

  /// Text displayed on the tooltip for the clear stickers button
  ///
  /// In en, this message translates to:
  /// **'Clear Props'**
  String get clearStickersButtonTooltip;

  /// Text displayed as a caption on the characters layout
  ///
  /// In en, this message translates to:
  /// **'Add Friends'**
  String get charactersCaptionText;

  /// Part 1 text shown on the share page which mentions technologies used to build the app.
  ///
  /// In en, this message translates to:
  /// **'Learn more about '**
  String get sharePageLearnMoreAboutTextPart1;

  /// Part 2 text shown on the share page which mentions technologies used to build the app.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get sharePageLearnMoreAboutTextPart2;

  /// Part 3 text shown on the share page which mentions technologies used to build the app.
  ///
  /// In en, this message translates to:
  /// **' or dive right into the '**
  String get sharePageLearnMoreAboutTextPart3;

  /// Part 4 text shown on the share page which mentions technologies used to build the app.
  ///
  /// In en, this message translates to:
  /// **'open source code'**
  String get sharePageLearnMoreAboutTextPart4;

  /// Text displayed on the button to navigate to Google I∕O
  ///
  /// In en, this message translates to:
  /// **'Go to Google I∕O'**
  String get goToGoogleIOButtonText;

  /// Heading displayed on the clear stickers dialog
  ///
  /// In en, this message translates to:
  /// **'Clear all props?'**
  String get clearStickersDialogHeading;

  /// Subheading displayed on the clear stickers dialog
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove all of the props from the screen?'**
  String get clearStickersDialogSubheading;

  /// Cancel button text displayed on the clear stickers dialog
  ///
  /// In en, this message translates to:
  /// **'No, take me back'**
  String get clearStickersDialogCancelButtonText;

  /// Confirm button text displayed on the clear stickers dialog
  ///
  /// In en, this message translates to:
  /// **'Yes, clear all props'**
  String get clearStickersDialogConfirmButtonText;

  /// Helper text to add props
  ///
  /// In en, this message translates to:
  /// **'Add some props'**
  String get propsReminderText;

  /// Heading shown in the confirmation when user taps the next button
  ///
  /// In en, this message translates to:
  /// **'Ready to see the final photo?'**
  String get stickersNextConfirmationHeading;

  /// Subheading shown in the confirmation when user taps the next button
  ///
  /// In en, this message translates to:
  /// **'Once you leave this screen you won\'t be able to make any changes'**
  String get stickersNextConfirmationSubheading;

  /// Cancel button text shown in the confirmation when user taps the next button
  ///
  /// In en, this message translates to:
  /// **'No, I\'m still creating'**
  String get stickersNextConfirmationCancelButtonText;

  /// Confirm button text shown in the confirmation when user taps the next button
  ///
  /// In en, this message translates to:
  /// **'Yes, show me'**
  String get stickersNextConfirmationConfirmButtonText;

  /// Heading shown in the confirmation when user taps the retake button
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get stickersRetakeConfirmationHeading;

  /// Subheading shown in the confirmation when user taps the retake button
  ///
  /// In en, this message translates to:
  /// **'Retaking the photo will remove any props you\'ve added'**
  String get stickersRetakeConfirmationSubheading;

  /// Cancel button text shown in the confirmation when user taps the retake button
  ///
  /// In en, this message translates to:
  /// **'No, stay here'**
  String get stickersRetakeConfirmationCancelButtonText;

  /// Confirm button text shown in the confirmation when user taps the retake button
  ///
  /// In en, this message translates to:
  /// **'Yes, retake photo'**
  String get stickersRetakeConfirmationConfirmButtonText;

  /// Heading shown in the confirmation when user taps the retake button
  ///
  /// In en, this message translates to:
  /// **'Ready to take a new photo?'**
  String get shareRetakeConfirmationHeading;

  /// Subheading shown in the confirmation when user taps the retake button
  ///
  /// In en, this message translates to:
  /// **'Remember to download or share this one first'**
  String get shareRetakeConfirmationSubheading;

  /// Cancel button text shown in the confirmation when user taps the retake button
  ///
  /// In en, this message translates to:
  /// **'No, stay here'**
  String get shareRetakeConfirmationCancelButtonText;

  /// Confirm button text shown in the confirmation when user taps the retake button
  ///
  /// In en, this message translates to:
  /// **'Yes, retake photo'**
  String get shareRetakeConfirmationConfirmButtonText;

  /// Semantic label for the shutter button used to take a photo
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get shutterButtonLabelText;

  /// Semantic label for the next button used to proceed to the share page
  ///
  /// In en, this message translates to:
  /// **'Create final photo'**
  String get stickersNextButtonLabelText;

  /// Semantic label for the dash character button
  ///
  /// In en, this message translates to:
  /// **'Add dash friend'**
  String get dashButtonLabelText;

  /// Semantic label for the sparky character button
  ///
  /// In en, this message translates to:
  /// **'Add sparky friend'**
  String get sparkyButtonLabelText;

  /// Semantic label for the dino character button
  ///
  /// In en, this message translates to:
  /// **'Add dino friend'**
  String get dinoButtonLabelText;

  /// Semantic label for the android jetpack character button
  ///
  /// In en, this message translates to:
  /// **'Add android jetpack friend'**
  String get androidButtonLabelText;

  /// Semantic label for the add props button
  ///
  /// In en, this message translates to:
  /// **'Add props'**
  String get addStickersButtonLabelText;

  /// Semantic label for the retake photo button
  ///
  /// In en, this message translates to:
  /// **'Retake photo'**
  String get retakePhotoButtonLabelText;

  /// Semantic label for the clear all stickers button
  ///
  /// In en, this message translates to:
  /// **'Clear all props'**
  String get clearAllStickersButtonLabelText;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'en',
        'es',
        'fr',
        'hu',
        'id',
        'ne',
        'te',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'ne':
      return AppLocalizationsNe();
    case 'te':
      return AppLocalizationsTe();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
