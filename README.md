# LocalRemoteNotification
ios10本地远程通知

## //10之后
### //在前台
- -[AppDelegate userNotificationCenter:willPresentNotification:withCompletionHandler:]
- -[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]

### //在后台收到push消息
- -[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]

### //前台点击/后台点击
- -[AppDelegate userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:]


## //10之前
### //在前台 在后台收到push消息 后台点击
- -[AppDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:]
