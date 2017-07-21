//
//  CDViewController.h
//  CDInteractiveTextView
//
//  Created by Carlos Duclos on 07/20/2017.
//  Copyright (c) 2017 Carlos Duclos. All rights reserved.
//

@import UIKit;
#import <CDInteractiveTextView/CDInteractiveTextView.h>

@interface CDViewController : UIViewController

@property (weak, nonatomic) IBOutlet CDInteractiveTextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end
