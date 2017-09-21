//
//  YXLViewController.m
//  YXLCustomAlertView
//
//  Created by yangxl on 09/21/2017.
//  Copyright (c) 2017 yangxl. All rights reserved.
//

#import "YXLViewController.h"
#import "CustomAlert.h"
@interface YXLViewController ()


@end

@implementation YXLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBtn:(id)sender {
    [[CustomAlert customAlert] showMag:@"我是来测1233214567893651"];
}
- (IBAction)clickBtnXit:(id)sender {
    
    CustomAlert *alert = [[CustomAlert alloc]initWithTitle:@"提示" message:@"模拟系统化弹出框" delegate:self styleAlert:CustomAlertViewStyleDefault buttonTitles:@"OK",@"Canle",nil];
    [alert show];
    
}

@end
