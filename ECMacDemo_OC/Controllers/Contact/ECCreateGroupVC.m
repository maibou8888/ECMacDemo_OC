//
//  ECCreateGroupVC.m
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/25.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECCreateGroupVC.h"
#import "ContactCell2.h"
#import "IMMsgDBAccess.h"

@interface ECCreateGroupVC ()

@property (nonatomic , retain) NSArray *tableArray;
@property (nonatomic , retain) NSMutableDictionary<NSNumber *,NSNumber *> *selectBoxDic;
@property (nonatomic , retain) NSMutableDictionary<NSNumber *,NSString *> *selectData;

@property (weak) IBOutlet NSTextField *groupNameLabel;
@property (weak) IBOutlet NSTableView *tableView;
@end

@implementation ECCreateGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
}

#pragma mark - private
- (void)loadData {
    self.selectBoxDic  = [NSMutableDictionary dictionary];
    self.selectData  = [NSMutableDictionary dictionary];
    self.title = _isDiscuss?@"创建讨论组":@"创建群组";
    self.groupNameLabel.placeholderString = _isDiscuss?@"请输入要创建的讨论组名称":@"请输入要创建的群组名称";
    
    self.tableArray = [ECCommonTools getAllAddressBookData];
    [self.tableView reloadData];
}

- (void)selectBoxClicked:(NSButton *)sender {
    NSInteger state = sender.state;
    
    if (state) {
        [self.selectBoxDic setObject:@(state) forKey:@(sender.tag)];
        [self.selectData setObject:[_tableArray[sender.tag] allValues][1] forKey:@(sender.tag)];
        
    } else {
        [self.selectBoxDic removeObjectForKey:@(sender.tag)];
        [self.selectData removeObjectForKey:@(sender.tag)];
    }
}

- (IBAction)createGroupBtnClicked:(id)sender {
    if (self.groupNameLabel.stringValue.length && self.selectData.count) {
        ECGroup * newgroup = [[ECGroup alloc] init];
        
        if (_isDiscuss) {
            newgroup.name = self.groupNameLabel.stringValue;
            newgroup.isDiscuss = YES;
            
        }else {
            newgroup.name = self.groupNameLabel.stringValue;
            newgroup.mode = ECGroupPermMode_DefaultJoin;
        }
        
        __weak __typeof(self)weakSelf = self;
        [DJProgressHUD showStatus:@"加载中..." FromView:self.view];
        [[ECDevice sharedInstance].messageManager createGroup:newgroup completion:^(ECError *error, ECGroup *group) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            if (error.errorCode == ECErrorType_NoError) {
                group.isNotice = YES;
                [[IMMsgDBAccess sharedInstance] addGroupIDs:@[group]];
                [strongSelf inviteMembers:group.groupId];
                
            } else {
                NSString* detail = error.errorDescription.length>0?[NSString stringWithFormat:@"\r描述:%@",error.errorDescription]:@"";
                NSLog(@"%@",[NSString stringWithFormat:@"错误码:%d%@",(int)error.errorCode,detail]);
            }
        }];
    }
}

- (void)inviteMembers:(NSString *)gID  {
    [[ECDevice sharedInstance].messageManager inviteJoinGroup:gID reason:@"" members:self.selectData.allValues confirm:1 completion:^(ECError *error, NSString *groupId, NSArray *members) {
        
        [DJProgressHUD dismiss];
        if(error.errorCode ==ECErrorType_NoError) {
            [Notification_center postNotificationName:KNOTIFICATION_createGroup object:nil];
            [self dismissController:self];
            
        } else {
            NSString* detail = error.errorDescription.length>0?[NSString stringWithFormat:@"\r描述:%@",error.errorDescription]:@"";
            NSLog(@"%@",[NSString stringWithFormat:@"错误码:%d%@",(int)error.errorCode,detail]);
        }
    }];
}

#pragma mark - NSTableViewDelegate,NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.tableArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    ContactCell2 *cell = (ContactCell2 *)[tableView makeViewWithIdentifier:@"ContactCell2" owner:self];
    cell.groupImage.image = [NSImage imageNamed:@"wode_touxiang"];
    cell.nameLabel.stringValue = [self.tableArray[row] allValues][0];
    cell.phoneLabel.stringValue = [self.tableArray[row] allValues][1];
    
    NSNumber *selectNum = self.selectBoxDic[@(row)];
    cell.selectBox.state = selectNum.integerValue;
    cell.selectBox.action = @selector(selectBoxClicked:);
    cell.selectBox.tag = row;
    
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 40.0f;
}

@end
