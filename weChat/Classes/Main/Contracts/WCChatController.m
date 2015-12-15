//
//  WCChatController.m
//  weChat
//
//  Created by Imanol on 15/12/14.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import "WCChatController.h"

@interface WCChatController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_resultController;
}
@end
@implementation WCChatController

- (IBAction)send:(id)sender {
}

-(void)viewDidLoad{
    
    self.title = self.friendJid.bare;
    //1 上下文
    NSManagedObjectContext *context = [WCXMPPTool sharedXMPPTool].msgArchingStorage.mainThreadManagedObjectContext;
    
    //请求
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    //过滤
    NSString *loginUserJid = [WCXMPPTool sharedXMPPTool].xmppStream.myJID.bare;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",loginUserJid,self.friendJid.bare];
    request.predicate = predicate;
    
    //排序
    NSSortDescriptor *timestampDescriptor = [[NSSortDescriptor alloc]initWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timestampDescriptor];
    
    //执行
    _resultController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _resultController.delegate = self;
    
    NSError *error = nil;
    [_resultController performFetch:&error];
    
}
#pragma mark - NSFetchedResultsControllerDelegate
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    [self.tableView reloadData];
}
#pragma mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _resultController.fetchedObjects.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"chatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    //获取聊天信息
    XMPPMessageArchiving_Message_CoreDataObject *msgObj = _resultController.fetchedObjects[indexPath.row];
    cell.textLabel.text = msgObj.body;
    return cell;
}
#pragma mark -UITableViewDelegate
@end
