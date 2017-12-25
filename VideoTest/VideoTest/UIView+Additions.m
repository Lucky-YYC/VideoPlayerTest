//
//  UIView+Additions.m
//  BabyPlay
//
//  Created by 符之飞 on 15/8/20.
//  Copyright (c) 2015年 符之飞. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)
-(UIViewController *)viewController{
    UIResponder * next = self.nextResponder;
    while (next != nil) {
        if ([next isKindOfClass:[UIViewController class]]){
            
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
    }
    
    return nil;
}
@end
