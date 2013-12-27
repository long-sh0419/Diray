//
//  Diary.m
//  Diray
//
//  Created by shuanglong on 13-12-23.
//  Copyright (c) 2013年 双龙. All rights reserved.
//

#import "Diary.h"

@implementation Diary



- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"";
        self.content = @"";
        _dateCreate = [[NSDate alloc]init];
    }
    return self;
}

-(id)initWithTitle:(NSString*)title AndContent:(NSString*)content{
    self = [super init];
    if (self) {
        self.title = title;
        self.content = content;
        _dateCreate = [[NSDate alloc]init];
    }
    return self;
}

+(id)creatDiary{
    Diary * newDiary = [[Diary alloc]init];
    return newDiary;
}


#pragma - nscoding protoclo



-(void)encodeWithCoder:(NSCoder *)aCoder{
    //对于每一个实例变量，基于他的变量名进行归档
    //并且这些对象也会被用于发送encodeWithCoder：消息
    
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.dateCreate forKey:@"dateCreate"];
    [aCoder encodeObject:self.photoKey forKey:@"photoKey"];
    [aCoder encodeObject:self.audioFileName forKey:@"audioFileName"];


}


-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    if (self) {
        //之前实例中的所有成员变量被归档，我们要解码他们
        [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
        [self setContent:[aDecoder decodeObjectForKey:@"content"]];
        [self setPhotoKey:[aDecoder decodeObjectForKey:@"photoKey"]];
        [self setAudioFileName:[aDecoder decodeObjectForKey:@"audioFileName"]];
        
        //dateCreate是只读属性，我们不能使用setter方法，这里直接复制给成员变量
        _dateCreate = [aDecoder decodeObjectForKey:@"dateCreate"];
        
    }
    
    return self;
}





@end
