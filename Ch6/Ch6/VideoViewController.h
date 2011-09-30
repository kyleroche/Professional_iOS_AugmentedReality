//
//  VideoViewController.h
//  Ch6
//
//  Created by Kyle Roche on 9/25/11.
//  Copyright (c) 2011 Isidorey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>

@interface VideoViewController : UIViewController {
    
}
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

@property (strong, nonatomic) IBOutlet UIView *videoPreview;
@property (strong, nonatomic) IBOutlet UIImageView *videoImage;
- (IBAction)captureScreen:(id)sender;
@end
