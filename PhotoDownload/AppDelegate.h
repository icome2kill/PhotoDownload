//
//  AppDelegate.h
//  PhotoDownload
//
//  Created by Nguyen on 12/18/13.
//  Copyright (c) 2013 Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoDownloadViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PhotoDownloadViewController *photoDownloadVC;
@property (strong, nonatomic) UINavigationController *navController;

@end
