//
//  EffectViewController.m
//  SUCamera
//
//  Created by zypsusu on 2017/7/31.
//  Copyright © 2017年 zypsusu. All rights reserved.
//

#import "EffectViewController.h"
#import "Video.h"
#import "EffectTabView.h"
#import "RecordAudioProgressView.h"
#import "HMSegmentedControl.h"

#define RGB(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]

@interface EffectViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, weak) IBOutlet NSLayoutConstraint * bottomTop;
@property (weak, nonatomic) IBOutlet UIView *PasterEffectView;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlay;
@property (weak, nonatomic) IBOutlet UIView *buttonPlayView;
@property (nonatomic, weak) IBOutlet UIImageView * pasterNewImage;
//paster 引导
@property (nonatomic, weak) IBOutlet UIView * pasterGuideView;
@property (nonatomic, weak) IBOutlet UIView * guide_VideoView;
@property (nonatomic, weak) IBOutlet UIView * guide_ThumbView;
@property (nonatomic, weak) IBOutlet UIView * guide_PlayView;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint * guide_VideoView_top;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint * pasterTab_height;
@property (nonatomic, weak) IBOutlet UIImageView * pasterMoreGuideImage;//更多提示
@property(nonatomic, weak) IBOutlet NSLayoutConstraint * pasterMoreGuideImage_bottom;
@property (nonatomic, weak) IBOutlet UIView * effectPlayView;
@property (nonatomic, weak) IBOutlet UILabel *recordAudioLabel;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *viewUnderLine;


@property (nonatomic, strong) Video *video;

@end

@implementation EffectViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withVideo:(Video *)video{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        self.video = video;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _viewTab.backgroundColor = [UIColor whiteColor];
    _viewBottom.backgroundColor = RGB(229, 229, 229);
    
    // 准备人脸数据array
}



#pragma mark - collentioViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (IBAction)buttonCloseClick:(id)sender{}
- (IBAction)buttonDraftsClick:(id)sender{}
- (IBAction)buttonFinishClick:(id)sender{}
- (IBAction)buttonPreviewClick:(id)sender{}
- (IBAction)buttonFilterClick:(id)sender{}
- (IBAction)buttonPasterClick:(id)sender{}
- (IBAction)buttonCartoonClick:(id)sender{}
- (IBAction)buttonCartoonBackToBigGroupClick:(id)sender{}
- (IBAction)buttonMvClick:(id)sender{}
- (IBAction)buttonMusicClick:(id)sender{}
- (IBAction)buttonRecordAudioDown:(id)sender{}
- (IBAction)buttonRecordAudioUp:(id)sender{}
- (IBAction)buttonDeleteRecordClick:(id)sender{}
- (IBAction)buttonFinishRecordClick:(id)sender{}
- (IBAction)sliderMixTouchUp:(id)sender{}

- (IBAction)buttonPlayClick:(id)sender{}
- (IBAction)buttonRecordAudioClick:(id)sender{}

- (IBAction)viewTopBackgroundClick:(id)sender{}
- (IBAction)buttonPlayClickTwo:(id)sender{}

@end
