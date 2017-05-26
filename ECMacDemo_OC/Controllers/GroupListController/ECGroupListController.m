//
//  ECGroupListController.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/27.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECGroupListController.h"
#import "ECGroupListCell.h"
#import "IMMsgDBAccess.h"

@interface ECGroupListController ()<NSTableViewDelegate,NSTableViewDataSource>

@property (nonatomic , retain) NSMutableArray *tableDataArray;
@property (weak) IBOutlet NSTableView *groupTable;
@end

@implementation ECGroupListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //noti
    [Notification_center addObserverForName:KNOTIFICATION_onClickSession
                                     object:nil queue:[NSOperationQueue mainQueue]
                                 usingBlock:^(NSNotification * _Nonnull note) {
                                            self.groupId = note.object;
                                     
                                            if (self.groupId.length)
                                                [self getGroupMemberData];
    }];
}

- (void)getGroupMemberData {
    __weak __typeof(self) weakSelf = self;
    [[ECDevice sharedInstance].messageManager queryGroupMembers:self.groupId
                                                     completion:^(ECError *error, NSString* groupId, NSArray *members) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error.errorCode == ECErrorType_NoError) {
            
            //db
            for (ECGroupMember *member in members) {
                [[IMMsgDBAccess sharedInstance] addUserName:member.memberId name:member.display andSex:member.sex];
            }

            //datasource
            NSArray *sortArray = [members sortedArrayUsingComparator:^(ECGroupMember *obj1, ECGroupMember* obj2){
                                      if(obj1.role < obj2.role)
                                          return(NSComparisonResult)NSOrderedAscending;
                                      else
                                          return(NSComparisonResult)NSOrderedDescending;
                                 }];
            strongSelf.tableDataArray = [[NSMutableArray alloc] initWithArray:sortArray];
            
            if (strongSelf.tableDataArray.count) {
                [strongSelf.groupTable reloadData];
            }
        }
    }];
}

#pragma mark - NSTabViewDelegate,NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.tableDataArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    ECGroupListCell *cell = nil;
    if ([[tableColumn identifier] isEqualToString:@"groupListColumn"]) {
        cell = (ECGroupListCell *)[tableView makeViewWithIdentifier:@"groupListColumn" owner:[tableView delegate]];
        cell.groupImage.image = [NSImage imageNamed:@"wode_touxiang"];
        
        ECGroupMember *tmpMember = _tableDataArray[row];
        cell.memberLabel.stringValue = tmpMember.display.length?tmpMember.display:tmpMember.memberId;
    }
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 30.0f;
}
@end
