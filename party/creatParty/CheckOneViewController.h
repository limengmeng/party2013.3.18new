//
//  CheckOneViewController.h
//  NavaddTab
//
//  Created by ldci 尹 on 12-10-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASIHTTPRequest;
@class CreatPartyViewController;

@protocol ContactCtrlDelegate

//回调关闭窗口
- (void)CallBack:(NSMutableArray *)muArr; //回调传值

@end
//#import "SecondLevelViewController.h"
@interface CheckOneViewController : UITableViewController
{
    NSMutableArray* list;//好友列表
    NSMutableArray* playList;//玩伴列表
    
    NSIndexPath* lastIndexPath;
    //UITableViewCell* Cell;
    NSMutableArray *choiceFriends;
    int temp;
    id <ContactCtrlDelegate>delegateFriend;
    int spot;//识别
    
    NSString *from_p_id;
    
    NSString *from_c_id;
    
    NSString *userUUid;
    
    int dataFlag;
    
    CreatPartyViewController *party;
    
    NSString *check_name;
    NSString *check_time;
    NSString *check_city;
    NSString *check_local;
    
    NSString *type;
    float lat;
    float lng;
    
    NSDate *time;
    
    NSMutableDictionary *stateDictionary;
}

@property (retain) NSMutableDictionary *stateDictionary;

@property (nonatomic,retain) NSDate *time;
@property  float lat;
@property  float lng;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *check_name;
@property (nonatomic,retain) NSString *check_time;
@property (nonatomic,retain) NSString *check_city;
@property (nonatomic,retain) NSString *check_local;


@property (nonatomic,retain) NSString *userUUid;
@property (nonatomic,retain) NSString *from_c_id;
@property (nonatomic,retain) NSString *from_p_id;
@property int spot;
@property (strong,nonatomic) NSMutableArray* list;
@property (strong,nonatomic) NSMutableArray* playList;

@property (strong,nonatomic) NSIndexPath* lastIndexPath;
//@property (strong,nonatomic) IBOutlet UITableViewCell* Cell;
@property(nonatomic,retain)id <ContactCtrlDelegate>delegateFriend;
@property (nonatomic,retain) NSMutableArray *choiceFriends;
@end
