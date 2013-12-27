//
//  DetailViewController.m
//  Diray
//
//  Created by shuanglong on 13-12-23.
//  Copyright (c) 2013年 双龙. All rights reserved.
//

#import "DetailViewController.h"
#import "ImageStore.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSString * audioFileName = [self.diary audioFileName];
    if (audioFileName) {
        [self.audioButton setHidden:NO];
    }
    else{
    
        [self.audioButton setHidden:YES];
    }
    
    //设置日记显示界面title
    self.navigationItem.title = self.diary.title;
    self.diaryTitle.text = self.diary.title;
    self.diaryContent.text = self.diary.content;
    
    //添加照片
    NSString * photoKey = [self.diary photoKey];
    
    if (photoKey) {
        UIImage * imageToDisPlay = [[ImageStore defaultImageStore]imageForKey:photoKey];
        self.picture.image = imageToDisPlay;
    }
    
    else{
        
        self.picture.image = nil;
    
    }



}

//添加disappear方法
-(void)viewWillDisappear:(BOOL)animated{

    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"%@",self.diary.title);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)audioPlay:(id)sender {
    
    NSArray * folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString * documentFolder = folders[0];
    
    NSData * filedata = [NSData dataWithContentsOfFile:[documentFolder stringByAppendingPathComponent:self.diary.audioFileName]];
    
    self.audioPlayer = [[AVAudioPlayer alloc]initWithData:filedata error:nil];
    
    //开始播放音频
    if (self.audioPlayer!=nil) {
        if ([self.audioPlayer prepareToPlay]&&[self.audioPlayer play]) {
            NSLog(@"正常播放音频文件");
        }else{
        
            NSLog(@"播放失败");
        }
    }else{
        NSLog(@"初始化avaudioplayer失败");
    
    }
}
@end
