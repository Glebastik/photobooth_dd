// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get landingPageHeading => '欢迎来到 I∕O 照相馆';

  @override
  String get landingPageSubheading => '向社区分享您拍的照片！';

  @override
  String get landingPageTakePhotoButtonText => '开拍';

  @override
  String get footerMadeWithText => '产品构建基于 ';

  @override
  String get footerMadeWithFlutterLinkText => 'Flutter';

  @override
  String get footerMadeWithFirebaseLinkText => 'Firebase';

  @override
  String get footerGoogleIOLinkText => 'Google I∕O';

  @override
  String get footerCodelabLinkText => 'Codelab';

  @override
  String get footerHowItsMadeLinkText => '本应用如何构建';

  @override
  String get footerTermsOfServiceLinkText => '服务条款';

  @override
  String get footerPrivacyPolicyLinkText => '隐私权政策';

  @override
  String get sharePageHeading => '向社区分享您拍的照片！';

  @override
  String get sharePageSubheading => '向社区分享您拍的照片！';

  @override
  String get sharePageSuccessHeading => '拍照已分享！';

  @override
  String get sharePageSuccessSubheading =>
      '感谢使用由 Flutter 构建的 Web 应用，您拍的照片已经发布在这个唯一的网址上了';

  @override
  String get sharePageSuccessCaption1 =>
      '您拍的照片将在这个网址上保留 30 天然后被自动删除。若要请求提前删除，请联系 ';

  @override
  String get sharePageSuccessCaption2 => 'flutter-photo-booth@google.com';

  @override
  String get sharePageSuccessCaption3 => ' 并确保带上照片的唯一网址。';

  @override
  String get sharePageRetakeButtonText => '重新拍一张';

  @override
  String get sharePageShareButtonText => '分享';

  @override
  String get sharePageDownloadButtonText => '下载';

  @override
  String get socialMediaShareLinkText =>
      '刚通过 #IO照相馆 拍了一张自拍，大家 #GoogleIO 大会见！#IOPhotoBooth ';

  @override
  String get previewPageCameraNotAllowedText =>
      '您拒绝授予使用设备相机的权限，为了使用这个应用，请予以授权。';

  @override
  String get sharePageSocialMediaShareClarification1 =>
      '如果您选择在社交平台上分享您拍的照片，应用将会生成一个唯一的、30 天有效期网址的网址（过期自动删除），照片亦不会被分享或者存储。如果您希望提早删除这些照片，请联系 ';

  @override
  String get sharePageSocialMediaShareClarification2 =>
      'flutter-photo-booth@google.com';

  @override
  String get sharePageSocialMediaShareClarification3 => ' 并且带上照片的唯一网址。';

  @override
  String get sharePageCopyLinkButton => '复制';

  @override
  String get sharePageLinkedCopiedButton => '已复制';

  @override
  String get sharePageErrorHeading => '处理照片时遇到了一些问题';

  @override
  String get sharePageErrorSubheading =>
      '请确保您的设备和浏览器都更新到了最新版本，如果问题依旧存在，请通过这个邮件与我们联系 flutter-photo-booth@google.com 。';

  @override
  String get shareDialogHeading => '分享您拍的照片！';

  @override
  String get shareDialogSubheading =>
      '与其他人分享您拍的照片，也可以替换为头像，让大家知道您在参加 Google I/O 大会！';

  @override
  String get shareErrorDialogHeading => '喔唷！';

  @override
  String get shareErrorDialogTryAgainButton => '退回';

  @override
  String get shareErrorDialogSubheading => '出了点问题，我们没法加载您拍的照片了。';

  @override
  String get sharePageProgressOverlayHeading => '正在通过 Flutter “精修” 您拍的照片！';

  @override
  String get sharePageProgressOverlaySubheading => '请不要关闭本页面。';

  @override
  String get shareDialogTwitterButtonText => 'Twitter';

  @override
  String get shareDialogFacebookButtonText => 'Facebook';

  @override
  String get photoBoothCameraAccessDeniedHeadline => '相机权限获取失败';

  @override
  String get photoBoothCameraAccessDeniedSubheadline =>
      '为了拍照成功，您需要允许浏览器获取您的相机权限';

  @override
  String get photoBoothCameraNotFoundHeadline => '无法找到相机';

  @override
  String get photoBoothCameraNotFoundSubheadline1 => '您的设备似乎并没有相机或者相机工作不正常';

  @override
  String get photoBoothCameraNotFoundSubheadline2 =>
      '如果您希望使用这个应用进行拍照，请通过相机功能正常的设备访问 I∕O 照相馆页面。';

  @override
  String get photoBoothCameraErrorHeadline => '糟糕，出错儿了';

  @override
  String get photoBoothCameraErrorSubheadline1 => '请刷新您的浏览器然后重试。';

  @override
  String get photoBoothCameraErrorSubheadline2 =>
      '如果问题仍一直出现，请通过邮件联系我们 flutter-photo-booth@google.com';

  @override
  String get photoBoothCameraNotSupportedHeadline => '糟糕，出错儿了';

  @override
  String get photoBoothCameraNotSupportedSubheadline => '请确保您的设备和浏览器都已更新至最新版本。';

  @override
  String get stickersDrawerTitle => '添加贴纸';

  @override
  String get openStickersTooltip => '添加贴纸';

  @override
  String get retakeButtonTooltip => '重拍';

  @override
  String get clearStickersButtonTooltip => '清除贴纸';

  @override
  String get charactersCaptionText => '来几个好朋友';

  @override
  String get sharePageLearnMoreAboutTextPart1 => '您可以了解更多关于 ';

  @override
  String get sharePageLearnMoreAboutTextPart2 => ' 和 ';

  @override
  String get sharePageLearnMoreAboutTextPart3 => '，或者更深入的了解和查看 ';

  @override
  String get sharePageLearnMoreAboutTextPart4 => '开源代码。';

  @override
  String get goToGoogleIOButtonText => '查看 Google I∕O 内容';

  @override
  String get clearStickersDialogHeading => '要清除所有贴纸吗？';

  @override
  String get clearStickersDialogSubheading => '您是要清空屏幕上所有添加的贴纸吗？';

  @override
  String get clearStickersDialogCancelButtonText => '不是，请返回上一页';

  @override
  String get clearStickersDialogConfirmButtonText => '是的，清除所有贴纸';

  @override
  String get propsReminderText => '添加一些贴纸';

  @override
  String get stickersNextConfirmationHeading => '准备好查看您拍的照片了嘛？';

  @override
  String get stickersNextConfirmationSubheading => '一旦您离开这个页面，照片就不能再进行任何修改了喔。';

  @override
  String get stickersNextConfirmationCancelButtonText => '不要，我还需要再改改';

  @override
  String get stickersNextConfirmationConfirmButtonText => '可以，展示我拍的照片';

  @override
  String get stickersRetakeConfirmationHeading => '您确定吗？';

  @override
  String get stickersRetakeConfirmationSubheading => '选择重拍会让您添加的所有贴纸和朋友都被移除';

  @override
  String get stickersRetakeConfirmationCancelButtonText => '不要，请留在当前页面';

  @override
  String get stickersRetakeConfirmationConfirmButtonText => '是的，重新拍照';

  @override
  String get shareRetakeConfirmationHeading => '准备好拍一张新照片了吗？';

  @override
  String get shareRetakeConfirmationSubheading => '记得把刚拍的那张下载保存或者分享出去';

  @override
  String get shareRetakeConfirmationCancelButtonText => '没有，请留在当前页面';

  @override
  String get shareRetakeConfirmationConfirmButtonText => '是的，重新拍照';

  @override
  String get shutterButtonLabelText => '拍照';

  @override
  String get stickersNextButtonLabelText => '创建最终版的照片';

  @override
  String get dashButtonLabelText => '添加朋友 dash';

  @override
  String get sparkyButtonLabelText => '添加朋友 sparky';

  @override
  String get dinoButtonLabelText => '添加朋友 dino';

  @override
  String get androidButtonLabelText => '添加朋友 android jetpack';

  @override
  String get addStickersButtonLabelText => '添加贴纸';

  @override
  String get retakePhotoButtonLabelText => '重拍';

  @override
  String get clearAllStickersButtonLabelText => '清除所有贴纸';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get landingPageHeading => '欢迎来到 I∕O 照相馆';

  @override
  String get landingPageSubheading => '向社区分享您拍的照片！';

  @override
  String get landingPageTakePhotoButtonText => '开拍';

  @override
  String get footerMadeWithText => '产品构建基于 ';

  @override
  String get footerMadeWithFlutterLinkText => 'Flutter';

  @override
  String get footerMadeWithFirebaseLinkText => 'Firebase';

  @override
  String get footerGoogleIOLinkText => 'Google I∕O';

  @override
  String get footerCodelabLinkText => 'Codelab';

  @override
  String get footerHowItsMadeLinkText => '本应用如何构建';

  @override
  String get footerTermsOfServiceLinkText => '服务条款';

  @override
  String get footerPrivacyPolicyLinkText => '隐私权政策';

  @override
  String get sharePageHeading => '向社区分享您拍的照片！';

  @override
  String get sharePageSubheading => '向社区分享您拍的照片！';

  @override
  String get sharePageSuccessHeading => '拍照已分享！';

  @override
  String get sharePageSuccessSubheading =>
      '感谢使用由 Flutter 构建的 Web 应用，您拍的照片已经发布在这个唯一的网址上了';

  @override
  String get sharePageSuccessCaption1 =>
      '您拍的照片将在这个网址上保留 30 天然后被自动删除。若要请求提前删除，请联系 ';

  @override
  String get sharePageSuccessCaption2 => 'flutter-photo-booth@google.com';

  @override
  String get sharePageSuccessCaption3 => ' 并确保带上照片的唯一网址。';

  @override
  String get sharePageRetakeButtonText => '重新拍一张';

  @override
  String get sharePageShareButtonText => '分享';

  @override
  String get sharePageDownloadButtonText => '下载';

  @override
  String get socialMediaShareLinkText =>
      '刚通过 #IO照相馆 拍了一张自拍，大家 #GoogleIO 大会见！#IOPhotoBooth ';

  @override
  String get previewPageCameraNotAllowedText =>
      '您拒绝授予使用设备相机的权限，为了使用这个应用，请予以授权。';

  @override
  String get sharePageSocialMediaShareClarification1 =>
      '如果您选择在社交平台上分享您拍的照片，应用将会生成一个唯一的、30 天有效期网址的网址（过期自动删除），照片亦不会被分享或者存储。如果您希望提早删除这些照片，请联系 ';

  @override
  String get sharePageSocialMediaShareClarification2 =>
      'flutter-photo-booth@google.com';

  @override
  String get sharePageSocialMediaShareClarification3 => ' 并且带上照片的唯一网址。';

  @override
  String get sharePageCopyLinkButton => '复制';

  @override
  String get sharePageLinkedCopiedButton => '已复制';

  @override
  String get sharePageErrorHeading => '处理照片时遇到了一些问题';

  @override
  String get sharePageErrorSubheading =>
      '请确保您的设备和浏览器都更新到了最新版本，如果问题依旧存在，请通过这个邮件与我们联系 flutter-photo-booth@google.com 。';

  @override
  String get shareDialogHeading => '分享您拍的照片！';

  @override
  String get shareDialogSubheading =>
      '与其他人分享您拍的照片，也可以替换为头像，让大家知道您在参加 Google I/O 大会！';

  @override
  String get shareErrorDialogHeading => '喔唷！';

  @override
  String get shareErrorDialogTryAgainButton => '退回';

  @override
  String get shareErrorDialogSubheading => '出了点问题，我们没法加载您拍的照片了。';

  @override
  String get sharePageProgressOverlayHeading => '正在通过 Flutter “精修” 您拍的照片！';

  @override
  String get sharePageProgressOverlaySubheading => '请不要关闭本页面。';

  @override
  String get shareDialogTwitterButtonText => 'Twitter';

  @override
  String get shareDialogFacebookButtonText => 'Facebook';

  @override
  String get photoBoothCameraAccessDeniedHeadline => '相机权限获取失败';

  @override
  String get photoBoothCameraAccessDeniedSubheadline =>
      '为了拍照成功，您需要允许浏览器获取您的相机权限';

  @override
  String get photoBoothCameraNotFoundHeadline => '无法找到相机';

  @override
  String get photoBoothCameraNotFoundSubheadline1 => '您的设备似乎并没有相机或者相机工作不正常';

  @override
  String get photoBoothCameraNotFoundSubheadline2 =>
      '如果您希望使用这个应用进行拍照，请通过相机功能正常的设备访问 I∕O 照相馆页面。';

  @override
  String get photoBoothCameraErrorHeadline => '糟糕，出错儿了';

  @override
  String get photoBoothCameraErrorSubheadline1 => '请刷新您的浏览器然后重试。';

  @override
  String get photoBoothCameraErrorSubheadline2 =>
      '如果问题仍一直出现，请通过邮件联系我们 flutter-photo-booth@google.com';

  @override
  String get photoBoothCameraNotSupportedHeadline => '糟糕，出错儿了';

  @override
  String get photoBoothCameraNotSupportedSubheadline => '请确保您的设备和浏览器都已更新至最新版本。';

  @override
  String get stickersDrawerTitle => '添加贴纸';

  @override
  String get openStickersTooltip => '添加贴纸';

  @override
  String get retakeButtonTooltip => '重拍';

  @override
  String get clearStickersButtonTooltip => '清除贴纸';

  @override
  String get charactersCaptionText => '来几个好朋友';

  @override
  String get sharePageLearnMoreAboutTextPart1 => '您可以了解更多关于 ';

  @override
  String get sharePageLearnMoreAboutTextPart2 => ' 和 ';

  @override
  String get sharePageLearnMoreAboutTextPart3 => '，或者更深入的了解和查看 ';

  @override
  String get sharePageLearnMoreAboutTextPart4 => '开源代码。';

  @override
  String get goToGoogleIOButtonText => '查看 Google I∕O 内容';

  @override
  String get clearStickersDialogHeading => '要清除所有贴纸吗？';

  @override
  String get clearStickersDialogSubheading => '您是要清空屏幕上所有添加的贴纸吗？';

  @override
  String get clearStickersDialogCancelButtonText => '不是，请返回上一页';

  @override
  String get clearStickersDialogConfirmButtonText => '是的，清除所有贴纸';

  @override
  String get propsReminderText => '添加一些贴纸';

  @override
  String get stickersNextConfirmationHeading => '准备好查看您拍的照片了嘛？';

  @override
  String get stickersNextConfirmationSubheading => '一旦您离开这个页面，照片就不能再进行任何修改了喔。';

  @override
  String get stickersNextConfirmationCancelButtonText => '不要，我还需要再改改';

  @override
  String get stickersNextConfirmationConfirmButtonText => '可以，展示我拍的照片';

  @override
  String get stickersRetakeConfirmationHeading => '您确定吗？';

  @override
  String get stickersRetakeConfirmationSubheading => '选择重拍会让您添加的所有贴纸和朋友都被移除';

  @override
  String get stickersRetakeConfirmationCancelButtonText => '不要，请留在当前页面';

  @override
  String get stickersRetakeConfirmationConfirmButtonText => '是的，重新拍照';

  @override
  String get shareRetakeConfirmationHeading => '准备好拍一张新照片了吗？';

  @override
  String get shareRetakeConfirmationSubheading => '记得把刚拍的那张下载保存或者分享出去';

  @override
  String get shareRetakeConfirmationCancelButtonText => '没有，请留在当前页面';

  @override
  String get shareRetakeConfirmationConfirmButtonText => '是的，重新拍照';

  @override
  String get shutterButtonLabelText => '拍照';

  @override
  String get stickersNextButtonLabelText => '创建最终版的照片';

  @override
  String get dashButtonLabelText => '添加朋友 dash';

  @override
  String get sparkyButtonLabelText => '添加朋友 sparky';

  @override
  String get dinoButtonLabelText => '添加朋友 dino';

  @override
  String get androidButtonLabelText => '添加朋友 android jetpack';

  @override
  String get addStickersButtonLabelText => '添加贴纸';

  @override
  String get retakePhotoButtonLabelText => '重拍';

  @override
  String get clearAllStickersButtonLabelText => '清除所有贴纸';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get landingPageHeading => '歡迎來到 I∕O 照相館';

  @override
  String get landingPageSubheading => '向社群分享您拍的照片！';

  @override
  String get landingPageTakePhotoButtonText => '開拍';

  @override
  String get footerMadeWithText => '產品構建基於 ';

  @override
  String get footerMadeWithFlutterLinkText => 'Flutter';

  @override
  String get footerMadeWithFirebaseLinkText => 'Firebase';

  @override
  String get footerGoogleIOLinkText => 'Google I∕O';

  @override
  String get footerCodelabLinkText => 'Codelab';

  @override
  String get footerHowItsMadeLinkText => '本應用程式如何構建';

  @override
  String get footerTermsOfServiceLinkText => '服務條款';

  @override
  String get footerPrivacyPolicyLinkText => '私隱權政策';

  @override
  String get sharePageHeading => '向社群分享您拍的照片！';

  @override
  String get sharePageSubheading => '向社群分享您拍的照片！';

  @override
  String get sharePageSuccessHeading => '拍照已分享！';

  @override
  String get sharePageSuccessSubheading =>
      '感謝使用由 Flutter 構建的 Web 應用程式，您拍的照片已經發佈在這個唯一的網址上了';

  @override
  String get sharePageSuccessCaption1 =>
      '您拍的照片將在這個網址上保留 30 天然後被自動刪除。若要請求提前刪除，請聯絡 ';

  @override
  String get sharePageSuccessCaption2 => 'flutter-photo-booth@google.com';

  @override
  String get sharePageSuccessCaption3 => ' 並確保帶上照片的唯一網址。';

  @override
  String get sharePageRetakeButtonText => '重新拍一張';

  @override
  String get sharePageShareButtonText => '分享';

  @override
  String get sharePageDownloadButtonText => '下載';

  @override
  String get socialMediaShareLinkText =>
      '剛通過 #IO照相館 拍了一張自拍，大家 #GoogleIO 大會見！#IOPhotoBooth ';

  @override
  String get previewPageCameraNotAllowedText =>
      '您拒絕授予使用設備相機的權限，為了使用這個應用程式，請予以授權。';

  @override
  String get sharePageSocialMediaShareClarification1 =>
      '如果您選擇在社交平台上分享您拍的照片，應用程式將會生成一個唯一的、30 天有效期網址的網址（過期自動刪除），照片亦不會被分享或者存儲。如果您希望提早刪除這些照片，請聯絡 ';

  @override
  String get sharePageSocialMediaShareClarification2 =>
      'flutter-photo-booth@google.com';

  @override
  String get sharePageSocialMediaShareClarification3 => ' 並且帶上照片的唯一網址。';

  @override
  String get sharePageCopyLinkButton => '複製';

  @override
  String get sharePageLinkedCopiedButton => '已複製';

  @override
  String get sharePageErrorHeading => '處理照片時遇到了一些問題';

  @override
  String get sharePageErrorSubheading =>
      '請確保您的設備和瀏覽器都更新到了最新版本，如果問題依舊存在，請通過這個郵件與我們聯絡 flutter-photo-booth@google.com 。';

  @override
  String get shareDialogHeading => '分享您拍的照片！';

  @override
  String get shareDialogSubheading =>
      '與其他人分享您拍的照片，也可以替換為頭像，讓大家知道您在參加 Google I/O 大會！';

  @override
  String get shareErrorDialogHeading => '喔唷！';

  @override
  String get shareErrorDialogTryAgainButton => '退回';

  @override
  String get shareErrorDialogSubheading => '出了點問題，我們沒法加載您拍的照片了。';

  @override
  String get sharePageProgressOverlayHeading => '正在通過 Flutter 「精修」 您拍的照片！';

  @override
  String get sharePageProgressOverlaySubheading => '請不要關閉本頁面。';

  @override
  String get shareDialogTwitterButtonText => 'Twitter';

  @override
  String get shareDialogFacebookButtonText => 'Facebook';

  @override
  String get photoBoothCameraAccessDeniedHeadline => '相機權限獲取失敗';

  @override
  String get photoBoothCameraAccessDeniedSubheadline =>
      '為了拍照成功，您需要允許瀏覽器獲取您的相機權限';

  @override
  String get photoBoothCameraNotFoundHeadline => '無法找到相機';

  @override
  String get photoBoothCameraNotFoundSubheadline1 => '您的設備似乎並沒有相機或者相機工作不正常';

  @override
  String get photoBoothCameraNotFoundSubheadline2 =>
      '如果您希望使用這個應用程式進行拍照，請通過相機功能正常的設備訪問 I∕O 照相館頁面。';

  @override
  String get photoBoothCameraErrorHeadline => '糟糕，出錯了';

  @override
  String get photoBoothCameraErrorSubheadline1 => '請刷新您的瀏覽器然後重試。';

  @override
  String get photoBoothCameraErrorSubheadline2 =>
      '如果問題仍一直出現，請通過郵件聯絡我們 flutter-photo-booth@google.com';

  @override
  String get photoBoothCameraNotSupportedHeadline => '糟糕，出錯了';

  @override
  String get photoBoothCameraNotSupportedSubheadline => '請確保您的設備和瀏覽器都已更新至最新版本。';

  @override
  String get stickersDrawerTitle => '添加貼圖';

  @override
  String get openStickersTooltip => '添加貼圖';

  @override
  String get retakeButtonTooltip => '重拍';

  @override
  String get clearStickersButtonTooltip => '清除貼圖';

  @override
  String get charactersCaptionText => '來幾個好朋友';

  @override
  String get sharePageLearnMoreAboutTextPart1 => '您可以瞭解更多關於 ';

  @override
  String get sharePageLearnMoreAboutTextPart2 => ' 和 ';

  @override
  String get sharePageLearnMoreAboutTextPart3 => '，或者更深入的瞭解和查看 ';

  @override
  String get sharePageLearnMoreAboutTextPart4 => '開原始碼。';

  @override
  String get goToGoogleIOButtonText => '查看 Google I∕O 內容';

  @override
  String get clearStickersDialogHeading => '要清除所有貼圖嗎？';

  @override
  String get clearStickersDialogSubheading => '您是要清空屏幕上所有添加的貼圖嗎？';

  @override
  String get clearStickersDialogCancelButtonText => '不是，請返回上一頁';

  @override
  String get clearStickersDialogConfirmButtonText => '是的，清除所有貼圖';

  @override
  String get propsReminderText => '添加一些貼圖';

  @override
  String get stickersNextConfirmationHeading => '準備好查看您拍的照片了嘛？';

  @override
  String get stickersNextConfirmationSubheading => '一旦您離開這個頁面，照片就不能再進行任何修改了喔。';

  @override
  String get stickersNextConfirmationCancelButtonText => '不要，我還需要再改改';

  @override
  String get stickersNextConfirmationConfirmButtonText => '可以，展示我拍的照片';

  @override
  String get stickersRetakeConfirmationHeading => '您確定嗎？';

  @override
  String get stickersRetakeConfirmationSubheading => '選擇重拍會讓您添加的所有貼圖和朋友都被移除';

  @override
  String get stickersRetakeConfirmationCancelButtonText => '不要，請留在當前頁面';

  @override
  String get stickersRetakeConfirmationConfirmButtonText => '是的，重新拍照';

  @override
  String get shareRetakeConfirmationHeading => '準備好拍一張新照片了嗎？';

  @override
  String get shareRetakeConfirmationSubheading => '記得把剛拍的那張下載保存或者分享出去';

  @override
  String get shareRetakeConfirmationCancelButtonText => '沒有，請留在當前頁面';

  @override
  String get shareRetakeConfirmationConfirmButtonText => '是的，重新拍照';

  @override
  String get shutterButtonLabelText => '拍照';

  @override
  String get stickersNextButtonLabelText => '創建最終版的照片';

  @override
  String get dashButtonLabelText => '添加朋友 dash';

  @override
  String get sparkyButtonLabelText => '添加朋友 sparky';

  @override
  String get dinoButtonLabelText => '添加朋友 dino';

  @override
  String get androidButtonLabelText => '添加朋友 android jetpack';

  @override
  String get addStickersButtonLabelText => '添加貼圖';

  @override
  String get retakePhotoButtonLabelText => '重拍';

  @override
  String get clearAllStickersButtonLabelText => '清除所有貼圖';
}
