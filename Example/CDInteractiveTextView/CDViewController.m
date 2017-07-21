//
//  CDViewController.m
//  CDInteractiveTextView
//
//  Created by Carlos Duclos on 07/20/2017.
//  Copyright (c) 2017 Carlos Duclos. All rights reserved.
//

#import "CDViewController.h"

@interface CDViewController ()

@end

@implementation CDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    NSString *text = @"Hello! I'm an awesome custom textview. As you can see, you are totally free to create tappable content and personalize your text in the way you want.";
    self.textView.text = text;
    self.textView.interactiveColor = [UIColor redColor];
    self.textView.interactiveHighlightedColor = [UIColor greenColor];
    
    NSRange range = [self.textView.text rangeOfString:@"awesome custom textview"];
    [self.textView addTapActionWithRange:range withActionBlock:^{
        NSLog(@"awesome custom textview ctm");
    }];
    
    [self.textView addTapActionWithText:@"you" withActionBlock:^{
        NSLog(@"tappable content ctm");
    }];
    
    NSInteger height = [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, CGFLOAT_MAX)].height;
    self.heightConstraint.constant = height;
    
}

@end
