//
//  EffectViewController.h
//  SUCamera
//
//  Created by zypsusu on 2017/7/31.
//  Copyright © 2017年 zypsusu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPUImageView, QUSmoothCollectionView, RecordAudioProgressView, AudioMetersView, EffectTabView, RecordAudio;

@class Video;

@interface EffectViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *buttonClose;
@property (weak, nonatomic) IBOutlet UIButton *buttonDrafts;
@property (weak, nonatomic) IBOutlet UIButton *buttonFinish;
@property (weak, nonatomic) IBOutlet UIButton *buttonPreview;

@property (weak, nonatomic) IBOutlet UIView *viewCenter;
@property (weak, nonatomic) IBOutlet UIView *viewVideoContainer;
@property (weak, nonatomic) IBOutlet GPUImageView *gpuImageView;
@property (weak, nonatomic) IBOutlet UIView *viewPaster;
@property (weak, nonatomic) IBOutlet RecordAudioProgressView *pointProgress;
@property (weak, nonatomic) IBOutlet AudioMetersView *viewMeter;
@property (weak, nonatomic) IBOutlet UIView *viewNextTip;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlayOrPause;

@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UIView *viewEffect;
@property (weak, nonatomic) IBOutlet QUSmoothCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewGroup;
@property (weak, nonatomic) IBOutlet EffectTabView *viewTab;
@property (weak, nonatomic) IBOutlet UIView *viewNewTab;
@property (weak, nonatomic) IBOutlet UIButton *buttonFilter;
@property (weak, nonatomic) IBOutlet UIButton *buttonPaster;
@property (weak, nonatomic) IBOutlet UIButton *buttonMv;
@property (weak, nonatomic) IBOutlet UIButton *buttonMusic;

@property (weak, nonatomic) IBOutlet UIView *viewMix;
@property (weak, nonatomic) IBOutlet UISlider *sliderMix;
@property (weak, nonatomic) IBOutlet UILabel *labelMixLeft;
@property (weak, nonatomic) IBOutlet UILabel *labelMixRight;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecodAudioFlag;

@property (weak, nonatomic) IBOutlet UIView *viewPlayer;

@property (weak, nonatomic) IBOutlet UIView *viewRecordAudio;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecordAudio;
@property (weak, nonatomic) IBOutlet UIButton *buttonDeleteRecord;
@property (weak, nonatomic) IBOutlet UIButton *buttonFinishRecord;

@property (nonatomic, retain) RecordAudio *recordAudio;

@property(nonatomic, weak) IBOutlet UIView * viewThumbnail;
@property(nonatomic, weak) IBOutlet UIView * viewPasterTable;
@property(nonatomic, weak) IBOutlet UILabel *labelVideoTime;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintThumbnailAspect;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewCenterTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCollectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewEffectBottomHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewEffectButtonBackWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewTabTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewTabHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consButtonPasterWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consButtonCartoonWidth;


- (IBAction)buttonCloseClick:(id)sender;
- (IBAction)buttonDraftsClick:(id)sender;
- (IBAction)buttonFinishClick:(id)sender;
- (IBAction)buttonPreviewClick:(id)sender;
- (IBAction)buttonFilterClick:(id)sender;
- (IBAction)buttonPasterClick:(id)sender;
- (IBAction)buttonCartoonClick:(id)sender;
- (IBAction)buttonCartoonBackToBigGroupClick:(id)sender;
- (IBAction)buttonMvClick:(id)sender;
- (IBAction)buttonMusicClick:(id)sender;
- (IBAction)buttonRecordAudioDown:(id)sender;
- (IBAction)buttonRecordAudioUp:(id)sender;
- (IBAction)buttonDeleteRecordClick:(id)sender;
- (IBAction)buttonFinishRecordClick:(id)sender;
- (IBAction)sliderMixTouchUp:(id)sender;

- (IBAction)buttonPlayClick:(id)sender;
- (IBAction)buttonRecordAudioClick:(id)sender;

- (IBAction)viewTopBackgroundClick:(id)sender;
- (IBAction)buttonPlayClickTwo:(id)sender;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withVideo:(Video *)video;
@end
