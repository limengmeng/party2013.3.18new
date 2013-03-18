//
//  CreatBeforeViewController.m
//  party
//
//  Created by mac bookpro on 13-3-12.
//
//

#import "CreatBeforeViewController.h"
#import "CheckOneViewController.h"


@interface CreatBeforeViewController ()

@end

@implementation CreatBeforeViewController
@synthesize type;
@synthesize city;
@synthesize local;
@synthesize lat;
@synthesize lng;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    addrLabel.text=[NSString stringWithFormat:@"%@ %@",self.city,self.local];
    
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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:248.0/255 green:247.0/255 blue:246.0/255 alpha:1];
	// Do any additional setup after loading the view.
    
    //**********************************地点*****************************************
    addrLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, 280, 21)];
    addrLabel.textColor=[UIColor lightGrayColor];
    addrLabel.backgroundColor=[UIColor clearColor];
    addrLabel.font=[UIFont systemFontOfSize:14.0];
    addrLabel.text=@"地点:";
    [self.view addSubview:addrLabel];
    [addrLabel release];
    //**********************************地点 end*****************************************

    
    //**********************************账号*****************************************
    UITextField *field1=[[UITextField alloc]initWithFrame:CGRectMake(20, 40, 280, 40)];
    field1.borderStyle=UITextBorderStyleBezel;
    field1.background = [UIImage imageNamed:@"ArrowRightS@2x"];
    field1.userInteractionEnabled=NO;
    [self.view addSubview:field1];
    
    //账号栏
    name =[[UITextField alloc]initWithFrame:CGRectMake(85, 40, 220, 40)];
    [name setFont:[UIFont fontWithName:@"Arial" size:12.0]];
    name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    name.backgroundColor=[UIColor clearColor];
    name.textColor=[UIColor lightGrayColor];
    [name becomeFirstResponder];
    name.delegate=self;
    [name addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:name];
    
    UILabel *labelName=[[UILabel alloc]initWithFrame:CGRectMake(27, 40, 60, 40)];
    labelName.text=@"活动名称：";
    labelName.textColor=[UIColor lightGrayColor];
    [labelName setFont:[UIFont fontWithName:@"Arial" size:12.0]];
    labelName.backgroundColor=[UIColor clearColor];
    [self.view addSubview:labelName];
    [labelName release];
    [field1 release];
    //**********************************账号 end*****************************************
    
    //**********************************手机号*****************************************
    UITextField *field3=[[UITextField alloc]initWithFrame:CGRectMake(20, 100, 280, 40)];
    field3.backgroundColor=[UIColor clearColor];
    field3.background = [UIImage imageNamed:@"ArrowRightS@2x"];
    field3.userInteractionEnabled=NO;
    [self.view addSubview:field3];
    //手机号栏
    phone =[[UITextField alloc]initWithFrame:CGRectMake(85, 100, 220, 40)];
    [phone setFont:[UIFont fontWithName:@"Arial" size:12.0]];
    phone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phone.backgroundColor=[UIColor clearColor];
    phone.textColor=[UIColor lightGrayColor];
    [phone becomeFirstResponder];
    phone.delegate=self;
    phone.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:phone];
    
    UILabel *labelTime=[[UILabel alloc]initWithFrame:CGRectMake(27, 100, 80, 40)];
    labelTime.text=@"活动时间：";
    labelTime.textColor=[UIColor lightGrayColor];
    [labelTime setFont:[UIFont fontWithName:@"Arial" size:12.0]];
    labelTime.backgroundColor=[UIColor clearColor];
    [self.view addSubview:labelTime];
    [labelTime release];
    [field3 release];
    //**********************************手机号end*****************************************
    
    UILabel *intro=[[UILabel alloc]initWithFrame:CGRectMake(35, 140, 290, 40)];
    intro.text=@"填写活动名称和活动时间 让你的活动更具体";
    intro.font=[UIFont systemFontOfSize:12.0];
    intro.backgroundColor=[UIColor clearColor];
    [self.view addSubview:intro];
    [intro release];
    
    //*******************************时间选择器*******************************
    if (DatePicker==nil) {
        DatePicker = [[UIDatePicker alloc] init];
        [DatePicker setLocale: [[[NSLocale alloc] initWithLocaleIdentifier: @"zh_CN"] autorelease]];//设置时间选择器语言环境为中文
        
        [DatePicker addTarget:self action:@selector(DatePickerChanged:) forControlEvents:UIControlEventValueChanged];
        DatePicker.datePickerMode = UIDatePickerModeDateAndTime;
        DatePicker.minimumDate = [NSDate date];
        DatePicker.minuteInterval = 10;
    }
    
    // Keyboard toolbar
    if (keyboardToolbar == nil) {
        keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", @"")
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(resignKeyboard:)];
        
        [keyboardToolbar setItems:[NSArray arrayWithObjects:spaceBarItem, doneBarItem, nil]];
        
        phone.inputAccessoryView = keyboardToolbar;
        phone.inputView = DatePicker;
        
        [spaceBarItem release];
        [doneBarItem release];
        //*******************************时间选择器 end*******************************
    }
    
    //*******************************隐藏键盘*******************************
    //点击空白区域隐藏键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    [tapGr release];
    //*******************************隐藏键盘 end*******************************
}

