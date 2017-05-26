//
//  ECChatController.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/24.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECChatController.h"
#import "HXMineMessageCell.h"
#import "HXMsgDatailCell.h"
#import "MineImageCell.h"
#import "OtherImageCell.h"
#import "MineVoiceCell.h"
#import "OtherVoiceCell.h"

#import "DeviceDBHelper.h"
#import "HXTextGraphicsParser.h"
#import "ECImageViewController.h"

static NSString *datilCellID = @"datilCellID";
static NSString *mineCellID = @"mineCellID";

@interface ECChatController ()<NSTableViewDataSource,NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (nonatomic , retain) NSMutableArray *messageArray;

@end

@implementation ECChatController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotification];
    
    NSNib *nib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([HXMineMessageCell class]) bundle:nil];
    NSNib *nib1 = [[NSNib alloc] initWithNibNamed:NSStringFromClass([HXMsgDatailCell class]) bundle:nil];
    [self.tableView registerNib:nib forIdentifier:mineCellID];
    [self.tableView registerNib:nib1 forIdentifier:datilCellID];
}

- (void)loadTableData {
    [self.messageArray removeAllObjects];
    NSArray* message = [[DeviceDBHelper sharedInstance] getLatestHundredMessageOfSessionId:self.sessionId andSize:MessagePageSize];
    [self.messageArray addObjectsFromArray:message];
    [self.tableView reloadData];
    [self.tableView scrollRowToVisible:self.messageArray.count - 1];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName:KNOTIFICATION_onClickSession object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.sessionId = note.object;
        [self loadTableData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:KNOTIFICATION_onMesssageChanged object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if ([note.object isKindOfClass:[NSString class]] && [note.object isEqualToString:self.sessionId]) {
            [self loadTableData];

        } else {
            if ([[note.object from] isEqualToString:self.sessionId] || ([[note.object sessionId] hasPrefix:@"g"] && self.sessionId.length)) {
                [self loadTableData];
            }
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:KNOTIFICATION_SendMessageCompletion object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self loadTableData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:KNOTIFICATION_DownloadMessageCompletion object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self loadTableData];
    }];
}

- (void)clickMineImage:(NSClickGestureRecognizer *)gesture {
    MineImageCell *tmpCell = (MineImageCell *)gesture.view.superview;
    ECImageViewController *imageVC = [ECImageViewController new];
    imageVC.localURL = tmpCell.localPath;
    imageVC.remoteURL = tmpCell.remotePath;
    [self presentViewControllerAsModalWindow:imageVC];
}

- (void)clickOtherImage:(NSClickGestureRecognizer *)gesture {
    OtherImageCell *tmpCell = (OtherImageCell *)gesture.view.superview;
    ECImageViewController *imageVC = [ECImageViewController new];
    imageVC.localURL = tmpCell.localPath;
    imageVC.remoteURL = tmpCell.remotePath;
    [self presentViewControllerAsModalWindow:imageVC];
}

#pragma mark - NSTableViewDataSource,NSTabViewDelegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.messageArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([[tableColumn identifier] isEqualToString:@"chatColumn"]) {
        ECMessage *tmpMessage = self.messageArray[row];

        //message
        switch (tmpMessage.messageBody.messageBodyType) {
            case MessageBodyType_Text: {

                if ([tmpMessage.from isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:lasttimeuser]]) {
                    HXMineMessageCell *cell = [tableView makeViewWithIdentifier:mineCellID owner:self];
                    cell.message = tmpMessage;
                    return cell;
                }
                
                HXMsgDatailCell *cell = [tableView makeViewWithIdentifier:datilCellID owner:self];
                cell.message = tmpMessage;
                return cell;
            }
                break;
                
            case MessageBodyType_Image: {
                
                if ([tmpMessage.from isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:lasttimeuser]]) {
                    MineImageCell *cell = (MineImageCell *)[tableView makeViewWithIdentifier:@"chatImgCell" owner:[tableView delegate]];
                    cell.contImageView.tag = row;
                    [cell loadImgWIthMessage:tmpMessage];
                    
                    //双击
                    NSClickGestureRecognizer *ges = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(clickMineImage:)];
                    ges.numberOfClicksRequired = 2;
                    [cell.contImageView addGestureRecognizer:ges];
                    return cell;
                }
                
                OtherImageCell *cell = (OtherImageCell *)[tableView makeViewWithIdentifier:@"chatOtherCell" owner:[tableView delegate]];
                cell.contImageView.tag = row;
                [cell loadImgWIthMessage:tmpMessage];
                
                //双击
                NSClickGestureRecognizer *ges = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(clickOtherImage:)];
                ges.numberOfClicksRequired = 2;
                [cell.contImageView addGestureRecognizer:ges];
                return cell;
            }
                break;
                
            case MessageBodyType_Voice: {
                if ([tmpMessage.from isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:lasttimeuser]]) {
                    MineVoiceCell *cell = (MineVoiceCell *)[tableView makeViewWithIdentifier:@"mineVoiceCell" owner:[tableView delegate]];
                    [cell loadImgWIthMessage:tmpMessage];
                    return cell;
                }
                
                OtherVoiceCell *cell = (OtherVoiceCell *)[tableView makeViewWithIdentifier:@"otherVoiceCell" owner:[tableView delegate]];
                [cell loadImgWIthMessage:tmpMessage];
                return cell;
            }
                break;
            default:
                break;
        }
    }
    return nil;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    ECMessage *message = self.messageArray[row];
    
    if (message.messageBody.messageBodyType == MessageBodyType_Text) {
        ECTextMessageBody *body = (ECTextMessageBody *)message.messageBody;
        HXTextGraphicsParser *parser = [HXTextGraphicsParser shareParser];
        [parser resultAttributedStringFromText:body.text];
        CGFloat height = [parser resultAttributeTextHeightForLayoutWidth:300];
        
        return height + 75;
        
    } else if (message.messageBody.messageBodyType == MessageBodyType_Image) {
        return 140.0f;
        
    } else if (message.messageBody.messageBodyType == MessageBodyType_Voice) {
        return 60.0f;
    }
    
    return 50.0f;
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView *tableView = notification.object;
    if (tableView.selectedRow >= 0) {
        ECMessage *tmpMessage = self.messageArray[tableView.selectedRow];
        
        if (tmpMessage.messageBody.messageBodyType == MessageBodyType_Voice) {
            ECVoiceMessageBody* mediaBody = (ECVoiceMessageBody*)tmpMessage.messageBody;
            if (mediaBody.localPath.length>0 && [[NSFileManager defaultManager] fileExistsAtPath:mediaBody.localPath]) {
                [[ECDevice sharedInstance].messageManager playVoiceMessage:(ECVoiceMessageBody*)tmpMessage.messageBody
                                                                completion:^(ECError *error) {}];
            }
        }
    }
}

#pragma mark - lazy
-(NSMutableArray *)messageArray {
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}

@end
