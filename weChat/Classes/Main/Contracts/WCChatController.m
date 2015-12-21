//
//  WCChatController.m
//  weChat
//
//  Created by Imanol on 15/12/14.
//  Copyright © 2015年 Imanol. All rights reserved.
//

#import "WCChatController.h"

@interface WCChatController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSFetchedResultsController *_resultController;
}
- (IBAction)acctchBtnClick:(id)sender;

@end
@implementation WCChatController

- (IBAction)send:(id)sender {
}

#pragma mark - notifer
-(void)addNotifer{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)kbShow:(NSNotification*)noti{

    // 获取键盘高度
    NSLog(@"%@",noti.userInfo);
    CGFloat kbHeight = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    self.bottomConstrain.constant = kbHeight;
}

-(void)kbHide:(NSNotification*)noti{

    self.bottomConstrain.constant = 0;
}
#pragma mark - lifeCycle
-(void)viewDidLoad{
    
    [self addNotifer];
    
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

-(void)dealloc{
    
}
#pragma mark - NSFetchedResultsControllerDelegate
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    [self.tableView reloadData];
    //滚动到底部
    NSIndexPath *path = [NSIndexPath indexPathForRow:_resultController.fetchedObjects.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
    
    //判断有没有附件
    //1 获取原始的xml 数据
    XMPPMessage *msg = msgObj.message;
    //获取类型
    NSString *bodyType = [msg attributeStringValueForName:@"bodyType"];
    
    if([bodyType isEqualToString:@"image"]){
        //2 遍历message的子节点
        NSArray *child = msg.children;
        for(XMPPElement *node in child){
            //获取节点名字
            if([[node name] isEqualToString:@"attachment"]){
                //获取附件字符串，然后转成NSData,接转成图片
                NSString *imgBase64Str = [node stringValue];
                NSData *imgData = [[NSData alloc]initWithBase64EncodedString:imgBase64Str options:0];
                UIImage *img = [UIImage imageWithData:imgData];
                cell.imageView.image = img;
            }
        }
    }else if([bodyType isEqualToString:@"sound"]){//音频
        
    }else{//纯文本
        cell.textLabel.text = msgObj.body;
    }
    return cell;
}
#pragma mark -UITableViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //发送消息
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    [msg addBody:self.textField.text];
    
    [[WCXMPPTool sharedXMPPTool].xmppStream sendElement:msg];
    
    //清空
    self.textField.text = nil;
    
    return YES;
}

#pragma mark - 选择附件
- (IBAction)acctchBtnClick:(id)sender {
    UIImagePickerController *imgController = [[UIImagePickerController alloc]init];
    imgController.editing = NO;
    imgController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgController.delegate = self;
    
    [self presentViewController:imgController animated:YES completion:nil];
}

#pragma mark -UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSLog(@"%@",info);
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    [self sendAttatchmentWithData:UIImagePNGRepresentation(img) bodyType:@"image"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 发送附件
-(void)sendAttatchmentWithData:(NSData*)data bodyType:(NSString*)bodyType{
    //把data经过"base64编码"转成字符串
    NSString *base64Str = [data base64EncodedStringWithOptions:0];
    
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    //设置类型
    [msg addAttributeWithName:@"bodyType" stringValue:bodyType];
    [msg addBody:bodyType];
    //可以通过这个区分是什么附件
    //    [msg addBody:@"sound"];
    //    [msg addBody:@"doc"];
    //    [msg addBody:@"xls"];
    
    //定义附件
    XMPPElement *attatchment = [XMPPElement elementWithName:@"attachment" stringValue:base64Str];
    //添加子节点
    [msg addChild:attatchment];
    
    [[WCXMPPTool sharedXMPPTool].xmppStream sendElement:msg];
}
@end
