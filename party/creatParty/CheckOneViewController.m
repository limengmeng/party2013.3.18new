//
//  CheckOneViewController.m
//  NavaddTab
//
//  Created by ldci 尹 on 12-10-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CheckOneViewController.h"
#import "infoViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SDImageView+SDWebCache.h"
#import "CreatPartyViewController.h"
#import "WeiboAccount.h"

NSInteger prerow=-1;
@interface CheckOneViewController ()

@end

@implementation CheckOneViewController
@synthesize time;
@synthesize type;
@synthesize check_city;
@synthesize check_local;
@synthesize check_name;
@synthesize check_time;

@synthesize userUUid;
@synthesize from_c_id;
@synthesize from_p_id;
@synthesize playList;
@synthesize spot;

@synthesize list;
@synthesize lastIndexPath;
//@synthesize Cell;
@synthesize delegateFriend;
@synthesize lng;
@synthesize lat;


-(void)viewWillAppear:(BOOL)animated
{
    [self hideTabBar:YES];
    
    self.navigationItem.hidesBackButton=YES;
    UIButton* backbutton=[UIButton  buttonWithType:UIButtonTypeCustom];
    backbutton.frame=CGRectMake(0.0, 0.0, 36, 29);
    [backbutton setImage:[UIImage imageNamed:@"POBack@2x.png"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem* goback=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=goback;
    
    [super viewWillAppear:animated];
    [goback release];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self hideTabBar:NO];
    [super viewWillDisappear:animated];
}

- (void) hideTabBar:(BOOL) hidden {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    
    for(UIView *view in self.tabBarController.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, mainscreenhight, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, (mainscreenhight-36), view.frame.size.width, view.frame.size.height)];
            }
        }
        else
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, mainscreenhight)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,mainscreenhight-36)];//(mainscreenhight-49)*mainscreenhight/460.0)
            }
        }
    }
    
    [UIView commitAnimations];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    stateDictionary=[[NSMutableDictionary alloc]init];
    temp=0;
    
    [super viewDidLoad];
    [self getUUidForthis];
    self.view.backgroundColor=[UIColor colorWithRed:248.0/255 green:247.0/255 blue:246.0/255 alpha:1];
    self.tableView.backgroundView=nil;
    self.tableView.delegate=self;
    self.title=@"好友列表";
    //******************************右侧确认按钮************************************
    //确定
    
    if(self.spot!=3){
        UIButton* donebutton=[UIButton  buttonWithType:UIButtonTypeCustom];
        donebutton.frame=CGRectMake(0.0, 0.0, 50, 31);
        [donebutton setImage:[UIImage imageNamed:@"Editdone@2x.png"] forState:UIControlStateNormal];
        [donebutton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem* Makedone=[[UIBarButtonItem alloc]initWithCustomView:donebutton];
        self.navigationItem.rightBarButtonItem=Makedone;
        [Makedone release];
    }
    choiceFriends=[[NSMutableArray alloc]init];
    sinaFriends=[[NSMutableArray alloc]init];
    sinaList=[[NSMutableArray alloc]init];
    if(self.spot==2)
        [self loadPartydetail];
    else{
        [self loadFridetail];
        //[self loadXinDetail];
    }

    //******************************右侧确认按钮 end************************************
}



-(void)getUUidForthis
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir=[path objectAtIndex:0];
    //NSFileManager *fm=[NSFileManager defaultManager];
    NSString *imagePath=[docDir stringByAppendingPathComponent:@"myFile.txt"];
    NSMutableArray *stringmutable=[NSMutableArray arrayWithContentsOfFile:imagePath];
    NSString *stringUUID=[stringmutable objectAtIndex:0];
    NSLog(@"wwwwwwwwwwwwwwwwwwww%@",stringUUID);
    self.userUUid=stringUUID;
}

