//
//  CustomAlert.h
//  AlertDemo
//
//  Created by yangxl on 2017/9/13.
//  Copyright © 2017年 yangxl. All rights reserved.
//


#import "CustomAlert.h"
#define MarginTop 5
#define MainScreenBounds [[UIScreen mainScreen] bounds]
@interface CustomAlert ()

@property (nonatomic, strong)   NSString *aTitle;
@property (nonatomic, strong)   NSString *aMessage;
@property (nonatomic, strong)   NSMutableArray *buttons;
@property (nonatomic, strong)   UIView *background;

@end

@implementation CustomAlert
@synthesize buttons,aTitle,aMessage;
@synthesize delegate,background;


+(instancetype)customAlert{
    static CustomAlert *_customAlert ;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _customAlert = [[self alloc] init];
    });
    
    return _customAlert;
}

/**
 初始化一个弹框提示
 
 @param title 标题
 @param message 信息
 @return alert
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)mDelegate styleAlert:(CustomAlertViewStyle)styleAlert buttonTitles:(NSString *)buttonTitles, ...
{
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth(MainScreenBounds) * 0.8, 100)];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [[self layer] setCornerRadius:5.0f];
        delegate = mDelegate;
        aTitle = title;
        aMessage = message;
        va_list args;
        va_start(args, buttonTitles);
        buttons = [NSMutableArray array];
        for (NSObject *btnTitle = buttonTitles; btnTitle != nil; btnTitle = va_arg(args, NSObject *)) {
            [buttons addObject:btnTitle];
        }
        va_end(args);
        [self initUI_alertStye:styleAlert];
    }
    
    return self;
}

-(void)initUI_alertStye:(CustomAlertViewStyle)alertStye
{
    
    switch (alertStye) {
        case CustomAlertViewStyleDefault:
        {
            [self getUiFrameDefult];
        }
            break;
            
        default:
            break;
    }

}

-(CAShapeLayer *)getCornerLayer:(CGRect)frame bounds:(CGRect)bounds cornerDir:(UIRectCorner)cornerDir
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:cornerDir cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}

-(void)buttonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag - 9000;
    [self dismissWithClickedButtonIndex:index];
}

-(void)show
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [self showInView:keyWindow];
}
-(void)showInView:(UIView *)view
{
    if (view == nil) {
        return;
    }
    CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
    background = [[UIView alloc] initWithFrame:mainScreenFrame];
    [background setAlpha:0.0f];
    [background setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5]];
    [view addSubview:background];
    
    [self setCenter:CGPointMake(CGRectGetWidth(mainScreenFrame) / 2, CGRectGetHeight(mainScreenFrame))];
    [view addSubview:self];
    [UIView animateWithDuration:0.3f animations:^{
        [background setAlpha:1.0f];
        [self setCenter:CGPointMake(CGRectGetWidth(mainScreenFrame) / 2, CGRectGetHeight(mainScreenFrame) / 2)];
    }];
}
-(void)dismissWithClickedButtonIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [[self delegate] CustomAlertView:self clickedButtonAtIndex:index];
    }
    __weak typeof(self) weakSelf = self;
    CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
    [UIView animateWithDuration:0.3f animations:^{
        [background setAlpha:0.0f];
        [weakSelf setCenter:CGPointMake(CGRectGetWidth(mainScreenFrame) / 2, CGRectGetHeight(mainScreenFrame))];
    } completion:^(BOOL finished) {
        [background removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

-(void)dismissDeleteWithClickedButton
{
    __weak typeof(self) weakSelf = self;
    
    [background removeFromSuperview];
    [weakSelf removeFromSuperview];
}


-(void)dealloc
{
    self.delegate = nil;
}


/**
 画风格的uialert
 */
