//
//  DiaryStore.h
//  Diray
//
//  Created by shuanglong on 13-12-25.
//  Copyright (c) 2013年 双龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Diary.h"

@interface DiaryStore : NSObject
{
    NSMutableArray * diaries;
}

+(DiaryStore*)defaultStore;

-(NSArray*)diaries;

-(Diary*)createDiary;

-(NSString *)diaryArchivePath;

-(BOOL)saveChanges;

-(void)fetchDiary;

-(void)removeDiary:(Diary*)d;

@end
