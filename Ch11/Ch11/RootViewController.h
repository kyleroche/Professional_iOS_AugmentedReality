//
//  RootViewController.h
//  Ch11
//
//  Created by Kyle Roche on 10/4/11.
//  Copyright (c) 2011 Apress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class ARController;

@interface RootViewController : UIViewController <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate> {
    NSArray *_permissions;
    FBRequest *_friendsRequest;
    FBRequest *_checkinRequest;
}

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) ARController *arController;

@end