-(void)getUiFrameDefult
{
    UILabel *titleLb = [[UILabel alloc] init];
    [self addSubview:titleLb];
    if (aTitle != nil) {
        [titleLb setFrame:CGRectMake(0, MarginTop, CGRectGetWidth(self.frame), 20)];
        [titleLb setTextAlignment:NSTextAlignmentCenter];
        [titleLb setFont:[UIFont systemFontOfSize:16]];
        [titleLb setText:aTitle];
    }
    
    UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLb.frame) + MarginTop, 0, 0)];
    [self addSubview:content];
    if (aMessage != nil) {
        [content setNumberOfLines:0];
        content.textAlignment = NSTextAlignmentCenter;
        [content setLineBreakMode:NSLineBreakByWordWrapping];
        [content setFont:[UIFont systemFontOfSize:14]];
        CGFloat messageHeight = [self sizeOfString:aMessage fontSize:14 heightOrWidth:NO otherLimts:CGRectGetWidth(self.frame) - 40].size.height + 20;
        
        [content setFrame:CGRectMake(10, CGRectGetHeight(titleLb.frame) + MarginTop, CGRectGetWidth(self.frame) - 20, messageHeight)];
        NSRange range = [aMessage rangeOfString:@"登录电脑端"];
        if (range.length > 0) {
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:aMessage];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:67.0/255 blue:54.0/255 alpha:1.0] range:range];
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
            style.alignment = NSTextAlignmentCenter;
            [attrStr addAttribute:NSParagraphStyleAttributeName value:style range:range];
            
            [content setAttributedText:attrStr];
        }else{
            [content setText:aMessage];
        }
    }
    
    UIView *buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(content.frame) + MarginTop, CGRectGetWidth(self.frame), 44)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(buttonContainer.frame), 1)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [buttonContainer addSubview:line];
    [self addSubview:buttonContainer];
    NSInteger count = [buttons count] > 3 ? 3 : [buttons count];
    CGFloat buttonWidth = (CGRectGetWidth(buttonContainer.frame) - (count - 1))/ count;
    for (int i = 0; i < count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*(buttonWidth+1), 1, buttonWidth, CGRectGetHeight(buttonContainer.frame)-1)];
        if (i == 0) {
            button.layer.mask = [self getCornerLayer:button.frame bounds:button.bounds cornerDir:UIRectCornerBottomLeft];
        }
        
        if (i == count - 1) {
            CGRect frame = button.frame;
            frame.origin.x = 0;
            frame.origin.y = 0;
            
            CGRect bounds = button.bounds;
            bounds.origin.x = 0;
            bounds.origin.y = 0;
            
            button.layer.mask = [self getCornerLayer:frame bounds:bounds cornerDir:UIRectCornerBottomRight];
        }
        [button setTitle:[buttons objectAtIndex:i] forState:UIControlStateNormal];
        [button setTag:9000+i];
        [button setTitleColor:[UIColor colorWithRed:0 green:122.0/255 blue:225.0/255 alpha:1.0f] forState:UIControlStateNormal];
        [[button titleLabel] setFont:[UIFont systemFontOfSize:14]];
        [button setBackgroundImage:[UIImage imageNamed:@"alert_btn_bg_h"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonContainer addSubview:button];
        // 添加分隔线
        if (i < count - 1) {
            UIView *buttonLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), 2, 1, CGRectGetHeight(button.frame)-4)];
            [buttonLine setBackgroundColor:[UIColor colorWithRed:201.0/255 green:201.0/255 blue:201.0/255 alpha:1.0]];
            [buttonContainer addSubview:buttonLine];
        }
    }
    
    CGRect selfFrame = self.frame;
    selfFrame.size.height = CGRectGetMaxY(buttonContainer.frame);
    [self setFrame:selfFrame];
}


- (void)showMag:(NSString *)msg{
    UILabel *content = [UILabel new];
    [self addSubview:content];
    if (msg != nil) {
        [content setNumberOfLines:0];
        [content setLineBreakMode:NSLineBreakByWordWrapping];
        content.text = msg;
        content.textColor = [UIColor whiteColor];
        [content setFont:[UIFont systemFontOfSize:14]];
        
        CGRect rect = [self getLabelheightSize:msg];
        
        [content setFrame:CGRectMake(MarginTop, MarginTop, rect.size.width, rect.size.height)];
        
        
        //计算文本大小
    }else{
        content.text = @"";
    }
    
    
    self.backgroundColor = [UIColor blackColor];
    
    self.layer.contentsScale = 5;
    
    //设置现在的视图大小
    CGRect selfFrame = self.frame;
    selfFrame.size.height = CGRectGetMaxY(content.frame)+5;
    selfFrame.size.width = CGRectGetMaxX(content.frame)+5;
    [self setFrame:selfFrame];
    
    
    
    [self setCenter:CGPointMake(CGRectGetWidth(MainScreenBounds) / 2, CGRectGetHeight(MainScreenBounds)/2)];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    [keyWindow addSubview:self];
    
    
    self.layer.cornerRadius = 5;
    
    
    
    //设置动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationStep2)];
    self.alpha = 0.8;
    [UIView commitAnimations];
    
    
    
    
}
-(void)getUiFrameSimpleStype:(NSInteger)stype
{
    //防止用户重复点击或者多次提示
//    if (self != nil) {
//        return;
//    }
    
    
    
    
    UILabel *content = [UILabel new];
    [self addSubview:content];
    if (aMessage != nil) {
        [content setNumberOfLines:0];
        [content setLineBreakMode:NSLineBreakByWordWrapping];
        content.text = aMessage;
        [content setFont:[UIFont systemFontOfSize:14]];
        
        CGRect rect = [self sizeOfString:aTitle fontSize:14 heightOrWidth:NO otherLimts:CGFLOAT_MAX];
        
        [content setFrame:CGRectMake(0, MarginTop, CGRectGetWidth(self.frame), rect.size.height)];
        
        
        //计算文本大小
    }else{
        content.text = @"";
    }
    
    
    
    //设置现在的视图大小
    CGRect selfFrame = self.frame;
    selfFrame.size.height = CGRectGetMaxY(content.frame);
    [self setFrame:selfFrame];
    
    
    
}

- (void) animationStep2{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationStep3)];
    self.alpha = 0;
    [UIView commitAnimations];
}

- (void) animationStep3{
    
    [self removeFromSuperview];
    
}


/**
 计算长度

 @return 宽度
 */
-(CGRect)sizeOfString:(NSString *)value fontSize:(float)fontSize heightOrWidth:(BOOL)isHeight otherLimts:(CGFloat)limits
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize rectSize = CGSizeZero;
    if (isHeight) {
        rectSize = CGSizeMake(limits, CGFLOAT_MAX);
        
    }else{
        rectSize = CGSizeMake(CGFLOAT_MAX, limits);
    }
    return [value boundingRectWithSize:rectSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
}

- (CGRect) getLabelheightSize:(NSString *)txt{
    
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGRect rect = [txt boundingRectWithSize:CGSizeMake(MainScreenBounds.size.width-10 , 200000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect;
}

@end

