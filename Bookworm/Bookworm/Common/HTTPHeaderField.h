//
//  HTTPHeaderField.h
//  Bookworm
//
//  Created by Bing Liu on 1/19/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#ifndef HTTPHeaderField_h
#define HTTPHeaderField_h

#define kHTTPHeaderFieldReferer     @"Referer"
#define kHTTPHeaderFieldUserAgent   @"User-Agent"
#define kHTTPHeaderFieldIfNoneMatch @"If-None-Match"
#define kHTTPHeaderFieldETag        @"ETag"

#define kHTTPHeaderFieldAccessToken @"X-Access-Token"
#define kHTTPHeaderFieldIMServer    @"X-IM-Server"
#define kHTTPHeaderFieldHUDMessage  @"X-HUD-Message"
#define kHTTPHeaderFieldErrorCode   @"X-Error-Code"

typedef NS_ENUM(NSUInteger, SYHTTPErrorCode) {
    SYHTTPErrorCodeUnknow = 10000,
    SYHTTPErrorCodeSignatureError = 10001,
    SYHTTPErrorCodeMissingParameter = 10002,
    SYHTTPErrorCodeAccessTokenInvalid = 10003,
    SYHTTPErrorCodeAccountDisabled = 10004,
    SYHTTPErrorCodeAppVersionUnavailable= 10005
};

#endif /* HTTPHeaderField_h */
