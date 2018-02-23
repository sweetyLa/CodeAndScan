//
//  CodeViewController.m
//  CodeAndScan
//
//  Created by    apple on 2018/2/23.
//  Copyright © 2018年 sweety. All rights reserved.
//

#import "CodeViewController.h"
#import "UIImage+More.h"

@interface CodeViewController ()

@end

@implementation CodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"生成二维码";
    
    
    //以百度的url为例
    //根据url生成的二维码
    _codeImageView.image = [UIImage qrImageForString:@"https://www.baidu.com" imageSize:_codeImageView.frame.size.width logoImageSize:_codeImageView.frame.size.width*0.2];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
