//
//  DiaryListViewController.h
//  Diray
//
//  Created by shuanglong on 13-12-23.
//  Copyright (c) 2013年 双龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diary.h"
#import "DetailViewController.h"
#import "CreateDiaryViewController.h"
@interface DiaryListViewController : UITableViewController<CreateDiaryViewControllerDelegate>

@property(nonatomic,strong)NSMutableArray * diaries;


//添加table的headerView
@property(nonatomic,weak) UIView * headerView;

-(UIView*)headerView;

@end
