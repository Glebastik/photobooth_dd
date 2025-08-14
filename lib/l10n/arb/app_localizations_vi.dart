// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get landingPageHeading =>
      'Chào mừng đã đến với tới buồng chụp ảnh I∕O';

  @override
  String get landingPageSubheading => 'Chụp ảnh và chia sẻ với cộng đồng!';

  @override
  String get landingPageTakePhotoButtonText => 'Bắt đầu';

  @override
  String get footerMadeWithText => 'Làm bởi ';

  @override
  String get footerMadeWithFlutterLinkText => 'Flutter';

  @override
  String get footerMadeWithFirebaseLinkText => 'Firebase';

  @override
  String get footerGoogleIOLinkText => 'Google I∕O';

  @override
  String get footerCodelabLinkText => 'Codelab';

  @override
  String get footerHowItsMadeLinkText => 'Nó được làm như thế nào';

  @override
  String get footerTermsOfServiceLinkText => 'Điều khoản dịch vụ';

  @override
  String get footerPrivacyPolicyLinkText => 'Chính sách bảo mật';

  @override
  String get sharePageHeading => 'Chia sẻ ảnh của bạn với cộng đồng!';

  @override
  String get sharePageSubheading => 'Chia sẻ ảnh của bạn với cộng đồng!';

  @override
  String get sharePageSuccessHeading => 'Chia sẻ ảnh!';

  @override
  String get sharePageSuccessSubheading =>
      'Cảm ơn vì đã sử dụng Flutter web app! Ảnh của bạn đã được xuất bản tại URL này';

  @override
  String get sharePageSuccessCaption1 =>
      'Ảnh của bạn sẽ có sẵn tại URL trong 30 ngày và sau đó tự động bị xóa. Để yêu cầu xóa sớm ảnh của bạn, vui lòng liên hệ ';

  @override
  String get sharePageSuccessCaption2 => 'flutter-photo-booth@google.com';

  @override
  String get sharePageSuccessCaption3 =>
      ' và hãy chắc chắn bao gồm URL duy nhất của bạn trong yêu cầu của bạn.';

  @override
  String get sharePageRetakeButtonText => 'Chụp ảnh mới';

  @override
  String get sharePageShareButtonText => 'Chia sẻ';

  @override
  String get sharePageDownloadButtonText => 'Tải xuống';

  @override
  String get socialMediaShareLinkText =>
      'Chỉ cần chụp ảnh tự sướng tại #IOPhotoBooth. Hẹn gặp bạn tại #GoogleIO!';

  @override
  String get previewPageCameraNotAllowedText =>
      'Bạn đã từ chối quyền camera.Vui lòng cấp quyền truy cập để sử dụng ứng dụng.';

  @override
  String get sharePageSocialMediaShareClarification1 =>
      'Nếu bạn chọn chia sẻ ảnh của mình trên phương tiện truyền thông xã hội, nó sẽ có sẵn tại một URL duy nhất trong 30 ngày và sau đó tự động bị xóa. Ảnh không được chia sẻ, không được lưu trữ. Để yêu cầu xóa sớm ảnh của bạn, vui lòng liên hệ ';

  @override
  String get sharePageSocialMediaShareClarification2 =>
      'flutter-photo-booth@google.com';

  @override
  String get sharePageSocialMediaShareClarification3 =>
      ' và hãy chắc chắn bao gồm URL duy nhất của bạn trong yêu cầu của bạn.';

  @override
  String get sharePageCopyLinkButton => 'Sao chép';

  @override
  String get sharePageLinkedCopiedButton => 'Đã sao chép.';

  @override
  String get sharePageErrorHeading =>
      'Chúng tôi đang gặp sự cố khi xử lý hình ảnh của bạn';

  @override
  String get sharePageErrorSubheading =>
      'Vui lòng đảm bảo thiết bị và trình duyệt của bạn được cập nhật. Nếu vấn đề này vẫn còn, xin vui lòng liên hệ flutter-photo-booth@google.com.';

  @override
  String get shareDialogHeading => 'Chia sẻ ảnh của bạn!';

  @override
  String get shareDialogSubheading =>
      'Hãy để mọi người biết bạn đang ở Google I∕O bằng cách chia sẻ ảnh của bạn và cập nhật ảnh hồ sơ của bạn trong sự kiện!';

  @override
  String get shareErrorDialogHeading => 'Oops!';

  @override
  String get shareErrorDialogTryAgainButton => 'Quay lại';

  @override
  String get shareErrorDialogSubheading =>
      'Một cái gì đó đã sai và chúng tôi không thể tải ảnh của bạn.';

  @override
  String get sharePageProgressOverlayHeading =>
      'Chúng tôi đang làm cho pixel ảnh của bạn hoàn hảo với Flutter!';

  @override
  String get sharePageProgressOverlaySubheading =>
      'Xin vui lòng không đóng tab này.';

  @override
  String get shareDialogTwitterButtonText => 'Twitter.';

  @override
  String get shareDialogFacebookButtonText => 'Facebook';

  @override
  String get photoBoothCameraAccessDeniedHeadline =>
      'Truy cập camera bị từ chối';

  @override
  String get photoBoothCameraAccessDeniedSubheadline =>
      'Để chụp ảnh, bạn phải cho phép trình duyệt truy cập vào máy ảnh của bạn.';

  @override
  String get photoBoothCameraNotFoundHeadline =>
      'Chúng tôi không thể tìm thấy máy ảnh của bạn';

  @override
  String get photoBoothCameraNotFoundSubheadline1 =>
      'Có vẻ như thiết bị của bạn không có máy ảnh hoặc nó không hoạt động.';

  @override
  String get photoBoothCameraNotFoundSubheadline2 =>
      'Để chụp ảnh, xin vui lòng truy cập buồng chụp ảnh I∕O từ một thiết bị có camera.';

  @override
  String get photoBoothCameraErrorHeadline => 'Oops! Đã xảy ra lỗi';

  @override
  String get photoBoothCameraErrorSubheadline1 =>
      'Vui lòng làm mới trình duyệt của bạn và thử lại.';

  @override
  String get photoBoothCameraErrorSubheadline2 =>
      'Nếu vấn đề này vẫn còn, xin vui lòng liên hệ flutter-photo-booth@google.com';

  @override
  String get photoBoothCameraNotSupportedHeadline => 'Oops! Đã xảy ra lỗi';

  @override
  String get photoBoothCameraNotSupportedSubheadline =>
      'Vui lòng đảm bảo thiết bị và trình duyệt của bạn được cập nhật.';

  @override
  String get stickersDrawerTitle => 'Thêm sticker';

  @override
  String get openStickersTooltip => 'Thêm sticker';

  @override
  String get retakeButtonTooltip => 'Chụp lại';

  @override
  String get clearStickersButtonTooltip => 'Xoá sticker';

  @override
  String get charactersCaptionText => 'Thêm bạn bè';

  @override
  String get sharePageLearnMoreAboutTextPart1 => 'Học nhiều hơn về ';

  @override
  String get sharePageLearnMoreAboutTextPart2 => ' và ';

  @override
  String get sharePageLearnMoreAboutTextPart3 => ' hoặc lặn ngay vào ';

  @override
  String get sharePageLearnMoreAboutTextPart4 => 'open source code';

  @override
  String get goToGoogleIOButtonText => 'Đi đến Google I∕O';

  @override
  String get clearStickersDialogHeading => 'Xóa tất cả các sticker?';

  @override
  String get clearStickersDialogSubheading =>
      'Bạn có muốn loại bỏ tất cả các sticker ra khỏi màn hình?';

  @override
  String get clearStickersDialogCancelButtonText => 'Không, đưa tôi về';

  @override
  String get clearStickersDialogConfirmButtonText =>
      'Vâng, xóa tất cả các sticker';

  @override
  String get propsReminderText => 'Thêm một số sticker';

  @override
  String get stickersNextConfirmationHeading =>
      'Sẵn sàng để xem ảnh cuối cùng?';

  @override
  String get stickersNextConfirmationSubheading =>
      'Khi bạn rời khỏi màn hình này, bạn sẽ không thể thực hiện bất kỳ thay đổi nào';

  @override
  String get stickersNextConfirmationCancelButtonText =>
      'Không, tôi vẫn đang tạo ra';

  @override
  String get stickersNextConfirmationConfirmButtonText =>
      'Vâng, hãy cho tôi xem';

  @override
  String get stickersRetakeConfirmationHeading => 'Bạn có chắc không?';

  @override
  String get stickersRetakeConfirmationSubheading =>
      'Lấy lại ảnh sẽ loại bỏ bất kỳ sticker nào bạn đã thêm';

  @override
  String get stickersRetakeConfirmationCancelButtonText => 'Không, ở lại đây';

  @override
  String get stickersRetakeConfirmationConfirmButtonText => 'Có, phát lại ảnh';

  @override
  String get shareRetakeConfirmationHeading => 'Sẵn sàng để chụp ảnh mới?';

  @override
  String get shareRetakeConfirmationSubheading =>
      'Hãy nhớ tải về hoặc chia sẻ ảnh';

  @override
  String get shareRetakeConfirmationCancelButtonText => 'Không, ở lại đây';

  @override
  String get shareRetakeConfirmationConfirmButtonText => 'Có, chụp ảnh lại';

  @override
  String get shutterButtonLabelText => 'Chụp hình';

  @override
  String get stickersNextButtonLabelText => 'Tạo ảnh cuối cùng';

  @override
  String get dashButtonLabelText => 'Thêm bạn Dash.';

  @override
  String get sparkyButtonLabelText => 'Thêm bạn Sparky';

  @override
  String get dinoButtonLabelText => 'Thêm bạn Dino';

  @override
  String get androidButtonLabelText => 'Thêm bạn Jetpack Android';

  @override
  String get addStickersButtonLabelText => 'Thêm sticker';

  @override
  String get retakePhotoButtonLabelText => 'Chụp lại ảnh';

  @override
  String get clearAllStickersButtonLabelText => 'Xóa tất cả các sticker';
}
