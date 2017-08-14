//
//  SampleEffectViewController.m
//  SUCamera
//
//  Created by zypsusu on 2017/8/4.
//  Copyright © 2017年 zypsusu. All rights reserved.
//

#import "SampleEffectViewController.h"
#import "GPUImage.h"
#import "Video.h"
#import "VideoPoint.h"

@interface SampleEffectViewController ()
@property (weak, nonatomic) IBOutlet GPUImageView *gpUImageView;
@property (nonatomic, strong) Video *video;
@property (nonatomic, strong) GPUImageMovie *movie;

@property (nonatomic, assign) NSInteger isPlay;
@end

@implementation SampleEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GPUImageMovie *movie = [[GPUImageMovie alloc] initWithURL:self.video.originURL];
    [movie addTarget:_gpUImageView];
    //movie.shouldRepeat = YES;
    _movie = movie;
}


- (IBAction)playButtonClick:(id)sender {
    _isPlay++;
    if (_isPlay%2) {
        [_movie startProcessing];
    }else {
        [_movie endProcessing];
    }
    
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withVideo:(Video *)video{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        self.video = video;
    }
    return self;
}
@end
