//
//  CustomAlert.h
//  AlertDemo
//
//  Created by yangxl on 2017/9/13.
//  Copyright © 2017年 yangxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomAlert;
@protocol CustomAlertDelegate <NSObject>
@optional
- (void)CustomAlertView:(CustomAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end



typedef NS_ENUM(NSInteger, CustomAlertViewStyle) {
    CustomAlertViewStyleDefault = 0
};


@interface CustomAlert : UIView
+(instancetype)customAlert;
- (void)showMag:(NSString *)msg;
@property (nonatomic, weak) id<CustomAlertDelegate> delegate;

/**
 初始化一个弹框提示

 @param title 标题
 @param message 信息
 @return alert
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)mDelegate styleAlert:(CustomAlertViewStyle)styleAlert buttonTitles:(NSString *)buttonTitles, ...;

-(void)show;

@end
