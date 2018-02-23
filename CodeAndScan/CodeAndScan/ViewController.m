//
//  ViewController.m
//  CodeAndScan
//
//  Created by    apple on 2018/2/23.
//  Copyright © 2018年 sweety. All rights reserved.
//

#import "ViewController.h"
#import "CodeViewController.h"
#import "ScanViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:self];
    [[UIApplication sharedApplication].delegate.window setRootViewController:nav];
    
    self.title = @"原生二维码";
    UITableView * mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self.view addSubview:mainTableView];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];

    }
    cell.textLabel.text = indexPath.row == 0?@"生成二维码":@"扫描二维码";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        //生成二维码
        CodeViewController * codeVC = [[CodeViewController alloc] initWithNibName:@"CodeViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:codeVC animated:YES];
    }
    else
    {
        //扫描二维码
        ScanViewController * scanVC = [[ScanViewController alloc] initWithNibName:@"ScanViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:scanVC animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
