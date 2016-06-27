//
//  UIImage+Base.h
//  Bookworm
//
//  Created by Killua Liu on 12/31/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SYGenderType) {
    SYGenderTypeUnknown = 0,
    SYGenderTypeFemale = -1,
    SYGenderTypeMale = 1
};

NS_INLINE UIImage *SYImageEmpty() { return [UIImage imageNamed:@"image_empty.png"]; }
NS_INLINE UIImage *SYImagePlaceholder() { return [UIImage imageNamed:@"image_default.png"]; }
NS_INLINE UIImage *SYImageLoadFailed() { return [UIImage imageNamed:@"image_load_failed.png"]; }
NS_INLINE UIImage *SYImageOfficialAvatar() { return [UIImage imageNamed:@"image_official_avatar.png"]; }

NS_INLINE UIImage *SYImageIconByGender(SYGenderType gender) {
    if (gender == 0) return nil;
    return (gender > 0) ? [UIImage imageNamed:@"icon_male.png"] : [UIImage imageNamed:@"icon_female.png"];
}

NS_INLINE UIImage *SYImageAvatarByGender(SYGenderType gender) {
    if (gender == 0) return [UIImage imageNamed:@"image_default_avatar.png"];
    return (gender > 0) ? [UIImage imageNamed:@"image_male_avatar.png"] : [UIImage imageNamed:@"image_male_avatar.png"];
}

@interface UIImage (Base)

@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, assign, readonly) CGFloat height;

- (UIImage *)originalImage;
- (UIImage *)resizableCroppedImage; // Resize and crop in center

@end
