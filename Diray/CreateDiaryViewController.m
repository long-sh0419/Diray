//
//  CreateDiaryViewController.m
//  Diray
//
//  Created by shuanglong on 13-12-25.
//  Copyright (c) 2013年 双龙. All rights reserved.
//

#import "CreateDiaryViewController.h"

@interface CreateDiaryViewController ()

@end

@implementation CreateDiaryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    //注册两个observer
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
}
//移除观察者
-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //添加写日记的时间,设置日期格式
    NSDateFormatter*df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy 年 M 月 d 日 'at' h:mm a"];
    NSString * date = [df stringFromDate:[NSDate date]];
    self.diaryDate.text = date;
    
    self.diary = [[Diary alloc]init];
    
    self.diaryContent.delegate  = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击取消和保存按钮
- (IBAction)cancel:(id)sender {
    [self.delegate createDiaryViewController:self];
}

- (IBAction)save:(id)sender {
    self.diary.title = self.diaryTitle.text;
    self.diary.content = self.diaryContent.text;
    
    [self.delegate createDiaryViewController:self didSaveWithDiary:self.diary];
    [[DiaryStore defaultStore] saveChanges];
}

//delegate方法，当点击return按钮时响应的操作
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"takePicture"]) {
        CameraViewController * cameraViewController = [segue destinationViewController];
        cameraViewController.delegate = self;
        
        cameraViewController.diary = self.diary;
        
    }
    
    if ([segue.identifier isEqualToString:@"record"]) {
        RecordViewController * recordViewController = [segue destinationViewController];
        recordViewController.delegate = self;
        recordViewController.diary = self.diary;
        
    }

}
#pragma - UITextViewDelegate;
-(void)textViewDidBeginEditing:(UITextView *)textView{

    self.currentTextView = textView;
    float textViewTop = self.currentTextView.frame.origin.y;
    
    float textViewBottom = textViewTop + self.currentTextView.frame.size.height;

    if ((textViewBottom>self.keyBoardY) && (self.keyBoardY != 0.0)) {
        [(UIScrollView*)self.view setContentOffset:CGPointMake(0, textViewBottom - self.keyBoardY + self.statusBarHeight) animated:YES];
    }
}

//增加keyboardDidShow方法
-(void)keyboardDidShow:(NSNotification*)notification{
    NSDictionary * info = [notification userInfo];
    
    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    
    CGRect statusBarFrame = [[UIApplication sharedApplication]statusBarFrame];
    
    self.statusBarHeight = statusBarFrame.size.height;
    
    self.keyBoardY = keyboardFrame.origin.y;
    
    float textViewTop = self.currentTextView.frame.origin.y;
    
    float textViewBottom = textViewTop + self.currentTextView.frame.size.height;
    
    if ((textViewBottom>self.keyBoardY) && (self.keyBoardY != 0.0)) {
        [(UIScrollView*)self.view setContentOffset:CGPointMake(0, textViewBottom - self.keyBoardY + self.statusBarHeight) animated:YES];
    }
    
    
    //如果doneInKeyboardButton没有被实例化，则创建它
    if (self.doneInKeyboardButton==nil) {
        //设定按钮在view中的位置和大小
        self.doneInKeyboardButton.frame = CGRectMake(keyboardFrame.size.width-30, keyboardFrame.origin.y-25, 30, 25);
        //设置按钮上显示的图标
        self.doneInKeyboardButton.adjustsImageWhenHighlighted = NO;
        
        [self.doneInKeyboardButton setImage:[UIImage imageNamed:@"doneInKeyboard.jpg"] forState:UIControlStateNormal];
        
        //设置用户点击按钮后的操作
        [self.doneInKeyboardButton addTarget:self action:@selector(handleDoneInKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        
        //获取虚拟键盘所在的视图
        UIWindow * tempWindow = [[[UIApplication sharedApplication]windows]objectAtIndex:1];
        
        //将自定义的按钮显示在虚拟键盘所在的视图上
        if (self.doneInKeyboardButton.superview ==nil) {
            [tempWindow addSubview:self.doneInKeyboardButton];
            //注意，这里直接加到window上
        }
        
        
    }
    
}

//增加keyboardDidHide方法
-(void)keyboardDidHide:(NSNotification*)notification{
    //  如果doneInKeyboard按钮显示在屏幕上，将其从视图中移除
    if (self.doneInKeyboardButton.superview) {
        [self.doneInKeyboardButton removeFromSuperview];
    }
    
    
    [(UIScrollView*)self.view setContentOffset:CGPointMake(0, 0)animated:YES];
    
}


-(void)handleDoneInKeyboard:(id)sender;
{
    [self.currentTextView resignFirstResponder];


}



#pragma - camera view controller Delegate
-(void)cameraViewControllerDidReture:(CameraViewController *)cameraViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma - record view controller Delegate
-(void)recordViewControllerDidReturn:(RecordViewController *)recordViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
