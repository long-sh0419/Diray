//
//  CameraViewController.m
//  Diray
//
//  Created by shuanglong on 13-12-25.
//  Copyright (c) 2013年 双龙. All rights reserved.
//

#import "CameraViewController.h"
#import "ImageStore.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

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
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doDismiss:(id)sender {
    [self.delegate cameraViewControllerDidReture:self];
}

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];

    //如果设备摄像头可用，则进行拍摄，否则调用ios照片库
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
    else{
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    //设置imagePicker的delegate属性，使他指向当前控制器
    [imagePicker setDelegate : self];
    
    //将UIImagePickerController的视图呈现在屏幕上
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#warning  难理解
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString * oldPhotoKey = [self.diary photoKey];
    
    if (oldPhotoKey) {
        //删除之前的老照片
        [[ImageStore defaultImageStore]deleteImageForKey:oldPhotoKey];
    }
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //创建一个新的CFUUIDref类型的对象
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    
    //创建一个字符串
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    [self.diary setPhotoKey:(__bridge NSString *)newUniqueIDString];
    
    //前面使用create创建的coreFoundation，在不使用的时候释放
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    //使用键名将图像存入ImageStore
    [[ImageStore defaultImageStore] setImage:image forkey:[self.diary photoKey]];
    
    
    self.picture.image = image;
    
    //销毁UIimagePickerContrller控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



@end