//从服务器获取好友数据
-(void)loadFridetail{
    dataFlag=1;
    NSString* str=[NSString stringWithFormat:@"mac/user/IF00009?uuid=%@",userUUid];
    NSString *stringUrl=globalURL(str);
    NSURL* url=[NSURL URLWithString:stringUrl];
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

//从服务器获取玩伴数据

-(void)loadPartydetail{
    dataFlag=2;
    NSString* str=[NSString stringWithFormat:@"mac/party/IF00007?uuid=%@&&c_id=%@",userUUid,self.from_c_id];
    NSString *stringUrl=globalURL(str);
    NSURL* url=[NSURL URLWithString:stringUrl];
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}
//从服务器获取新浪互粉好友
-(void)loadXinDetail{
    dataFlag=3;
    
    WeiboAccount *weiboShare=[[WeiboAccount alloc] init];
    weiboShare.accessToken=@"2.00raBjnBF_9IdDee1d5bb9c20tjAKX";
    weiboShare.userId=@"1650904185";
    NSString *stringUrl=[NSString stringWithFormat:@"https://api.weibo.com/2/friendships/friends/bilateral.json?uid=%@&access_token=%@",weiboShare.userId,weiboShare.accessToken];
    NSLog(@"接口1：：：：%@",stringUrl);
    NSURL* url=[NSURL URLWithString:stringUrl];
    ASIHTTPRequest* request=[ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.shouldAttemptPersistentConnection = NO;
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    //[request setDidFailSelector:@selector(requestDidFailed:)];
    [request startAsynchronous];

}


//******************************ASIHttp 代理方法************************************
-(void)requestFinished:(ASIHTTPRequest *)request
{
    if (dataFlag==3) {//新浪好友
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        sinaList=[[NSMutableArray alloc]initWithArray:[bizDic objectForKey:@"users"]];
        NSLog(@"%@",bizDic);
        NSLog(@"新浪列表finish=============%@",sinaList);
    }
    else if (dataFlag==2) {
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        playList=[[NSMutableArray alloc]initWithArray:[bizDic objectForKey:@"users"]];
        [self loadFridetail];
        NSLog(@"玩伴列表finish=============%@",self.list);
    }
    
    if(dataFlag==1){
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        list=[[NSMutableArray alloc]initWithArray:[bizDic objectForKey:@"users"]];
        NSLog(@"好友列表finish=============%@",self.list);
        [self loadXinDetail];
    }
    NSLog(@"好友列表finish=============%@",self.list);
    [self.tableView reloadData];
}

//请求失败
- ( void )requestFailed:( ASIHTTPRequest *)request
{
    NSError *error = [request error ];
    NSLog ( @"%@" ,error. userInfo );
}
//******************************ASIHttp 代理方法 end************************************

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.spot==2) {
        return 3;
    }
    else
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回好友数据
    if(section==0)
        return [self.list count];
    else if(section==1)
        return [sinaList count];
    else
        return [self.playList count];//返回玩伴数据
}

//******************************section标题************************************
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)] autorelease];
    UILabel * headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    //headerLabel.textColor = [UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1.0];
    headerLabel.textColor=[UIColor lightGrayColor];
    //headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:12];
    headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
    if(section==0){
//        if(self.spot==1||self.spot==3||self.spot==4)
//            headerLabel.text =  @"";
//        else
            headerLabel.text =  @"好友列表";
    }
    if(section==1)
        headerLabel.text=@"新浪互粉";
    if(section==2)
        headerLabel.text = @"玩伴列表";
    [customView addSubview:headerLabel];
    return customView;
}
//******************************section标题 end************************************

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        if(self.spot==1||self.spot==3||self.spot==4)
            return 0;
        else
            return 40;
    }
    else
        return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    
    if (cell==nil) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"]autorelease];
    }
    
    for (UIView *views in cell.contentView.subviews)
    {
        [views removeFromSuperview];
    }
    
    NSUInteger row=[indexPath row];
    NSDictionary *dic=[NSDictionary dictionary];
    if(indexPath.section==0){
        dic=[self.list objectAtIndex:row];
        NSLog(@"好友列表=============%@",self.list);
    }
    else if(indexPath.section==1){
        dic=[sinaList objectAtIndex:row];
        //NSLog(@"新浪互粉=============%@",sinaList);
    }
    else if(indexPath.section==2){
        dic=[self.playList objectAtIndex:row];
        NSLog(@"玩伴列表=============%@",self.playList);
    }
    
    
