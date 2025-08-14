// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get landingPageHeading => 'Üdvözlünk az I∕O Photo Booth-ban';

  @override
  String get landingPageSubheading =>
      'Készíts egy fotót és oszd meg a közösséggel!';

  @override
  String get landingPageTakePhotoButtonText => 'Kezdjünk bele';

  @override
  String get footerMadeWithText => 'Ezzel készült ';

  @override
  String get footerMadeWithFlutterLinkText => 'Flutter';

  @override
  String get footerMadeWithFirebaseLinkText => 'Firebase';

  @override
  String get footerGoogleIOLinkText => 'Google I∕O';

  @override
  String get footerCodelabLinkText => 'Codelab';

  @override
  String get footerHowItsMadeLinkText => 'Hogyan készült';

  @override
  String get footerTermsOfServiceLinkText => 'Felhasználási feltételek';

  @override
  String get footerPrivacyPolicyLinkText => 'Adatvédelmi irányelvek';

  @override
  String get sharePageHeading => 'Oszd meg a fotód a közösséggel!';

  @override
  String get sharePageSubheading => 'Oszd meg a fotód a közösséggel!';

  @override
  String get sharePageSuccessHeading => 'Fotó megosztva!';

  @override
  String get sharePageSuccessSubheading =>
      'Köszönjük, hogy a Flutter webalkalmazásunkat használtad! A fotód közzé lett téve ezen az egyedi webcímen';

  @override
  String get sharePageSuccessCaption1 =>
      'A fotód elérhető lesz azon a webcímen 30 napig, majd automatikusan törölve lesz. A fotód korai törléséhez vedd fel a kapcsolatot a ';

  @override
  String get sharePageSuccessCaption2 => 'flutter-photo-booth@google.com';

  @override
  String get sharePageSuccessCaption3 =>
      ' e-mail címen, és feltétlenül add meg az egyedi webcímet a törléshez.';

  @override
  String get sharePageRetakeButtonText => 'Készíts egy új fotót';

  @override
  String get sharePageShareButtonText => 'Megosztás';

  @override
  String get sharePageDownloadButtonText => 'Letöltés';

  @override
  String get socialMediaShareLinkText =>
      'Éppen készítettem egy szelfit a #IOPhotoBooth-nál. Még látjuk egymást a #GoogleIO-n!';

  @override
  String get previewPageCameraNotAllowedText =>
      'Megtagadtad a hozzáférést a kamerádhoz. Kérjük adj hozzáférést, hogy használhasd az alkalmazást.';

  @override
  String get sharePageSocialMediaShareClarification1 =>
      'Ha a közösségi médiában szeretnéd megosztani a fotód, akkor 30 napig elérhető lesz ezen az egyedi webcímen, majd automatikusan törölve lesz. A fotók amelyek nem kerülnek megosztásra, nem lesznek eltárolva. A fotód korai törléséhez vedd fel a kapcsolatot a ';

  @override
  String get sharePageSocialMediaShareClarification2 =>
      'flutter-photo-booth@google.com';

  @override
  String get sharePageSocialMediaShareClarification3 =>
      ' e-mail címen, és feltétlenül add meg az egyedi webcímet a törléshez.';

  @override
  String get sharePageCopyLinkButton => 'Másolás';

  @override
  String get sharePageLinkedCopiedButton => 'Másolva';

  @override
  String get sharePageErrorHeading =>
      'Gondjaink akadtak a fotód feldolgozásával';

  @override
  String get sharePageErrorSubheading =>
      'Kérjük ellenőrizd, hogy eszközöd és böngésződ naprakész-e. Hogyha a probléma továbbra is jelen van vedd fel a kapcsolatot a flutter-photo-booth@google.com e-mail címen.';

  @override
  String get shareDialogHeading => 'Oszd meg a fotód!';

  @override
  String get shareDialogSubheading =>
      'Tudasd mindenkivel, hogy részt veszel a Google I∕O-n azzal, hogy megosztod a fotódat és frissíted a profilképedet az esemény alatt.';

  @override
  String get shareErrorDialogHeading => 'Hoppá!';

  @override
  String get shareErrorDialogTryAgainButton => 'Menj vissza';

  @override
  String get shareErrorDialogSubheading =>
      'Valami hiba történt és nem tudtuk betölteni a fotódat.';

  @override
  String get sharePageProgressOverlayHeading =>
      'Éppen tökéletesítjük a fotódat Flutterrel! ';

  @override
  String get sharePageProgressOverlaySubheading =>
      'Kérjük, ne zárd be ezt a lapot.';

  @override
  String get shareDialogTwitterButtonText => 'Twitter';

  @override
  String get shareDialogFacebookButtonText => 'Facebook';

  @override
  String get photoBoothCameraAccessDeniedHeadline =>
      'Kamera hozzáférés megtagadva';

  @override
  String get photoBoothCameraAccessDeniedSubheadline =>
      'Ahhoz, hogy fotót készíthess, adj hozzáférést a böngésződnek a kamerádhoz.';

  @override
  String get photoBoothCameraNotFoundHeadline => 'Nem találjuk a kamerádat.';

  @override
  String get photoBoothCameraNotFoundSubheadline1 =>
      'Úgy tűnik, hogy az eszközöd nem rendelkezik kamerával, vagy az nem működik.';

  @override
  String get photoBoothCameraNotFoundSubheadline2 =>
      'Ahhoz, hogy fotót készíthess, kérjük látogasd meg az I∕O Photo Booth-ot egy kamerával rendelkező eszközről.';

  @override
  String get photoBoothCameraErrorHeadline => 'Hoppá! Valami hiba történt';

  @override
  String get photoBoothCameraErrorSubheadline1 => 'Kérjük frissítsd a lapot a ';

  @override
  String get photoBoothCameraErrorSubheadline2 =>
      'Hogyha a probléma továbbra is jelen van vedd fel a kapcsolatot a flutter-photo-booth@google.com e-mail címen.';

  @override
  String get photoBoothCameraNotSupportedHeadline =>
      'Hoppá! Valami hiba történt';

  @override
  String get photoBoothCameraNotSupportedSubheadline =>
      'Kérjük ellenőrizd, hogy eszközöd és böngésződ naprakész-e.';

  @override
  String get stickersDrawerTitle => 'Kellékek hozzáadása';

  @override
  String get openStickersTooltip => 'Kellékek hozzáadása';

  @override
  String get retakeButtonTooltip => 'Újrafotózás';

  @override
  String get clearStickersButtonTooltip => 'Kellékek törlése';

  @override
  String get charactersCaptionText => 'Barátok hozzáadása';

  @override
  String get sharePageLearnMoreAboutTextPart1 => 'Tudj meg többet a ';

  @override
  String get sharePageLearnMoreAboutTextPart2 => ' és ';

  @override
  String get sharePageLearnMoreAboutTextPart3 =>
      ' technológiákról, vagy tekintsd meg a ';

  @override
  String get sharePageLearnMoreAboutTextPart4 => 'nyílt forráskódot';

  @override
  String get goToGoogleIOButtonText => 'Menj a Google I∕O-ra';

  @override
  String get clearStickersDialogHeading => 'Törlöd a kellékeket?';

  @override
  String get clearStickersDialogSubheading =>
      'Törölni szeretnéd az összes kelléket a képernyőről?';

  @override
  String get clearStickersDialogCancelButtonText => 'Nem, vigyél vissza';

  @override
  String get clearStickersDialogConfirmButtonText => 'Igen, kellékek törlése';

  @override
  String get propsReminderText => 'Kellékek hozzáadása';

  @override
  String get stickersNextConfirmationHeading =>
      'Készen állsz a kész fotó megtekintésére?';

  @override
  String get stickersNextConfirmationSubheading =>
      'Ha elhagyod ezt a képernyőt, nem fogsz tudni további módosításokat végrehajtani';

  @override
  String get stickersNextConfirmationCancelButtonText => 'Nem, még alkotok';

  @override
  String get stickersNextConfirmationConfirmButtonText => 'Igen, mutasd meg';

  @override
  String get stickersRetakeConfirmationHeading => 'Biztos vagy benne?';

  @override
  String get stickersRetakeConfirmationSubheading =>
      'Az újrafotózás eltűnteti a hozzáadott kellékeket';

  @override
  String get stickersRetakeConfirmationCancelButtonText => 'Nem, maradok itt';

  @override
  String get stickersRetakeConfirmationConfirmButtonText => 'Igen, újrafotózom';

  @override
  String get shareRetakeConfirmationHeading =>
      'Készen állsz egy új fotó elkészítésére?';

  @override
  String get shareRetakeConfirmationSubheading =>
      'Ne felejtsd el letölteni vagy megosztani ezt először';

  @override
  String get shareRetakeConfirmationCancelButtonText => 'Nem, maradok itt';

  @override
  String get shareRetakeConfirmationConfirmButtonText => 'Igen, újrafotózom';

  @override
  String get shutterButtonLabelText => 'Fotó készítése';

  @override
  String get stickersNextButtonLabelText => 'Végleges fotó elkészítése';

  @override
  String get dashButtonLabelText => 'Dash barát hozzáadása';

  @override
  String get sparkyButtonLabelText => 'Sparky barát hozzáadása';

  @override
  String get dinoButtonLabelText => 'Dínó barát hozzáadása';

  @override
  String get androidButtonLabelText => 'Android jetpack barát hozzáadása';

  @override
  String get addStickersButtonLabelText => 'Kellékek hozzáadása';

  @override
  String get retakePhotoButtonLabelText => 'Újrafotózás';

  @override
  String get clearAllStickersButtonLabelText => 'Kellékek törlése';
}
