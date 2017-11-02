//
//  CDInteractiveItem.h
//  ConnectNetwork
//
//  Created by Carlos Duclos on 7/20/17.
//  Copyright © 2017 GTL Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  CDInteractiveItem : NSObject

@property (nonatomic) NSRange range;
@property (nonatomic, copy) void (^tapActionBlock)(void);

@end

