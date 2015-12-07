//
//  WCContractsController.m
//  weChat
//
//  Created by Imanol on 15/12/7.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import "WCContractsController.h"

@interface WCContractsController ()<NSFetchedResultsControllerDelegate>{
    
    NSFetchedResultsController *_resultsController;
}

@property (strong, nonatomic) NSArray *users;
@end

@implementation WCContractsController

-(void)viewDidLoad{

    [self loadUsers];
}


-(void)loadUsers{

    //1 上下文 关联 XMPPRoser.sqlite 文件
    NSManagedObjectContext *rosterContext = [WCXMPPTool sharedXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    //2 request 请求查询哪张表
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    //设置排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    //3 执行请求
    NSError *error = nil;
    NSArray *users = [rosterContext executeFetchRequest:request error:&error];
    self.users = users;
}

#pragma mark - tableViewDelegate
#pragma mark - tableDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.users.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    
    if(cell == nil){
        WCLog(@"cell is nil");
    }
   
    XMPPUserCoreDataStorageObject *user = self.users[indexPath.row];
    cell.textLabel.text = user.displayName;
    
    //kvo 监听用户状态的改变
    [user addObserver:self forKeyPath:@"sectionNum" options:NSKeyValueObservingOptionNew context:nil];
    
    switch ([user.sectionNum integerValue]) {
        case 0:
            cell.detailTextLabel.text = @"在线";
            break;
        case 1:
            cell.detailTextLabel.text = @"离开";
            break;
        case 2:
            cell.detailTextLabel.text = @"离线";
            break;
        default:
            cell.detailTextLabel.text = @"见鬼了";
            break;
    }

    
    return cell;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    [self.tableView reloadData];
}
@end
