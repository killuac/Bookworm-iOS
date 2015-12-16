//
//  SYConstant.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SYUtility.h"
#import "SYTextConstant.h"

#ifndef SYConstant_h
#define SYConstant_h

typedef void (^SYNoParameterBlockType)(void);

//#define TEST_MODE

#define IS_IOS_VERSION_9                __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
#define APP_VERSION                     [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"]
#define APP_DISPLAY_NAME                [NSBundle mainBundle].localizedInfoDictionary[@"CFBundleDisplayName"]
#define RESOLUTION_SIZE                 [UIScreen mainScreen].preferredMode.size
#define RESOLUTION_WIDTH                RESOLUTION_SIZE.width
#define RESOLUTION_HEIGHT               RESOLUTION_SIZE.height
#define SCREEN_SCALE                    [UIScreen mainScreen].scale
#define SCREEN_BOUNDS                   [UIScreen mainScreen].bounds
#define SCREEN_SIZE                     SCREEN_BOUNDS.size
#define SCREEN_WIDTH                    SCREEN_SIZE.width
#define SCREEN_HEIGHT                   SCREEN_SIZE.height
#define SCREEN_CENTER                   CGPointMake(CGRectGetMidX(SCREEN_BOUNDS), CGRectGetMidY(SCREEN_BOUNDS))

#define DECLARE_WEAK_SELF               __weak typeof(self) weakSelf = self
#define RADIANS(degree)                 degree * M_PI/180

#define DATABASE_FILE_PATH              CacheFilePath(@"Bookworm.db")
#define REFERER_PREFIX                  @"http://www.bookworm.com/api/%@/%@"

#define IDENTIFIER_COMMON_CELL          @"CommonCell"
#define IDENTIFIER_EDITABLE_CELL        @"EditableCell"
#define IDENTIFIER_BUTTON_CELL          @"ButtonCell"

#define IMG_EMPTY                       [UIImage imageNamed:@"image_empty.png"]
#define IMG_DEFAULT_PLACEHOLDER         [UIImage imageNamed:@"image_default.png"]
#define IMG_LOAD_FAILED                 [UIImage imageNamed:@"image_load_failed.png"]
#define IMG_OFFICIAL_AVATAR             [UIImage imageNamed:@"image_official_avatar.png"]
#define IMG_GENDER_ICON(gender)         [UIImage imageNamed:(gender) ? @"icon_male.png" : @"icon_female.png"]
#define IMG_AVATAR_PLACEHOLDER(gender)  [UIImage imageNamed:(gender) ? @"image_male_avatar.png" : @"image_female_avatar.png"]

#define DEFAULT_MARGIN                  15.0
#define DEFAULT_HEADER_HEIGHT           20.0
#define DEFAULT_FOOTER_HEIGHT           20.0
#define DEFAULT_ROW_HEIGHT              44.0
#define DEFAULT_TOOLBAR_HEIGHT          44.0
#define DEFAULT_BUTTON_HEIGHT           44.0
#define BUTTON_CORNER_RADIUS            5.0
#define CELL_CORNER_RADIUS              5.0
#define DEFAULT_ANIMATION_DURATION      0.25
#define DEFAULT_DAMPING                 0.25
#define DEFAULT_BORDER_WIDTH            2.0

#define LocalizedString(key, text)      [[NSBundle mainBundle] localizedStringForKey:(key) value:text table:nil]

#endif /* SYConstant_h */
