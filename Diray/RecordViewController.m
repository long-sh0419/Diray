//
//  RecordViewController.m
//  Diray
//
//  Created by shuanglong on 13-12-25.
//  Copyright (c) 2013年 双龙. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (self.diary.audioFileName!=nil) {
        self.playButton.hidden = NO;
    }
    else {
    
        self.playButton.hidden= YES;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordButton:(UIButton*)sender {
    //设置ERROR变量，存储录音时的错误信息
    NSError*error = nil;
    
    //如果当前录音按钮的标题为录音，在用户点击时执行的代码
    if ([sender.titleLabel.text isEqualToString:@"录音"]) {
        
        //获取音频文件存储的位置
        NSString * pathAsString = [self audioRecordingPath];
        NSURL* audioRecordingURL = [NSURL fileURLWithPath:pathAsString];
        
        //创建并初始化AVaudioRecord类型的实例变量，其中用到文件存储信息和NSdictionary类型的录音设置信息，获取录音设置信息的方法会在后面定义
        
        self.audioRecorder = [[AVAudioRecorder alloc]initWithURL:audioRecordingURL settings:[self audioRecordingSetting] error:&error];
        
        //如果成功创建AVAudioRecord的实例，则开始进行录音，否则清空audioRecorder所占用的内存
        if (self.audioRecorder!=nil) {
            self.audioRecorder.delegate = self;
            
            if ([self.audioRecorder prepareToRecord]&&[self.audioRecorder record]) {
                NSLog(@"正常开始录音");
                self.recorderButton.titleLabel.text = @"停止录音";
                [self.recorderButton setTitle:@"停止录音" forState:UIControlStateNormal];
                self.recordInfo.text = @"成功开始录音";
                
                [self performSelector:@selector(stopRecordingOnAudioRecorder:) withObject:self.audioRecorder afterDelay:5.0f];
            }
            
            else{
                self.recordInfo.text = @"录音失败";
                self.audioRecorder = nil;
                NSLog(@"录音失败");
            }
            
            
            
        }
        else{
            
            NSLog(@"创建audio recorder 实例失败");
        }

    }
    
    //如果当前录音按钮的标题为停止，在用户点击时执行的代码
    else if ([sender.titleLabel.text isEqualToString:@"停止"]){
        [self stopRecordingOnAudioRecorder:0];//？？？？？？？？？？？？？？？
        [self.recorderButton setTitle:@"录音" forState:UIControlStateNormal];
    
    }
    


    
    
    
}

- (IBAction)dismissButton:(id)sender {
    
    [self.delegate recordViewControllerDidReturn:self];
}


//创建保存位置
-(NSString*)audioRecordingPath{
    NSString * path = nil;
    NSArray * folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString*documentFolder = [folders objectAtIndex:0];
    
    //创建一个新的CFUUIDref类型的对象
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    
    //创建一个字符串
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    NSString * fileName =(__bridge NSString *)newUniqueIDString;
    
    self.diary.AudioFileName = [fileName stringByAppendingPathExtension:@"m4a"];
    
    //前面使用create创建的coreFoundation，在不使用的时候释放
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    

    path = [documentFolder stringByAppendingPathComponent:@"Recording.m4a"];
    
    return path;
}

-(NSDictionary*)audioRecordingSetting{

    NSDictionary * result = nil;
    
    NSMutableDictionary * settings = [[NSMutableDictionary alloc]init];
    
    [settings setValue:[NSNumber numberWithInteger:kAudioFormatAppleLossless] forKey:AVFormatIDKey];
    
    [settings setValue:[NSNumber numberWithFloat:44100.0f] forKey:AVSampleRateKey];
    
    [settings setValue:[NSNumber numberWithInteger:1] forKey:AVNumberOfChannelsKey];
    
    [settings setValue:[NSNumber numberWithInteger:AVAudioQualityLow] forKey:AVEncoderAudioQualityKey];
    
    result = [NSDictionary dictionaryWithDictionary:settings];
    
    return result;
    
}


-(void)stopRecordingOnAudioRecorder:(BOOL)animated{
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
        NSLog(@"录音结束");
    }

    self.audioRecorder  = nil;
}


- (IBAction)playOption:(id)sender {
    
    NSArray * folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString * documentsFolder = folders[0];
    
    NSData * filedata = [NSData dataWithContentsOfFile:[documentsFolder stringByAppendingPathComponent:self.diary.audioFileName]];
    
    
    self.audioPlayer = [[AVAudioPlayer alloc]initWithData:filedata error:nil];
    
    //开始播放音频
    if (self.audioPlayer!=nil) {
        //设置AVAudioPlayer的delegate并播放声音
        self.audioPlayer.delegate = self;
        if ([self.audioPlayer prepareToPlay]&&[self.audioPlayer play]) {
    
            self.recordInfo.text = @"正在播放音频文件";
    
        }
        else{
        
            self.recordInfo.text=@"播放音频失败";
        }
    }else{
    
        NSLog(@"初始化AVAudioPlayer失败");
    }
    
    
    
}


//中断播放的处理，如果有电话进来。。。。
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{

    //如果有声音正在播放，则暂停
    
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    
    if (flags==AVAudioSessionInterruptionFlags_ShouldResume&&player!=nil) {
        [player play];
    }

}

//终端录音的处理
-(void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{
    NSLog(@"录音过程被中断");

}

-(void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags{
    
    if (flags==AVAudioSessionInterruptionFlags_ShouldResume) {
        NSLog(@"恢复录音");
        [recorder record];
    }

}

@end
