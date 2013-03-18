//
//  forthViewController.h
//  party
//
//  Created by guo on 13-1-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "CheckOneViewController.h"
#import "MyDetailViewController.h"
#import "IDViewController.h"
#import "PrivacyViewController.h"
#import "AboutViewController.h"
#import "WeiboAccounts.h"
#import "WeiboSignIn.h"
#import "UserQuery.h"
@interface forthViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,WeiboSignInDelegate>{
    CheckOneViewController *friend;
    MyDetailViewController *person;
    IDViewController *idViewController;
    PrivacyViewController *PrivacyVC;
    AboutViewController *aboutVC;
    UITableView *tableV;
    NSDictionary *words;
    NSArray *keys;
    UIButton *button;
    
    NSString *name;//获取用户名
    BOOL Sina;//新浪绑定
    BOOL renren;//人人绑定
    BOOL bean;//豆瓣绑定
    WeiboSignIn *_weiboSignIn;
    
    NSString *userUUid;
    
    NSDictionary *dictory;
    int sinaFlag;
    int temp;
}

@property (nonatomic,retain) NSDictionary *dictory;
@property (nonatomic,retain) NSString *userUUid;
@property(nonatomic,retain)UITableView *tableV;
@property(nonatomic,retain)NSDictionary *words;
@property(nonatomic,retain)NSArray *keys;

@end


