//
//  ECAddContactVC.m
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/22.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECAddContactVC.h"
#import "ECTalkViewController.h"
#import "ECCreateGroupVC.h"
#import "ECContactModel.h"
#import "ContactCell.h"
#import "ContactCell1.h"
#import "ECSession.h"

@interface ECAddContactVC ()<NSOutlineViewDelegate,NSOutlineViewDataSource,NSMenuDelegate>

@property (weak) IBOutlet NSButton *addBtn;
@property (weak) IBOutlet NSImageView *sepImageView;
@property (weak) IBOutlet NSOutlineView *contactView;
@property (strong) IBOutlet NSMenu *addMenu;

@property (nonatomic , retain) ECContactModel *dataModel;
@end

@implementation ECAddContactVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.addBtn.wantsLayer = YES;
    self.addBtn.layer.cornerRadius  = 2.0f;
    self.addBtn.layer.borderWidth   = 1.0f;
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.borderColor   = BorderColor;
    
    self.sepImageView.wantsLayer = YES;
    self.sepImageView.layer.backgroundColor = BorderColor;
    
    [self addNotification];
    [self loadTreeData];
}

- (void)addNotification {
    [Notification_center addObserverForName:KNOTIFICATION_createGroup object:nil
                                      queue:[NSOperationQueue mainQueue]
                                 usingBlock:^(NSNotification * _Nonnull note) {
                                     [self loadTreeData];
                                 }];
}

#pragma mark - private
- (void)loadTreeData {
    [self.dataModel.nodes removeAllObjects];
    
    ECContactModel *groupModel = [ECContactModel new];
    groupModel.nodeName = @"群组";
    
    ECContactModel *discussModel = [ECContactModel new];
    discussModel.nodeName = @"讨论组";
    
    ECContactModel *contactModel = [ECContactModel new];
    contactModel.nodeName = @"联系人";
    
    NSMutableArray *contacts = [ECCommonTools getAllAddressBookData];
    for (NSDictionary *tmpDic in contacts) {
        ECContactModel *tmpModel = [ECContactModel new];
        tmpModel.nodeName  = tmpDic.allValues[0];
        tmpModel.nodePhone = tmpDic.allValues[1];
        [contactModel.nodes addObject:tmpModel];
    }
    [_dataModel.nodes addObject:contactModel];
    
    [[ECDevice sharedInstance].messageManager queryOwnGroupsWith:ECGroupType_All completion:^(ECError *error, NSArray *groups) {
        if (error.errorCode == ECErrorType_NoError) {
            
            for (ECGroup *tmpGroup in groups) {
                ECContactModel *tmpModel = [ECContactModel new];
                tmpModel.nodeName = tmpGroup.name;
                tmpModel.groupId = tmpGroup.groupId;
                
                if (tmpGroup.isDiscuss) {
                    tmpModel.isDiscuss = YES;
                    [discussModel.nodes addObject:tmpModel];
                    
                } else {
                    tmpModel.isDiscuss = NO;
                    [groupModel.nodes addObject:tmpModel];
                }
            }
            
            if (discussModel.nodes.count)
                [_dataModel.nodes insertObject:discussModel atIndex:0];
            if (groupModel.nodes.count)
                [_dataModel.nodes insertObject:groupModel atIndex:0];
            
            [self.contactView reloadData];
            [self.contactView setDoubleAction:@selector(doubleAction:)];
            
        } else {
            NSString* detail = error.errorDescription.length>0?[NSString stringWithFormat:@"\r描述:%@",error.errorDescription]:@"";
            NSLog(@"获取群组失败 --- %@",[NSString stringWithFormat:@"错误码:%d%@",(int)error.errorCode,detail]);
        }
    }];
}

- (void)doubleAction:(id)sender {
    NSInteger row = [self.contactView selectedRow];
    ECContactModel *model = (ECContactModel*)[self.contactView itemAtRow:row];
    
    if (model.nodes.count <= 0) {
        ECSession *notiSession = [ECSession new];
        notiSession.sessionId = model.groupId.length?model.groupId:model.nodePhone;
        [Notification_center postNotificationName:KNOTIFICATION_selectContact object:notiSession];
    }
}

- (IBAction)addFriendBtnClicked:(id)sender {
    NSButton *button = (NSButton *)sender;
    NSPoint  point   = button.frame.origin;
    point.x = point.x + 12;
    point.y = point.y - 12;
    
    [self.addMenu popUpMenuPositioningItem:nil atLocation:point inView:self.view];
}

-(ECContactModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [ECContactModel new];
    }
    
    return _dataModel;
}

#pragma mark - menu Action
- (IBAction)accountItemClicked:(id)sender {
    ECTalkViewController *talkVC = [ECTalkViewController new];
    [self presentViewControllerAsModalWindow:talkVC];
}

- (IBAction)groupItemClicked:(id)sender {
    ECCreateGroupVC *groupVC = [ECCreateGroupVC new];
    [self presentViewControllerAsModalWindow:groupVC];
}

- (IBAction)discussItemClicked:(id)sender {
    ECCreateGroupVC *groupVC = [ECCreateGroupVC new];
    groupVC.isDiscuss = YES;
    [self presentViewControllerAsModalWindow:groupVC];
}

#pragma mark - NSOutlineViewDataSource
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if(!item){
        return [self.dataModel.nodes count];
        
    } else{
        ECContactModel *nodeModel = item;
        return [nodeModel.nodes count];
    }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if(!item){
        return self.dataModel.nodes[index];
        
    }else{
        ECContactModel *nodeModel = item;
        return nodeModel.nodes[index];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if(!item){
        return [self.dataModel.nodes count]>0;
        
    }else{
        ECContactModel *nodeModel = item;
        return [nodeModel.nodes count]>0;
    }
}

#pragma mark - NSOutlineViewDelegate
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    ContactCell *cell = (ContactCell *)[outlineView makeViewWithIdentifier:@"ContactCell" owner:self];
    ContactCell1 *cell1 = (ContactCell1 *)[outlineView makeViewWithIdentifier:@"ContactCell1" owner:self];
    
    ECContactModel *model = item;
    if (model.nodePhone.length) {
        cell1.imageView.image = [NSImage imageNamed:@"wode_touxiang"];
        cell1.nameLabel.stringValue = model.nodeName;
        cell1.phoneLabel.stringValue = model.nodePhone;
        return cell1;
    }
    
    if([[model nodes] count] <= 0){
        [cell.imageView setHidden:NO];
        cell.textField.frame = CGRectMake(30, 10, 316, 20);
        cell.imageView.image = [NSImage imageNamed:NSImageNameListViewTemplate];
        cell.textField.stringValue = model.nodeName;
        
    }else {
        [cell.imageView setHidden:YES];
        cell.textField.frame = CGRectMake(5, 10, 316, 20);
        cell.textField.stringValue = [NSString stringWithFormat:@"%@(%lu)",model.nodeName,(unsigned long)model.nodes.count];
    }
    
    return cell;
}

-(CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
    return 40.0f;
}

@end
