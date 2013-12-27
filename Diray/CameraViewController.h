//
//  CameraViewController.h
//  Diray
//
//  Created by shuanglong on 13-12-25.
//  Copyright (c) 2013年 双龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diary.h"

@class CameraViewController;
@protocol CameraViewControllerDelegate

-(void)cameraViewControllerDidReture:(CameraViewController*)cameraViewController;

@end

@interface CameraViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,weak)id<CameraViewControllerDelegate>delegate;
@property(nonatomic,strong)Diary*diary;

@property (weak, nonatomic) IBOutlet UIImageView *picture;




- (IBAction)doDismiss:(id)sender;
- (IBAction)takePicture:(id)sender;




@end
