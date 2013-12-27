//
//  DiaryListViewController.m
//  Diray
//
//  Created by shuanglong on 13-12-23.
//  Copyright (c) 2013年 双龙. All rights reserved.
//

#import "DiaryListViewController.h"
#import "CreateDiaryViewController.h"
#import "DiaryStore.h"



@interface DiaryListViewController ()

@end

@implementation DiaryListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.diaries = (NSMutableArray*)[[DiaryStore defaultStore]diaries];
    
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", NSHomeDirectory());
    
    //将导航中左侧的按钮设置为表哥视图的编辑按钮
    [[self navigationItem]setLeftBarButtonItem:[self editButtonItem]];
    
    //    //让表格视图进入编辑状态
    //    [self setEditing:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.diaries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    /*
     //针对不同的单元格应用不同的附件指示器
     
     if (indexPath.row%2) {
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     }
     else{
     
     cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
     }
     */
    //自定义单元格附件指示器
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0.0f, 0.0f, 150.0f, 25.0f);
    [button setTitle:@"听录音" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(listenAudio:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = button;
    
    //显示具有层级的单元格
    cell.indentationWidth = 10;
    cell.indentationLevel = indexPath.row;
    
    
    
    Diary * diary = self.diaries[indexPath.row];
    cell.textLabel.text = diary.title;
    cell.accessibilityValue = diary.content;
    
    return cell;
    
    
}


-(void)listenAudio:(UIButton*)sender{
    UITableViewCell* cell = (UITableViewCell*)sender.superview;
    if (cell !=nil  ) {
        NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
        NSLog(@"单元格%@附件指示器被点击",cellIndexPath);
    }
    // 获取用户点击的那行后，可以播放改行日记的音频信息
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
     //从数据库中删除选中的行
    NSArray*diaries = [[DiaryStore defaultStore]diaries];
     Diary * d  = [diaries objectAtIndex:indexPath.row];
     [[DiaryStore defaultStore]removeDiary:d];
     
   //从表格视图中移除被删除的单元格，并使用动画效果
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //跳转到日记内容
    if ([segue.identifier isEqualToString:@"DetailDiary"]) {
        //获取表格中选着的行
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        NSInteger row = indexPath.row;
        
        //获取选中的diary对象
        Diary *diary = self.diaries[row];
        
        //通过segue获取被故事版初始化的对象，然后将数据传递给它
        DetailViewController * detailDiary = (DetailViewController*)[segue destinationViewController];
        detailDiary.diary = diary;
    }
    
    
    
    //设置添加日记按钮
    if ([segue.identifier isEqualToString:@"AddDiary"]) {
        CreateDiaryViewController * createDiaryViewController = [segue destinationViewController];
        createDiaryViewController.delegate = self;
    }
    
    
}
//协议中两个方法的实现
//当用户点击返回按钮后实现的方法
-(void)createDiaryViewController:(CreateDiaryViewController*)createDiaryController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//当用户点击保存后实现的方法
-(void)createDiaryViewController:(CreateDiaryViewController *)createDiaryController didSaveWithDiary:(Diary*)diary{
    
    Diary* newDiary = diary;
    NSLog(@"title:%@,content:%@",newDiary.title,newDiary.content);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.diaries addObject:newDiary];
    [self.tableView reloadData];
    
}


-(UIView*)headerView{
    if (!_headerView) {
        //z载入headerView.xib资源
        _headerView = (UIView*)[[[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil]objectAtIndex:0];
    }
    return _headerView;
    
}

//实现uitableView协议中的两个方法

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return [self headerView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [[self headerView]bounds].size.height;

}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * footView = nil;
    
    if (section==0) {
        UILabel * lable = [[UILabel alloc]initWithFrame:CGRectZero];
        lable.text = @"日记列表的结尾";
        lable.backgroundColor = [UIColor greenColor];
        [lable sizeToFit];
        
        //将leble向右移动10点
        lable.frame = CGRectMake(lable.frame.origin.x, lable.frame.origin.y + 10.0f, lable.frame.size.width, lable.frame.size.height);
        
        //作为放置lable的容器，footerView要比lable的宽度大10点这不是必须的
        CGRect frame = CGRectMake(0, 0, lable.frame.size.width + 10.0f, lable.frame.size.height);
        
        footView = [[UIView alloc]initWithFrame:frame];
        [footView addSubview:lable];
        
    }
    return footView;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{

    CGFloat height = 0.0f;
    if (section == 0) {
        height =30.0f;
    }
    return height;
}



@end
