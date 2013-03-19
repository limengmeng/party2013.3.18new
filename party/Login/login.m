//
//  login.m
//  resign
//
//  Created by mac bookpro on 1/26/13.
//  Copyright (c) 2013 mac bookpro. All rights reserved.
//

#import "login.h"

@implementation login
@synthesize field1,field2,button1,button2,button,mail,pass;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //*****************************注册或登录*************************************
        field1=[[UITextField alloc]initWithFrame:CGRectMake(51, 32, 223, 40.5)];
        //field1.frame=CGRectMake(51, 32, 223, 40.5);
        field1.placeholder=@"登录邮箱";
        field1.font=[UIFont systemFontOfSize:14];
        field1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        field1.delegate = self;
        
        NSLog(@"field1.retainCount=====%d",field1.retainCount);
        
        UITextField *mailFiled=[[UITextField alloc]initWithFrame:CGRectMake(7, 32, 267, 40.5)];
        mailFiled.backgroundColor=[UIColor clearColor];
        mailFiled.userInteractionEnabled=NO;
        mailFiled.background = [UIImage imageNamed:@"ycombouser@2x.png"];
        [self addSubview:mailFiled];
        [mailFiled release];
        [self addSubview:field1];
        [field1 release];
        NSLog(@"field1.retainCount=====%d",field1.retainCount);

        //*****************************注册或登录 end*************************************
        
        //*****************************密码*************************************
        field2=[[UITextField alloc]initWithFrame:CGRectMake(51, 78, 223, 40.5)];
        field2.placeholder=@"密码";
        field2.font=[UIFont systemFontOfSize:14];
        field2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        field2.secureTextEntry = YES;
        //self.field2.backgroundColor=[UIColor redColor];
        field2.delegate = self;
        field2.returnKeyType = UIReturnKeyGo;
        
        NSLog(@"field2.retainCount=====%d",field2.retainCount);

        
        UITextField *mailFiled1=[[UITextField alloc]initWithFrame:CGRectMake(7, 78, 267, 40.5)];
        mailFiled1.backgroundColor=[UIColor clearColor];
        mailFiled1.userInteractionEnabled=NO;
        mailFiled1.background = [UIImage imageNamed:@"ycombopass@2x.png"];
        [self addSubview:mailFiled1];
        [mailFiled1 release];
        
        [self addSubview:field2];
        [field2 release];
        NSLog(@"field2.retainCount=====%d",field2.retainCount);

        //*****************************密码 end*************************************
        
        //*******************************忘了按钮*********************************
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(214, 75, 60, 44);
        button.backgroundColor=[UIColor clearColor];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitle:@"忘了" forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        NSLog(@"self.button.retainCount=====%d",button.retainCount);
        [self addSubview:button];
        NSLog(@"self.button.retainCount=====%d",button.retainCount);

        //*******************************忘了按钮*********************************
        
        //*****************************账号转换按钮*************************************
        button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame=CGRectMake(173, 0, 110, 29);
        button1.backgroundColor=[UIColor clearColor];
        [button1 setBackgroundImage:[UIImage imageNamed:@"zhuce@2x.png"] forState:UIControlStateNormal];
        [self addSubview:button1];
        NSLog(@"self.button1.retainCount=====%d",button1.retainCount);

        //*****************************账号转换按钮 end*************************************
        
        //*****************************新浪图标*************************************
        button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame=CGRectMake(22, 128, 235, 36);
        [button2 setBackgroundImage:[UIImage imageNamed:@"ycombosina@2x.png"] forState:UIControlStateNormal];
        [button2 setBackgroundImage:[UIImage imageNamed:@"ycombosinaing@2x.png"] forState:UIControlEventTouchUpInside];
        [self addSubview:button2];
        NSLog(@"self.button.retainCount=====%d",button2.retainCount);

        //*****************************新浪图标 end*************************************
    }
    return self;
}

-(void)dealloc{
    [field1 release];
    [field2 release];
    [button release];
    [button1 release];
    [button2 release];
    [super dealloc];
}

@end
