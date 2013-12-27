//
//  DetailViewController.h
//  Diray
//
//  Created by shuanglong on 13-12-23.
//  Copyright (c) 2013年 双龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diary.h"
#import <AVFoundation/AVFoundation.h>

@interface DetailViewController : UIViewController

@property(nonatomic,strong)AVAudioPlayer * audioPlayer;

@property(nonatomic,strong)Diary * diary;

@property (weak, nonatomic) IBOutlet UITextField *diaryTitle;

@property (weak, nonatomic) IBOutlet UITextView *diaryContent;

@property (weak, nonatomic) IBOutlet UILabel *diaryDate;

@property (weak, nonatomic) IBOutlet UIImageView *picture;

@property (weak, nonatomic) IBOutlet UIButton *audioButton;

- (IBAction)audioPlay:(id)sender;


@end
