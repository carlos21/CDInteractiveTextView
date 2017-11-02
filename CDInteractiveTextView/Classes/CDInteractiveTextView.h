//
//  CDInteractiveTextView.h
//  Pods
//
//  Created by Carlos Duclos on 7/20/17.
//
//

#import <UIKit/UIKit.h>

@interface CDInteractiveTextView : UITextView<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIColor *interactiveColor;
@property (nonatomic, strong) UIColor *interactiveHighlightedColor;

- (void)addTapActionWithText:(NSString *)text withActionBlock:(void (^)(void))actionBlock;
- (void)addTapActionWithRange:(NSRange)range withActionBlock:(void (^)(void))actionBlock;

@end
