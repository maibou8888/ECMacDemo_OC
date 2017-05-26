//
//  ECNavView.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/19.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECNavView.h"


@interface ECNavView ()
@property (weak)IBOutlet NSButton *messageBtn;
@property (weak)IBOutlet NSButton *contactsBtn;
@end

@implementation ECNavView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self messageBtnClicked:self.messageBtn];
    [Notification_center addObserver:self selector:@selector(selectContact) name:KNOTIFICATION_selectContact object:nil];;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [EC_RGB_String(@"#eae9ea") set];
    NSRectFill(dirtyRect);
}

- (void)selectContact {
    [self.messageBtn setImage:EC_ImageNamed(@"menu-message-down")];
    [self.contactsBtn setImage:EC_ImageNamed(@"menu-contact-normal")];
}

- (IBAction)closeView:(id)sender {
    [[NSApplication sharedApplication] hide:self];
}

- (IBAction)hidenView:(id)sender {
    [[AppDelegate shareInstanced].window miniaturize:nil];
}

- (IBAction)zoomView:(id)sender {
    [[AppDelegate shareInstanced].window zoom:nil];
}

- (IBAction)messageBtnClicked:(id)sender {
    [self.messageBtn setImage:EC_ImageNamed(@"menu-message-down")];
    [self.contactsBtn setImage:EC_ImageNamed(@"menu-contact-normal")];
    if (self.block1)
        self.block1(sender);
}

- (IBAction)contactsBtnClicked:(id)sender {
    [self.messageBtn setImage:EC_ImageNamed(@"menu-message-normal")];
    [self.contactsBtn setImage:EC_ImageNamed(@"menu-contact-down")];
    if (self.block2)
        self.block2(sender);
}

@end
