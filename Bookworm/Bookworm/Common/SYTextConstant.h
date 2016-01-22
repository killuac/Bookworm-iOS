//
//  SYTextConstant.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#ifndef Bookworm_SYTextConstant_h
#define Bookworm_SYTextConstant_h

#define NAV_TITLE_MOBILE_SIGNUP         LocalizedString(@"MobileSignUp", @"手机号注册")
#define NAV_TITLE_EMAIL_SIGNUP          LocalizedString(@"EmailSignUp", @"邮箱注册")
#define NAV_TITLE_SET_PASSWORD          LocalizedString(@"SetPassword", @"设置密码")
#define NAV_TITLE_EDIT_PROFILE          LocalizedString(@"EditProfile", @"编辑资料")
#define NAV_TITLE_CHANGE_NICKNAME       LocalizedString(@"ChangeNickname", @"更改昵称")
#define NAV_TITLE_CHANGE_PASSWORD       LocalizedString(@"ChangePassword", @"更改密码")

#define TAB_TITLE_HOME                  LocalizedString(@"Home", @"书虫")
#define TAB_TITLE_ACTIVITY              LocalizedString(@"Activity", @"动态")
#define TAB_TITLE_MESSAGE               LocalizedString(@"Message", @"消息")
#define TAB_TITLE_ME                    LocalizedString(@"Me", @"我的")

#define BUTTON_TITLE_YES                LocalizedString(@"Yes", @"是")
#define BUTTON_TITLE_NO                 LocalizedString(@"No", @"否")
#define BUTTON_TITLE_CANCEL             LocalizedString(@"Cancel", @"取消")
#define BUTTON_TITLE_DONE               LocalizedString(@"Done", @"完成")
#define BUTTON_TITLE_OKAY               LocalizedString(@"Okay", @"好的")
#define BUTTON_TITLE_EXIT               LocalizedString(@"Exit", @"退出")
#define BUTTON_TITLE_SAVE               LocalizedString(@"Save", @"保存")
#define BUTTON_TITLE_SEND               LocalizedString(@"Send", @"发送")
#define BUTTON_TITLE_SIGNIN             LocalizedString(@"SignIn", @"登录")
#define BUTTON_TITLE_SIGNUP             LocalizedString(@"SignUp", @"注册")
#define BUTTON_TITLE_SIGNOUT            LocalizedString(@"SignOut", @"退出登录")
#define BUTTON_TITLE_NEXT               LocalizedString(@"Next", @"下一步")
#define BUTTON_TITLE_SKIP               LocalizedString(@"Skip", @"跳过")
#define BUTTON_TITLE_SETTING            LocalizedString(@"Setting", @"设置")
#define BUTTON_TITLE_SEND_SMS_CODE      LocalizedString(@"SendSMS", @"获取验证码")
#define BUTTON_TITLE_RESEND             LocalizedString(@"Resend", @"重新获取")
#define BUTTON_TITLE_REMAIMING_TIME     LocalizedString(@"RemainingTime", @"剩余%.f秒")
#define BUTTON_TITLE_EMAIL_SIGNUP       LocalizedString(@"EmailSignUp", @"邮箱注册")
#define BUTTON_TITLE_NO_SMS_CODE        LocalizedString(@"NoSMSCode", @"没收到验证码?")
#define BUTTON_TITLE_FORGOT_PASSWORD    LocalizedString(@"ForgotPassword", @"忘记密码?")
#define BUTTON_TITLE_DELETE             LocalizedString(@"Delete", @"删除")
#define BUTTON_TITLE_REFRESH            LocalizedString(@"Refresh", @"刷新")
#define BUTTON_TITLE_FOLLOW             LocalizedString(@"Follow", @"关注")
#define BUTTON_TITLE_UNFOLLOW           LocalizedString(@"Unfollow", @"取消关注")
#define BUTTON_TITLE_EXCHANGE           LocalizedString(@"Exchange", @"交换")
#define BUTTON_TITLE_CHAT               LocalizedString(@"Chat", @"私聊")
#define BUTTON_TITLE_PLAY               LocalizedString(@"Play", @"播放")
#define BUTTON_TITLE_RATING             LocalizedString(@"Rating", @"评分")
#define BUTTON_TITLE_REPORT             LocalizedString(@"Report", @"举报")
#define BUTTON_TITLE_SHARE              LocalizedString(@"Share", @"分享")
#define BUTTON_TITLE_WEIBO              LocalizedString(@"Weibo", @"新浪微博")
#define BUTTON_TITLE_WECHAT             LocalizedString(@"Wechat", @"朋友圈")
#define BUTTON_TITLE_QZONE              LocalizedString(@"Qzone", @"QQ空间")
#define BUTTON_TITLE_TAKE_PHOTO         LocalizedString(@"TakePhoto", @"拍照")
#define BUTTON_TITLE_SELECT_FROM_ALBUM  LocalizedString(@"SelectFromAlbum", @"从手机相册选择")
#define BUTTON_TITLE_SET_CHAT_BG        LocalizedString(@"SetChatBackground", @"设置当前聊天背景")
#define BUTTON_TITLE_RESTORE_DEFAULT_BG LocalizedString(@"RestoreDefaultBackground", @"恢复默认背景")

