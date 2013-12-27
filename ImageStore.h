//
//  ImageStore.h
//  Diray
//
//  Created by shuanglong on 13-12-25.
//  Copyright (c) 2013年 双龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageStore : NSObject
{
    NSMutableDictionary *dictionary;
}

+(ImageStore*)defaultImageStore;

-(void)setImage:(UIImage*)image forkey:(NSString*)string;
-(void)deleteImageForKey:(NSString *)string;
-(UIImage*)imageForKey:(NSString*)string;

@end
