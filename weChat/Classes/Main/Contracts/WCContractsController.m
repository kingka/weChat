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

    [self loadUsers2];
}

-(void)loadUsers2{
    //显示好友数据 （保存XMPPRoster.sqlite文件）
    
    //1.上下文 关联XMPPRoster.sqlite文件
    NSManagedObjectContext *rosterContext = [WCXMPPTool sharedXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    //2.Request 请求查询哪张表
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    //设置排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    
    //过滤
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"subscription != %@",@"none"];
    request.predicate = pre;
    
    //3.执行请求
    //3.1创建结果控制器
    // 数据库查询，如果数据很多，会放在子线程查询
    // 移动客户端的数据库里数据不会很多，所以很多数据库的查询操作都主线程
    _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:rosterContext sectionNameKeyPath:nil cacheName:nil];
    _resultsController.delegate = self;
    NSError *err = nil;
    //3.2执行
    [_resultsController performFetch:&err];
    
    WCLog(@"%@",_resultsController.fetchedObjects);
}




-(void)loadUsers{

    //1 上下文 关联 XMPPRoser.sqlite 文件
    NSManagedObjectContext *rosterContext = [WCXMPPTool sharedXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    //2 request 请求查询哪张表
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    //过滤
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"subscription != %@",@"none"];
    request.predicate = pre;
    
    //设置排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    
    
    //3 执行请求
    NSError *error = nil;
    NSArray *users = [rosterContext executeFetchRequest:request error:&error];
    self.users = users;
}

#pragma mark -结果控制器的代理
#pragma mark -数据库内容改变
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    WCLog(@"%@",[NSThread currentThread]);
    //刷新表格
    [self.tableView reloadData];
    
}


#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
   // XMPPUserCoreDataStorageObject *user = self.users[indexPath.row];--load1
    XMPPUserCoreDataStorageObject *user = _resultsController.fetchedObjects[indexPath.row];
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [[WCXMPPTool sharedXMPPTool].roster removeUser:user.jid];
    }
    
}
#pragma mark - tableDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //return self.users.count;--load1
    return _resultsController.fetchedObjects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    
    if(cell == nil){
        WCLog(@"cell is nil");
    }
   
    //XMPPUserCoreDataStorageObject *user = self.users[indexPath.row];--load1
    XMPPUserCoreDataStorageObject *user = _resultsController.fetchedObjects[indexPath.row];
    cell.textLabel.text = user.displayName;
    
    //kvo 监听用户状态的改变 --load1
    //[user addObserver:self forKeyPath:@"sectionNum" options:NSKeyValueObservingOptionNew context:nil];
    
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

    //显示好友的头像
    if (user.photo) {//默认的情况，不是程序一启动就有头像
        cell.imageView.image = user.photo;
    }else{
        //从服务器获取头像
        NSData *imgData = [[WCXMPPTool sharedXMPPTool].avatar photoDataForJID:user.jid];
        cell.imageView.image = [UIImage imageWithData:imgData];
    }

    return cell;
}

//#pragma mark - KVO delegate --load1
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//    
//    [self.tableView reloadData];
//}
@end