#define HUD_CLEARING_CACHE              LocalizedString(@"ClearingCache", @"正在清除缓存...")
#define HUD_CACHE_CLEAR_DONE            LocalizedString(@"CacheClearDone", @"缓存已清除")
#define HUD_NETWORK_UNSTABLE            LocalizedString(@"NetworkUnstable", @"你当前的网络不稳定，请切换网络。")
#define HUD_CANNOT_CONNECT_TO_HOST      LocalizedString(@"CannotConnectToHost", @"服务器正在维护中，请稍后再试。")
#define HUD_NOT_CONNECTED_TO_INTERNET   LocalizedString(@"NotConnectedToInternet", @"似乎已断开与互联网的连接")
#define HUD_CONNECTING_IM_SERVER        LocalizedString(@"ConnectingIMServer", @"收取中...")
#define HUD_MOBILE_INVALID              LocalizedString(@"MobileInvalid", @"手机号码无效")
#define HUD_MOBILE_TAKEN                LocalizedString(@"MobileTaken", @"手机号码已经被注册")
#define HUD_MOBILE_NOT_FOUND            LocalizedString(@"MobileNotFound", @"手机号码尚未注册")
#define HUD_EMAIL_INVALID               LocalizedString(@"EmailInvalid", @"邮箱地址无效")
#define HUD_EMAIL_TAKEN                 LocalizedString(@"EmailTaken", @"邮箱已经被注册")
#define HUD_EMAIL_TOO_LONG              LocalizedString(@"EmailTooLong", @"邮箱长度不能大于32位")
#define HUD_EMAIL_NOT_FOUND             LocalizedString(@"EmailNotFound", @"邮箱尚未注册")
#define HUD_PASSWORD_WRONG              LocalizedString(@"PasswordWrong", @"密码错误")
#define HUD_PASSWORD_TOO_SHORT          LocalizedString(@"PasswordTooShort", @"密码长度不能小于6位")
#define HUD_PASSWORD_INVALID            LocalizedString(@"PasswordInvalid", @"密码含有非法字符")
#define HUD_SMS_CODE_WRONG              LocalizedString(@"SMSCodeWrong", @"验证码错误")
#define HUD_NICKNAME_TOO_LONG           LocalizedString(@"NicknameTooLong", @"昵称长度不能大于32位")
#define HUD_SIGNING_IN                  LocalizedString(@"SigningIn", @"登录中...")
#define HUD_CREATING_USER               LocalizedString(@"CreatingUser", @"账号创建中...")
#define HUD_THANKS_FEEDBACK             LocalizedString(@"ThanksFeedback", @"感谢您对“书虫”的支持")

#define TITLE_SETTING                   LocalizedString(@"Setting", @"设置")
#define TITLE_KICK_OUT                  LocalizedString(@"KickOut", @"注销")
#define TITLE_VERSION_ERROR             LocalizedString(@"VersionError", @"版本错误")

#define MSG_ACCESS_PHOTOS_SETTING       LocalizedString(@"AccessPhotosSetting", @"请在手机的“设置-隐私-照片”选项中，允许”书虫“访问你的手机相册。")
#define MSG_ACCESS_CAMERA_SETTING       LocalizedString(@"AccessCameraSetting", @"请在手机的“设置-隐私-相机”选项中，允许”书虫“访问你的手机相机。")
#define MSG_ACCESS_MICROPHONE_SETTING   LocalizedString(@"AccessMicrophoneSetting", @"请在手机的“设置-隐私-麦克风”选项中，允许”书虫“访问你的麦克风。")
#define MSG_ASK_FOR_SIGN_OUT            LocalizedString(@"AskForSignOut", @"确定退出登录？")
#define MSG_SIGNIN_AGAIN                LocalizedString(@"SignInAgain", @"账号已在其他设备登录，请重新登录。")
#define MSG_APP_VERSION_UNAVAILABLE     LocalizedString(@"AppVersionUnavailable", @"你的App版本过低，请到App Store更新。")

#define TEXT_GENDER_MALE                LocalizedString(@"Male", @"男")
#define TEXT_GENDER_FEMALE              LocalizedString(@"Female", @"女")
#define TEXT_USER_AGREEMENT             LocalizedString(@"UserAgreement", @"用户协议")
#define TEXT_AGREE_USER_AGREEMENT       LocalizedString(@"AgreeUserAgreement", @"点击\"注册\"表示已阅读并同意")
#define TEXT_SINGLE_TAP_REFRESH         LocalizedString(@"SingleTapRefresh", @"点击屏幕重新加载")

#define PH_REPORT_OTHER_REASON          LocalizedString(@"ReportOtherReason", @"其他原因...")
#define PH_FEEDBACK                     LocalizedString(@"Feedback", @"请写下关于“书虫”的意见和建议，我们将不断完善，感谢您的支持！")

#endif
