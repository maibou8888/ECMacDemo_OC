//
//  ECSessionController.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/20.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECSessionController.h"
#import "ECSessionCell.h"
#import "IMMsgDBAccess.h"
#import "DeviceDBHelper.h"

#define EC_ROW_Height 60.0f

@interface ECSessionController ()<NSTableViewDelegate,NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@end

@implementation ECSessionController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tableView sizeLastColumnToFit];
        self.tableView.rowSizeStyle = NSTableViewRowSizeStyleCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadTableData];
    [self addNotification];
    [self getTopSessionLists];
    [self selectCellWithRow:0];
}

#pragma mark - private
-(void)loadTableData {
    [self.listArray removeAllObjects];
    [self.listArray addObjectsFromArray:[[DeviceDBHelper sharedInstance] getMyCustomSession]];
    [self.tableView reloadData];
}

- (void)getTopSessionLists {
    [[ECDevice sharedInstance].messageManager getTopSessionLists:^(ECError *error, NSArray *topContactLists) {
        
        if (error.errorCode == ECErrorType_NoError) {
            for (NSString *sessionId in topContactLists) {
                [[IMMsgDBAccess sharedInstance] updateIsTopSessionId:sessionId isTop:YES];
            }
            [DeviceDBHelper sharedInstance].sessionDic = nil;
        }
    }];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName:KNOTIFICATION_onMesssageChanged object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self loadTableData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:KNOTIFICATION_SendMessageCompletion object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self loadTableData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:KNOTIFICATION_selectContact object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        ECSession *notiSession = note.object;
        NSInteger existRow = -1;
        for (int i = 0; i < self.listArray.count; i ++) {
            ECSession *tmpSession = self.listArray[i];
            if ([tmpSession.sessionId isEqualToString:notiSession.sessionId]) {
                existRow = i;
            }
        }
        
        if (existRow != -1) {
            [self selectCellWithRow:existRow];
        } else {
            [self.listArray insertObject:notiSession atIndex:0];
            [self.tableView reloadData];
            [self selectCellWithRow:0];
        }
    }];
}

- (void)deleteRow:(NSButton *)button {
    [self.listArray removeObjectAtIndex:button.tag];
    [self.tableView reloadData];
}

- (void)selectCellWithRow:(NSInteger)row {
    if (!self.listArray.count) return;
    
    NSMutableIndexSet *mutableSet = [NSMutableIndexSet new];
    [mutableSet addIndex:row];
    [self.tableView selectRowIndexes:mutableSet byExtendingSelection:NO];
    
    ECSessionCell *selectedCell = [self.tableView viewAtColumn:0 row:row makeIfNecessary:NO];
    selectedCell.wantsLayer = YES;
    selectedCell.layer.backgroundColor = EC_RGB_String(@"#d5d4d4").CGColor;
}

#pragma mark - NSTableViewDelegate,NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.listArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

    ECSessionCell *cell = nil;
    if ([[tableColumn identifier] isEqualToString:@"SessionsColumn"]) {
        ECSession *tmpSession = self.listArray[row];
        cell = (ECSessionCell *)[tableView makeViewWithIdentifier:@"sessionCellReuse" owner:[tableView delegate]];
        cell.bageNum.title = [NSString stringWithFormat:@"%ld",(long)tmpSession.unreadCount];
        cell.offBtn.target = self;
        cell.offBtn.action = @selector(deleteRow:);
        cell.offBtn.tag = row;
        
        if ([tmpSession.sessionId hasPrefix:@"g"]) {
            NSString * name = [[IMMsgDBAccess sharedInstance] getGroupNameOfId:tmpSession.sessionId];
            cell.contentF.stringValue = tmpSession.text.length?tmpSession.text:@"";
            cell.sessionF.stringValue = name.length?name:@"";

            if (name.length ==0) {
                [[ECDevice sharedInstance].messageManager getGroupDetail:tmpSession.sessionId completion:^(ECError *error, ECGroup *group) {
                    if (error.errorCode == ECErrorType_NoError && group.name.length>0) {
                        cell.sessionF.stringValue = group.name;
                        [[IMMsgDBAccess sharedInstance] addGroupIDs:@[group]];
                    }
                }];
            }
            
        } else {
            cell.sessionF.stringValue = tmpSession.sessionId;
            cell.contentF.stringValue = tmpSession.text.length?tmpSession.text:@"";
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return EC_ROW_Height;
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView *tableView = notification.object;
    if (tableView.selectedRow >= 0) {
        ECSession *tmpSession = self.listArray[tableView.selectedRow];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onClickSession object:tmpSession.sessionId];
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)listArray {
    if (!_listArray)
        _listArray = [NSMutableArray array];
    return _listArray;
}

@end
