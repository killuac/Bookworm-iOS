//
//  SYTextView.m
//  Bookworm
//
//  Created by Killua Liu on 1/22/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYTextView.h"

@implementation SYTextView

- (id)init
{
    if (self = [super init]) {
        [self addObservers];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addObservers];
    }
    return self;
}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder
{
    _attributedPlaceholder = attributedPlaceholder;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (self.hasText) return;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @" ";
    _attributedPlaceholder = textField.attributedPlaceholder;
    
    CGRect placeholderRect = CGRectInset(rect, 5, 8);
    NSMutableDictionary<NSString *, id> *attributes = [[_attributedPlaceholder attributesAtIndex:0 effectiveRange:NULL] mutableCopy];
    attributes[NSFontAttributeName] = self.font;
    if (self.placeholderColor) attributes[NSForegroundColorAttributeName] = self.placeholderColor;
    [self.placeholder drawInRect:placeholderRect withAttributes:attributes];
}

@end
