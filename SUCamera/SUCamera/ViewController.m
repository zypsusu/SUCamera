//
//  ViewController.m
//  SUCamera
//
//  Created by zypsusu on 2017/7/31.
//  Copyright © 2017年 zypsusu. All rights reserved.
//

#import "ViewController.h"
#import "RecordViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)showRecod:(id)sender {
    RecordViewController *recodVC = [[RecordViewController alloc] initWithNibName:@"RecordViewController" bundle:nil];
    [self.navigationController pushViewController:recodVC animated:YES];
}

@end
