//
//  PhotoViewController.m
//  Ch6
//
//  Created by Kyle Roche on 9/24/11.
//  Copyright (c) 2011 Isidorey. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController (Private)
- (void)sendEmailMessage:(UIImage *)image;
@end

@implementation PhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    
    // start saving files
    //NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ConvertedPNG.png"];
    //NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ConvertedJPEG.jpg"];
    
    //[UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
    //[UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];

    // optional (check for files)
    //NSError *error;
   // NSFileManager *fileMgr = [NSFileManager defaultManager];
   // NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //NSLog(@"Documents: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
}

- (void)sendEmailMessage:(UIImage *)image
{
    NSLog(@"Sending Email");
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"iOS Augmented Reality - Chapter 6"];
    [picker setToRecipients:[NSArray arrayWithObjects:@"kyle.m.roche@gmail.com", nil]];
    NSString *emailBody = @"Hi Kyle, this stuff actually works.";
    [picker setMessageBody:emailBody isHTML:NO];
    NSData *data = UIImagePNGRepresentation(image);
    [picker addAttachmentData:data mimeType:@"image/png" fileName:@"Ch6ScreenShot"];
    
    [self presentModalViewController:picker animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    /*UIAlertView *alert;
    if (error) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                           message:@"Unable to save image to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    } else { 
        alert = [[UIAlertView alloc] initWithTitle:@"Success" 
                                           message:@"Image saved to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    }
    [alert show];*/
    [self dismissModalViewControllerAnimated:NO];
    
    [self sendEmailMessage:image];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)loadPhotoPicker:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    // uncomment for front camera
    //imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront; 
    imagePicker.cameraDevice = UIImagePickerControllerCameraCaptureModeVideo;
    imagePicker.showsCameraControls = NO;
    imagePicker.toolbarHidden = YES;
    imagePicker.navigationBarHidden = YES;
    imagePicker.wantsFullScreenLayout = YES;
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    [self presentModalViewController:imagePicker animated:YES];
}
@end
