//
//  RootViewController.h
//  Ch13
//
//  Created by Kyle Roche on 9/26/11.
//  Copyright Isidorey 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceDetectionLayer.h"

@interface RootViewController : UIViewController {
    
}
@property (retain) FaceDetectionLayer* fdLayer;
-(void)updateMood:(NSString*)mood;
@end
