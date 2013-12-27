//
//  Diary.h
//  Diray
//
//  Created by shuanglong on 13-12-23.
//  Copyright (c) 2013年 双龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Diary : NSObject<NSCoding>

@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * content;
@property(nonatomic,readonly,getter = dateCreate)NSDate * dateCreate;

//添加照片KEY
@property(nonatomic,strong)NSString * photoKey;

//添加声音成员变量
@property(nonatomic,strong) NSString * audioFileName;


-(id)initWithTitle:(NSString*)title AndContent:(NSString*)content;

+(id)creatDiary;

@end
