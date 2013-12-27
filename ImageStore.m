//
//  ImageStore.m
//  Diray
//
//  Created by shuanglong on 13-12-25.
//  Copyright (c) 2013年 双龙. All rights reserved.
//

#import "ImageStore.h"

static ImageStore*defaultImageStore = nil;

@implementation ImageStore

+(id)allocWithZone:(NSZone *)zone{
    return  [self defaultImageStore];
}

+(ImageStore*)defaultImageStore{
    if (!defaultImageStore) {
        defaultImageStore = [[super allocWithZone:NULL]init];
    }
    return defaultImageStore;
}

-(id)init{
    if (defaultImageStore) {
        return defaultImageStore;
    }
    
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)setImage:(UIImage*)image forkey:(NSString*)string{
    
    
    //获取documents目录的全路径
    NSString * imagePath = [self pathIndocumentDirectory:string];
    
    //将iamge对象鞋服nsdata之中
    NSData * d = UIImageJPEGRepresentation(image, .5);
    
    //将数据写入文件系统当中
    [d writeToFile:imagePath atomically:YES];
    [dictionary setObject:image forKey:string];

    
}


-(void)deleteImageForKey:(NSString *)string{
    if (!string) {
        return;
    }
    
    //如果照片中imageStore对象中删除，也要重系统中删除
    NSString * path = [self pathIndocumentDirectory:string];
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    
    [dictionary removeObjectForKey:string];
}

-(UIImage*)imageForKey:(NSString*)string{
    //首先尝试从dictionary中获取图片
    UIImage * image = [dictionary objectForKey:string];
    
    //如果无法从dictionary获取图片，则尝试从文件中获取
    if (!image) {
        //从文件创建uiiage对象
        image = [UIImage imageWithContentsOfFile:[self pathIndocumentDirectory:string]];
    }
    
    //如果重文件中获取了图片，则将其缓存
    if (image) {
        [dictionary setObject:image forKey:string];
    }
    else{
        [self pathIndocumentDirectory:string];
    }
    
    
    return [dictionary objectForKey:string];
}


//////////////////////////////使用NSdata将数据写入文件系统

-(NSString*)pathIndocumentDirectory:(NSString*)fileName{
//从沙盒中获取document目录的路径列表
    NSArray * documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString * documentDirectory = documentDirectories[0];
    return [documentDirectory stringByAppendingPathComponent:@"fileName"];

}



@end
