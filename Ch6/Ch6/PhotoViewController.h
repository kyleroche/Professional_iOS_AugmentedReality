//
//  PhotoViewController.h
//  Ch6
//
//  Created by Kyle Roche on 9/24/11.
//  Copyright (c) 2011 Isidorey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface PhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate> {
    
}
- (IBAction)loadPhotoPicker:(id)sender;

@end