//*****************************头像**************************************
    UIImageView* imgView=[[UIImageView alloc]initWithFrame:CGRectMake(9, 8, 39, 39)];
    NSURL* imageurl;
    if(indexPath.section==1) imageurl=[NSURL URLWithString:[dic objectForKey:@"avatar_large"]];
    else
        imageurl=[NSURL URLWithString:[dic objectForKey:@"USER_PIC"]];
    [imgView setImageWithURL: imageurl refreshCache:NO placeholderImage:[UIImage imageNamed:@"placeholderImage@2x.png"]];
    [cell.contentView addSubview:imgView];
    [imgView release];
    //*****************************头像 end**************************************
    
    //*****************************性别***********************************
    UIImageView* seximage=[[UIImageView alloc]initWithFrame:CGRectMake(58, 12, 11, 13)];
    if(indexPath.section==1){
        if([[[dic objectForKey:@"gender"]substringToIndex:1] isEqualToString:@"m"])
            seximage.image=[UIImage imageNamed:@"PRmale1@2x.png"];
        else
            seximage.image=[UIImage imageNamed:@"PRfemale1@2x.png"];
    }else{
        if([[[dic objectForKey:@"USER_SEX"]substringToIndex:1] isEqualToString:@"M"])
            seximage.image=[UIImage imageNamed:@"PRmale1@2x.png"];
        else
            seximage.image=[UIImage imageNamed:@"PRfemale1@2x.png"];
    }
    [cell.contentView addSubview:seximage];
    [seximage release];
    //*****************************性别 end***********************************
    
    //*****************************姓名***********************************
    UILabel* namelabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 9, 200, 20)];
    namelabel.font=[UIFont systemFontOfSize:14];
    if(indexPath.section==1) namelabel.text=[dic objectForKey:@"name"];
    else
        namelabel.text=[dic objectForKey:@"USER_NICK"];
    namelabel.textColor=[UIColor colorWithRed:96.0/255 green:95.0/255 blue:111.0/255 alpha:1];
    namelabel.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:namelabel];
    [namelabel release];
    //*****************************姓名 end***********************************
    
    //*****************************年龄***********************************
    UILabel* agelabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 25 , 25, 30)];
    agelabel.font=[UIFont systemFontOfSize:13];
    agelabel.backgroundColor=[UIColor clearColor];
    agelabel.textColor=[UIColor grayColor];
    if(indexPath.section!=1) agelabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"USER_AGE"]];
    [cell.contentView addSubview:agelabel];
    [agelabel release];
    //*****************************年龄 end***********************************
    if (indexPath.section==1) {
        //*****************************城市 地区***********************************
        UILabel* citylabel=[[UILabel alloc]initWithFrame:CGRectMake(75, 25, 100, 30)];
        citylabel.font=[UIFont systemFontOfSize:13];
        citylabel.backgroundColor=[UIColor clearColor];
        citylabel.textColor=[UIColor grayColor];
        if (![[dic objectForKey:@"location"] isEqualToString:@"(null)"]) {
            citylabel.text=[dic objectForKey:@"location"];
        }
        [cell.contentView addSubview:citylabel];
        [citylabel release];
        //*****************************城市 地区 end**********************************
    }else{
        //*****************************城市 地区***********************************
        UILabel* citylabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 25, 40, 30)];
        citylabel.font=[UIFont systemFontOfSize:13];
        citylabel.backgroundColor=[UIColor clearColor];
        citylabel.textColor=[UIColor grayColor];
        if (![[dic objectForKey:@"USER_CITY"] isEqualToString:@"(null)"]) {
            citylabel.text=[dic objectForKey:@"USER_CITY"];
        }
        
        UILabel* locallabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 25, 40, 30)];
        locallabel.font=[UIFont systemFontOfSize:13];
        locallabel.backgroundColor=[UIColor clearColor];
        locallabel.textColor=[UIColor grayColor];
        if (![[dic objectForKey:@"USER_LOCAL"] isEqualToString:@"(null)"]) {
            locallabel.text=[dic objectForKey:@"USER_LOCAL"];
        }
        [cell.contentView addSubview:citylabel];
        [cell.contentView addSubview:locallabel];
        [citylabel release];
        [locallabel release];
    }
    //*****************************城市 地区 end**********************************
    if (self.spot!=3) {
        UIImageView *imagView=[[UIImageView alloc]initWithFrame:CGRectMake(289,19,21,21)];
        imagView.image=[UIImage imageNamed:@"check1@2x.png"];
        imagView.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:imagView];
        [imagView release];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    // Set cell label
    NSString *key = [@"Row " stringByAppendingFormat:@"%d,%d",indexPath.section,indexPath.row];
    //cell.textLabel.text = key;
    
    // Set cell checkmark
    NSNumber *checked = [stateDictionary objectForKey:key];
    if (!checked) [stateDictionary setObject:(checked = [NSNumber numberWithBool:NO]) forKey:key];
    cell.accessoryType = checked.boolValue ? UITableViewCellAccessoryCheckmark :  UITableViewCellAccessoryNone;
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(cell.accessoryType==UITableViewCellAccessoryCheckmark){
        //************************添加对勾************************************
        UIImage *image= [UIImage   imageNamed:@"checkcell@2x.png"];
        CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
        button.frame = frame;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        cell.accessoryView=button;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Recover the cell and key
	UITableViewCell *newcell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *key = [@"Row " stringByAppendingFormat:@"%d,%d",indexPath.section,indexPath.row];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
	// Created an inverted value and store it
	BOOL isChecked = !([[stateDictionary objectForKey:key] boolValue]);
    
    
	NSNumber *checked = [NSNumber numberWithBool:isChecked];
    
    
	[stateDictionary setObject:checked forKey:key];
	
    
	// Update the cell accessory checkmark
	newcell.accessoryType = isChecked ? UITableViewCellAccessoryCheckmark :  UITableViewCellAccessoryNone;
    
    
    //******************************查看好友详细信息************************************
    if (spot==3) {
        if(indexPath.section!=1){
            newcell.accessoryType=UITableViewCellAccessoryNone;
            self.hidesBottomBarWhenPushed=YES;
            infoViewController *info=[[infoViewController alloc]init];
            info.user_id=[[self.list objectAtIndex:indexPath.row] objectForKey:@"USER_ID"];
            [self.navigationController pushViewController:info animated:YES];
            self.hidesBottomBarWhenPushed=NO;
            [info release];
        }
        else{
            newcell.accessoryType=UITableViewCellAccessoryNone;
        }
    }
    //******************************查看好友详细信息 end************************************
    else{
        if(newcell.accessoryType==UITableViewCellAccessoryCheckmark){
            if (temp<5) {
                //if(newcell.accessoryType=UITableViewCellAccessoryCheckmark){
                //************************添加对勾************************************
                UIImage *image= [UIImage   imageNamed:@"checkcell@2x.png"];
                CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
                button.frame = frame;
                [button setBackgroundImage:image forState:UIControlStateNormal];
                button.backgroundColor = [UIColor clearColor];
                newcell.accessoryView=button;
                //[newcell.contentView addSubview:button];
                //************************添加对勾 end************************************
                if(indexPath.section==0)
                    [choiceFriends addObject:[self.list objectAtIndex:indexPath.row]];
                else if (indexPath.section==1)
                    [sinaFriends addObject:[sinaList objectAtIndex:indexPath.row]];
                else
                    [choiceFriends addObject:[self.playList objectAtIndex:indexPath.row]];
                if(self.spot==1) temp++;
                //}
            }else{
                [stateDictionary setObject:[NSNumber numberWithBool:NO] forKey:key];
                newcell.accessoryType=UITableViewCellAccessoryNone;//超过5人不能继续添加
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"人数不能超过5人" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
        }
        else{
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor= [UIColor clearColor];
            newcell.accessoryView= button;
            [stateDictionary setObject:[NSNumber numberWithBool:NO] forKey:key];
            newcell.accessoryType=UITableViewCellAccessoryNone;//超过5人不能继续添加
            if(indexPath.section==0)
                [choiceFriends removeObject:[self.list objectAtIndex:indexPath.row]];
            else if(indexPath.section==1)
                [sinaFriends removeObject:[sinaList objectAtIndex:indexPath.row]];
            if(self.spot==1) temp--;
        }
        //lastIndexPath=indexPath;
    }
}

//******************************上传邀请好友信息************************************
-(void)rightAction{
    
    if (self.from_p_id!=0) {
        NSString* str=@"mac/party/IF00023";
        NSString* strURL=globalURL(str);
        NSURL* url=[NSURL URLWithString:strURL];
        for (int i=0; i<[choiceFriends count]; i++) {
            ASIFormDataRequest *request =  [ASIFormDataRequest  requestWithURL:url];
            [request setPostValue:self.userUUid forKey: @"uuid"];
            [request setPostValue:[[choiceFriends objectAtIndex:i] objectForKey:@"USER_ID"] forKey:@"user_id"];
            [request setPostValue:self.from_p_id forKey:@"p_id"];
            //[request setDelegate:self];
            [request startSynchronous];
        }
    }
    
    NSLog(@"self.choiceFriends=======%@",choiceFriends);
    NSLog(@"self.choiceFriends=======%@",sinaFriends);
    
    NSLog(@"传值。。。。。。%@,%@",self.check_time,self.check_name);
    
    party=[[CreatPartyViewController alloc]init];
    
    party.from_P_type=self.type;
    
    party.P_title=self.check_name;
    
    party.P_time=self.check_time;
    
    party.map_city=self.check_city;
    
    party.map_local=self.check_local;
    
    party.friengArr=choiceFriends;
    
    party.sinaArr=sinaFriends;
    
    party.lat=self.lat;
    
    party.lng=self.lng;
    
    party.time=self.time;
    
    NSLog(@"self.choiceFriends=======%@",choiceFriends);
    NSLog(@"self.choiceFriends=======%@",sinaFriends);
    
    NSLog(@"传值。。。。。====%@",self.time);
    
    NSLog(@"self.choiceFriends=======%@",party.friengArr);
    
    NSLog(@"传值。。。。。。%@,%@",party.P_title,party.P_time);
    
    [self.navigationController pushViewController:party animated:YES];
    
    NSLog(@"传值。。。。。====%@",party.time);

    
    NSLog(@"传值。。。。。。%@,%@",party.P_title,party.P_time);

    NSLog(@"self.choiceFriends=======%@",party.friengArr);
    
    
    
    if(self.spot==1){
        if (self.from_p_id==0)
            [delegateFriend CallBack:choiceFriends];
        //[self.choiceFriends removeAllObjects];
    }
}
//******************************上传邀请好友信息 end************************************

//******************************删除好友************************************


- (UITableViewCellEditingStyle)tableView:(UITableView *)tv editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.spot==3) {
        if(indexPath.section!=1)
            return UITableViewCellEditingStyleDelete;
        else{
            return UITableViewCellAccessoryNone;
        }
    }else
        return UITableViewCellEditingStyleNone;
	//不能是UITableViewCellEditingStyleNone
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.spot==3) {
        NSString* str=@"mac/user/IF00022";
        NSString* strURL=globalURL(str);
        NSURL* url=[NSURL URLWithString:strURL];
        ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
        [rrequest setPostValue:self.userUUid forKey:@"uuid"];
        [rrequest setPostValue:[[self.list objectAtIndex:indexPath.row] objectForKey:@"USER_ID"] forKey:@"user_id"];
        NSLog(@"user_id====%@",[self.list objectAtIndex:indexPath.row]);
        [rrequest startSynchronous];
        
        [self.list removeObjectAtIndex:indexPath.row];
        
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
        
        [self.tableView reloadData];
    }
}
//******************************删除好友 end************************************

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==0) {
        UIView* footerview=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)]autorelease];
        footerview.backgroundColor=[UIColor clearColor];
        UIButton* morebutton=[UIButton buttonWithType:UIButtonTypeCustom];
        morebutton.frame=CGRectMake(57, 10, 206, 32);
        [morebutton setImage:[UIImage imageNamed:@"searchMore@2x.png"] forState:UIControlStateNormal];
        [morebutton addTarget:self action:@selector(listclickmore) forControlEvents:UIControlEventTouchDown];
        [footerview addSubview:morebutton];
        return footerview;
    }
    else if(section==1){
        UIView* footerview=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)]autorelease];
        footerview.backgroundColor=[UIColor clearColor];
        UIButton* morebutton=[UIButton buttonWithType:UIButtonTypeCustom];
        morebutton.frame=CGRectMake(57, 10, 206, 32);
        [morebutton setImage:[UIImage imageNamed:@"searchMore@2x.png"] forState:UIControlStateNormal];
        [morebutton addTarget:self action:@selector(sinaListclickmore) forControlEvents:UIControlEventTouchDown];
        [footerview addSubview:morebutton];
        return footerview;
    }
    else if(section==2){
        UIView* footerview=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)]autorelease];
        footerview.backgroundColor=[UIColor clearColor];
        UIButton* morebutton=[UIButton buttonWithType:UIButtonTypeCustom];
        morebutton.frame=CGRectMake(57, 10, 206, 32);
        [morebutton setImage:[UIImage imageNamed:@"searchMore@2x.png"] forState:UIControlStateNormal];
        [morebutton addTarget:self action:@selector(friendListclickmore) forControlEvents:UIControlEventTouchDown];
        [footerview addSubview:morebutton];
        return footerview;
    }
    return nil;
}
//本地加载更多
-(void)listclickmore{
    ;
}
//新浪加载更多
-(void)sinaListclickmore{
    ;
}
//玩伴加载更多
-(void)friendListclickmore{
    ;
}
-(void)dealloc{
    [super dealloc];
    [party release];
    [check_name release];
    [check_time release];
    [stateDictionary release];
    [time release];
    [choiceFriends release];
    [sinaFriends release];
}

-(void)back
{
    [[ASIHTTPRequest sharedQueue] cancelAllOperations];
    //中断之前的网络请求
    [self.navigationController popViewControllerAnimated:YES];
}


@end
