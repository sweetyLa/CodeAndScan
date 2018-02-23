//
//  ScanViewController.m
//  CodeAndScan
//
//  Created by    apple on 2018/2/23.
//  Copyright © 2018年 sweety. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define UIColorFromHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureSession *session;//输入输出的中间桥梁
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *layer;// 扫描所在的层级
@property (nonatomic, retain) UIImageView *rectImage;// 扫描的方框
@property (nonatomic, retain) UIImageView *line;// 扫码区域的线条

// 用于扫码的线条动画
@property int num;
@property BOOL upOrdown;
@property NSTimer * timer;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"扫一扫";

    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadScanView];
            });
        } else {
            NSLog(@"无权限访问相机");
        }
    }];
    
}

- (void)loadScanView
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 设置扫码作用区域，参数是区域占全屏的比例,x、y颠倒，高宽颠倒来设置= =什么鬼
    [output setRectOfInterest:CGRectMake((kHeight - (kWidth - 60)-64)/2/kHeight, 30/kWidth, (kWidth - 60)/kHeight, (kWidth - 60)/kWidth)];
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [self.session addInput:input];
    [self.session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    self.layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    self.layer.frame=self.view.layer.bounds;// 设置照相显示的大小
    //    CGRect screenBounds = [ [ UIScreen mainScreen ] bounds ];
    //    self.layer.frame = CGRectMake(30, (screenBounds.size.height - (screenBounds.size.width - 60)) / 2, screenBounds.size.width - 60, screenBounds.size.width - 60);
    
    [self.view.layer insertSublayer:self.layer atIndex:2];// 设置层级，可以在扫码时显示一些文字
    
    //开始捕获
    [self.session startRunning];
    
    // 方框
    self.rectImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, (kHeight - (kWidth - 60)-64)/2, kWidth - 60, kWidth - 60)];
    self.rectImage.image = [UIImage imageNamed:@"icon_sao1_home"];
    [self.view addSubview:self.rectImage];
    
    
    // 线条动画
    self.upOrdown = NO;
    self.num =0;
    self.line = [[UIImageView alloc] initWithFrame:CGRectMake(70, (kHeight - (kWidth - 60)-64)/2 + 10, kWidth - 140, 6)];
    self.line.image = [UIImage imageNamed:@"icon_sao2_home"];
    [self.view addSubview:self.line];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation) userInfo:nil repeats:YES];
    
    UILabel * remarkLab = [[UILabel alloc] initWithFrame:CGRectMake(0, (kHeight - (kWidth - 60)-64)/2+kWidth - 60+10, kWidth, 13)];
    [remarkLab setText:@"将二维码放入取景框内即可自动扫描"];
    [remarkLab setTextColor:UIColorFromHex(0xFFFFFF)];
    [remarkLab setFont:[UIFont systemFontOfSize:12.f]];
    [remarkLab setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:remarkLab];
    
    
}

// 扫描线条动画
-(void)animation
{
    
    //    CGRect screenBounds = [ [ UIScreen mainScreen ] bounds ];
    if (self.upOrdown == NO) {
        self.num ++;
        self.line.frame = CGRectMake(70, (kHeight - (kWidth - 60)-64)/2 + 10 +2*self.num, kWidth - 140, 6);
        if (2*self.num == kWidth - 60-20) {
            self.upOrdown = YES;
        }
    }
    else {
        self.num --;
        self.line.frame = CGRectMake(70, (kHeight - (kWidth - 60)-64)/2 + 10 +2*self.num, kWidth - 140, 6);
        if (self.num == 0) {
            self.upOrdown = NO;
        }
    }
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        NSLog(@"输出扫描字符串====%@",metadataObject.stringValue);
        
        // 关闭扫描，退出扫描界面
        [self.session stopRunning];
        [self.layer removeFromSuperlayer];
        
        // 去掉扫描显示的内容
        [self.timer invalidate];
        [self.line removeFromSuperview];
        [self.rectImage removeFromSuperview];
    }
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