#pragma mark -datePicker

- (void)resignKeyboard:(id)sender
{
    time = DatePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日HH点mm分"];
    phone.text  =[formatter stringFromDate:time];
    [formatter release];
    
    id firstResponder = phone;
    [firstResponder resignFirstResponder];
    
    NSLog(@"name===%@",name.text);
    
    if (name.text==nil||[name.text isEqualToString:@""]) {
        UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请完善信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [soundAlert show];
        [soundAlert release];
    }
    else{
        
        NSLog(@"传值。。。。。====%@,%@",phone.text,name.text);
        friendList=[[CheckOneViewController alloc]init];
        
        friendList.type=self.type;
        
        friendList.spot=1;
        
        friendList.check_time=phone.text;
        
        friendList.check_name=name.text;
        
        friendList.check_city=self.city;
        
        friendList.check_local=self.local;
        
        friendList.lng=self.lng;
        
        friendList.lat=self.lat;
        
        friendList.time=time;
        
        NSLog(@"传值。。。。。====%@",friendList.time);

         NSLog(@"传值。。。。。====%@,%@",friendList.check_name,friendList.check_time);
        
        [self.navigationController pushViewController:friendList animated:YES];
        
        NSLog(@"传值。。。。。====%@",friendList.time);

        
        NSLog(@"传值。。。。。====%@,%@",friendList.check_name,friendList.check_time);

    }
}

//*******************************选择时间*******************************
- (void)DatePickerChanged:(id)sender
{
    time = DatePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日HH点mm分"];
    phone.text  =[formatter stringFromDate:time];
    [formatter release];
}
//*******************************选择时间 end*******************************

#pragma mark -textField

//*******************************隐藏键盘操作*******************************
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [name resignFirstResponder];
    //[activityPlace resignFirstResponder];
    [phone resignFirstResponder];
    //[creat resignFirstResponder];
}
//*******************************隐藏键盘操作 end*******************************

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if([phone isFirstResponder]){
        ;
    }
    else if ([name isFirstResponder]) {
        [phone becomeFirstResponder];
    }
    return YES;
}

- (void) textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    NSLog(@"%@",[_field text]);
    [self save];
}

#pragma mark -save and read

-(void)read{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir=[path objectAtIndex:0];
    //NSFileManager *fm=[NSFileManager defaultManager];
    NSString *imagePath=[docDir stringByAppendingPathComponent:@"creatBefore.txt"];
    NSMutableArray *stringmutable=[NSMutableArray arrayWithContentsOfFile:imagePath];
    name.text=[stringmutable objectAtIndex:0];
    phone.text=[stringmutable objectAtIndex:1];
}

-(void)save{
    //=========数据持久化=============================================
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSLog(@"Get document path: %@",[paths objectAtIndex:0]);
    NSString *fileName=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"creatBefore.txt"];
    NSMutableArray *uuidMutablearray=[NSMutableArray arrayWithObjects:name.text,phone.text, nil];
    //NSLog(@"sadafdasfas%@",uuidMutablearray);
    [uuidMutablearray writeToFile:fileName atomically:YES];
}

#pragma mark -others

-(void)dealloc{
    [super dealloc];
    [city release];
    [local release];
    [friendList release];
    [type release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


-(void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
