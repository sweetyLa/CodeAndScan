//
//  UIImage+More.h
//  CodeAndScan
//
//  Created by    apple on 2018/2/23.
//  Copyright © 2018年 sweety. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (More)


//生成二维码
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize;

@end
