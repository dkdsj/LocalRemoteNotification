//
//  AppDelegate.m
//  NotificationLocalRemote
//
//  Created by zz on 2019/4/28.
//  Copyright © 2019 zz. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

/**
     ********10之前
     //在前台 在后台收到push消息 后台点击
     -[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]
 
     ********10之后
     //在前台
     -[AppDelegate userNotificationCenter:willPresentNotification:withCompletionHandler:]
     -[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]
 
     //在后台收到push消息
     -[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]
 
     //前台点击/后台点击
     -[AppDelegate userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:]
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //推送
    //https://www.jianshu.com/p/d88d3129b3f0
    //https://www.jianshu.com/p/f5337e8f336d
    //https://www.jianshu.com/p/2f3202b5e758
    
    [self registerPush:application];
    
    return YES;
}

/**
 1.注册推送
 */
-(void)registerPush:(UIApplication *)application {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
    /**
         <UNNotificationSettings: 0x283f7ad10;
         authorizationStatus: Authorized,
         notificationCenterSetting: Enabled,
         soundSetting: Enabled,
         badgeSetting: Enabled,
         lockScreenSetting: Enabled,
         carPlaySetting: NotSupported,
         criticalAlertSetting: NotSupported,
         alertSetting: Enabled,
         alertStyle: Banner,
         providesAppNotificationSettings: No>
         */
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            };
        }];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"%@",settings);;
        }];

    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    //远程通知s
    [application registerForRemoteNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
}

/**
 2.1注册APNs失败
 */
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"注册APNS失败:%@",error);
}

/**
 2.2注册通知成功
 
 Easy APNs Provider - 推送测试工具
 https://www.jianshu.com/p/134e3dfd1cdc
 https://blog.csdn.net/QueenDecember/article/details/82422662
 */
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    // 收到token
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
      stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];

    // 保存到后台-用于推送
}


/**
 3.收到通知内容
 iOS 10: App在前台获取到通知
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    NSLog(@"%s", __func__);

    
//    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//    content.title = @"Introduction to Notifications";
//    content.subtitle = @"Session 707";
//    content.body = @"Woah! These new notifications look amazing! Don’t you agree?";
//    content.badge = @1;
//
//    //
//    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
//
//
//    NSString *reqIdentify = @"reqIdentify";
//    UNNotificationRequest *req = [UNNotificationRequest requestWithIdentifier:reqIdentify content:content trigger:trigger];
//
//    [center addNotificationRequest:req withCompletionHandler:^(NSError * _Nullable error) {
//        ;
//    }];
    
    
    // 处理 推送数据
    NSDictionary *contentDic=notification.request.content.userInfo;
    //[self handleDic:contentDic];
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(7);
}

/**
 iOS 10: 前台/后台点击通知进入App时触发
 center.delegate = self;
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSLog(@"%s", __func__);
//    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // 处理 推送数据
    NSDictionary *contentDic=response.notification.request.content.userInfo;
    //[self handleDic:contentDic];
    
    
    completionHandler();
}

/**
 {
     aps = {
         "apns-collapse-id":"com.np2.XinZhiBle",//加这个字段会将push消息折叠
 
         alert = {
             body = "\U7ea2\U62c2\U591c\U5954";
             title = "\U7ea2\U7ebf\U6807\U9898";
         };
         badge = 9;
         "content-available" = 1;
         sound = default;
     };
     }
 */


/**
 //10之前
 //在前台 在后台收到push消息 后台点击
 -[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]
 
 //10之后
 前后台收到push消息
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"%s", __func__);

    // 处理 推送数据
    //[self handleDic:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
