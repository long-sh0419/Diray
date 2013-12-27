//
//  CreateDiaryViewController.h
//  Diray
//
//  Created by shuanglong on 13-12-25.
//  Copyright (c) 2013年 双龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diary.h"
#import "CameraViewController.h"
#import "RecordViewController.h"
#import "DiaryStore.h"

//添加CreateDiary的delegate
@class CreateDiaryViewController;
@protocol CreateDiaryViewControllerDelegate

//必须实现的方法
@required
//当用户点击返回按钮后实现的方法
-(void)createDiaryViewController:(CreateDiaryViewController*)createDiaryController;

//当用户点击保存后实现的方法
-(void)createDiaryViewController:(CreateDiaryViewController *)createDiaryController didSaveWithDiary:(Diary*)diary;

@end

@interface CreateDiaryViewController : UIViewController<UITextFieldDelegate,CameraViewControllerDelegate,recordViewControllerDelegate,UITextViewDelegate>
//声明id类型的delegate成员变量，用于保存符合
//createDiaryViewControllerDelegate协议的对象指针
@property(weak,nonatomic)id<CreateDiaryViewControllerDelegate>delegate;

@property(nonatomic,strong)Diary*diary;

@property (weak, nonatomic) IBOutlet UILabel *diaryDate;
@property (weak, nonatomic) IBOutlet UITextField *diaryTitle;
@property (weak, nonatomic) IBOutlet UITextView *diaryContent;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

//完善createDiary
@property float keyBoardY;
@property float statusBarHeight;
@property (weak,nonatomic) UITextView * currentTextView ;

@property(nonatomic,strong)UIButton * doneInKeyboardButton;



@end
