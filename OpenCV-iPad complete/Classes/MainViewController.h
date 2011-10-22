//
//  MainViewController.h
//  OpenCV-iPad
//
//  Created by Kyle Roche on 10/20/11.
//  Copyright (c) 2011 Isidorey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import "ASIFormDataRequest.h"

#define DETECT_IMAGE_MAX_SIZE  1024

@interface MainViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UIPopoverControllerDelegate> {
    UIImagePickerController *_imagePicker;
    UIPopoverController *_imagePopover;
}

@property (nonatomic, retain) CIDetector *detector;
@property (retain, nonatomic) IBOutlet UIImageView *cameraView;
@property (retain, nonatomic) IBOutlet UILabel *timerLabel;
@property (retain, nonatomic) IBOutlet UIToolbar *toolbar;
- (IBAction)cameraButtonClicked:(id)sender;
@end
