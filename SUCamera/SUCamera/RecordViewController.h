//
//  RecordViewController.h
//  SUCamera
//
//  Created by zypsusu on 2017/7/31.
//  Copyright © 2017年 zypsusu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPUImageView, Video, PointProgress;

#define RGBToColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface RecordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *viewCenter;
@property (weak, nonatomic) IBOutlet PointProgress *pointProgress;
@property (weak, nonatomic) IBOutlet GPUImageView *gpuImageView;
@property (weak, nonatomic) IBOutlet UIView *viewMask;
@property (weak, nonatomic) IBOutlet UILabel *labelOrientation;
@property (weak, nonatomic) IBOutlet UIButton *buttonPosition;
@property (weak, nonatomic) IBOutlet UIButton *buttonFlash;
@property (weak, nonatomic) IBOutlet UIButton *buttonSkin;
@property (weak, nonatomic) IBOutlet UIButton *buttonTime;
@property (weak, nonatomic) IBOutlet UIView *viewFocusContent;

@property (weak, nonatomic) IBOutlet UIView *viewSkin;
@property (weak, nonatomic) IBOutlet UISlider *sliderSkin;
@property (weak, nonatomic) IBOutlet UILabel *labelSkinRight;

@property (weak, nonatomic) IBOutlet UIView *viewScale;
@property (weak, nonatomic) IBOutlet UILabel *labelScale;

@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIButton *buttonClose;
@property (weak, nonatomic) IBOutlet UIButton *buttonFinish;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecord;
@property (weak, nonatomic) IBOutlet UIButton *buttonLibrary;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;

@property (weak, nonatomic) IBOutlet UIView *viewSaveDrafts;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSaveDraftsCover;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySaveDrafts;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewSaveDraftsCenterX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewSaveDraftsCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewSaveDraftsWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewSkinVerticalSpace;

@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchGesture;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;

@property (weak, nonatomic) IBOutlet UIView *viewTimeNotice;
@property (weak, nonatomic) IBOutlet UILabel *viewTimeNoticeTop;
@property (weak, nonatomic) IBOutlet UIView *viewTimeNoticeBottom;

@property (nonatomic, strong) Video *video;


- (IBAction)buttonCloseClick:(id)sender;
- (IBAction)buttonFinishClick:(id)sender;
- (IBAction)viewBottomDown:(id)sender;
- (IBAction)buttonRecordDown:(id)sender;
- (IBAction)buttonRecordUp:(id)sender;
- (IBAction)buttonLibraryClick:(id)sender;
- (IBAction)buttonPositionClick:(id)sender;
- (IBAction)buttonFlashClick:(id)sender;
- (IBAction)buttonTimeClick:(id)sender;
- (IBAction)buttonSaveClick:(id)sender;

- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)sliderTouchDown:(id)sender;
- (IBAction)sliderTouchCancel:(id)sender;
- (IBAction)buttonSkinClick:(id)sender;
- (IBAction)viewCenterPinchGesture:(id)sender;
- (IBAction)viewCenterTapGesture:(id)sender;
- (IBAction)viewCenterPanGesture:(id)sender;

- (CGPoint)buttonLibrarayCenterPointToView;


@end
