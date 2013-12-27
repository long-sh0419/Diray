//
//  RecordViewController.h
//  Diray
//
//  Created by shuanglong on 13-12-25.
//  Copyright (c) 2013年 双龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Diary.h"


@class RecordViewController;

@protocol recordViewControllerDelegate

-(void)recordViewControllerDidReturn:(RecordViewController*)recordViewController;

@end

@interface RecordViewController : UIViewController<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *recordInfo;

@property(nonatomic,weak)id<recordViewControllerDelegate>delegate;

@property(nonatomic,strong)AVAudioRecorder * audioRecorder;

@property(nonatomic,strong)Diary * diary;

@property(nonatomic,strong)AVAudioPlayer * audioPlayer;


- (IBAction)recordButton:(id)sender;
- (IBAction)dismissButton:(id)sender;

-(NSString*)audioRecordingPath;

-(NSDictionary*)audioRecordingSetting;

@property (weak, nonatomic) IBOutlet UIButton *recorderButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
- (IBAction)playOption:(id)sender;

@end
