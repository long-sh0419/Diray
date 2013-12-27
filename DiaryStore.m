//
//  DiaryStore.m
//  Diray
//
//  Created by shuanglong on 13-12-25.
//  Copyright (c) 2013年 双龙. All rights reserved.
//

#import "DiaryStore.h"

static DiaryStore * defaultStore = nil;

@implementation DiaryStore

+(DiaryStore*)defaultStore{
    if (!defaultStore) {
        defaultStore = [[super allocWithZone:NULL]init];
    }
    
    return defaultStore;
}

+(id)allocWithZone:(NSZone *)zone{
    
    return [self defaultStore];

}

-(id)init{

    if (defaultStore) {
        return defaultStore;
    }
    
    self = [super init];
    return self;
}

-(NSArray*)diaries{
    
    //确保diaries被创建
    [self fetchDiary];

    return diaries;
}


-(Diary*)createDiary{

    //确保diaries被创建
    [self fetchDiary];
    
    Diary * diary = [Diary creatDiary];
    [diaries addObject:diary];
    return diary;
}


-(NSString *)diaryArchivePath{

    //获取沙盒中Documents的目录的路径列表
    NSArray * documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //从documentDirectories中获得document的路径
    NSString * documentDirectory = [documentDirectories objectAtIndex:0];
    
    //在路径后面添加文件名并返回
    return [documentDirectory stringByAppendingPathComponent:@"diaries.data"];
    
   
}

-(BOOL)saveChanges{
  
    //返回真假值
    
    return [NSKeyedArchiver archiveRootObject:diaries toFile:[self diaryArchivePath]];

    
}

-(void)fetchDiary{

//如果当前ALL DIARIES为空，则尝试从磁盘载入
    if (!diaries) {
        NSString * path = [self diaryArchivePath];
        diaries = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }

//如果磁盘中不存在该文件，则创建一个新的
    if (!diaries) {
        diaries = [[NSMutableArray alloc]init];
    }
    
}

-(void)removeDiary:(Diary*)d{
    [diaries removeObjectIdenticalTo:d];

}

@end
