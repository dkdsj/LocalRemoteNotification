//
//  ViewController.m
//  NotificationLocalRemote
//
//  Created by zz on 2019/4/28.
//  Copyright © 2019 zz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 创建通知
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    // 设置通知的必选参数
    // 设置通知显示的内容
    localNotification.alertBody = @"我来找你咯";
    // 设置通知发送的时间（这里设置的是当前时间延迟Ns发送，创建通知我是放在按钮点击事件中了，点击之后，按home键等待Ns即可收到推送）
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    // 解锁滑动时的事件
    localNotification.alertAction = @"磨蹭啥呢";
    // 收到推送通知时APP icon角标，这里如果设置了，那么在应用程序即将启动的时候要记得把角标清空
    // 不显示 需要加上UIUserNotificationTypeBadge
    localNotification.applicationIconBadgeNumber = 1;
    // 推送是带有声音提醒的，设置默认的字段为 UILocalNotificationDefaultSoundName
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    // 发送通知
    // 方式一：根据通知的发送时间(fireDate)发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    // 方式二：立即发送通知
    //            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

@end
