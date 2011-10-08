//
//  FaceDetectionLayer.m
//  Ch13
//
//  Created by Kyle Roche on 9/27/11.
//  Copyright 2011 Isidorey. All rights reserved.
//

#import "FaceDetectionLayer.h"
#import "AppDelegate.h"

@interface FaceDetectionLayer (Private)
- (void)sendSMS;
@end

@implementation FaceDetectionLayer
@synthesize root;
@synthesize label = _label;

/*+ (CCScene *)scene {
    CCScene *scene = [CCScene node];
    
    HUDLayer *hud = [HUDLayer node];
    [scene addChild:hud z:1];
    
    FaceDetectionLayer *layer = [[[FaceDetectionLayer alloc] initWithHUD:hud] autorelease];
    [scene addChild:layer];
    
    return scene;
}

- (id)initWithHUD:(HUDLayer *)hud {
    if ((self = [super init])) {
        _hud = hud;
    }
    return self;
}*/

-(id) init {
    if(self = [super init]){
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        crosshair =  [CCSprite spriteWithFile:@"crosshair.png" ];
        crosshair.position = ccp((size.width * (50.0/100)), (size.height * (1 - (50.0/100))));
        crosshair.opacity = 0;
        [self addChild:crosshair];
        
        _label = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:48];
        _label.position =  ccp( size.width /2 , size.height/2 );
        [self addChild: _label];
    }
    return self;
}

- (void)facialRecognitionRequest:(UIImage *)image {
    NSLog(@"Image width = %f height = %f",image.size.width, image.size.height);
    
    if (!_sendingRequest) {   
        _sendingRequest = YES;
        
        NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
        
        NSLog(@"Sending request");
        
        NSData * imageData = UIImageJPEGRepresentation(image, 90);
        
        NSURL * url = [NSURL URLWithString:@"http://api.face.com/faces/detect.json"];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request addPostValue:@"" forKey:@"api_key"];
        [request addPostValue:@"" forKey:@"api_secret"];
        [request addPostValue:@"all" forKey:@"attributes"];
        [request addData:imageData withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:@"filename"];
        
        [request startSynchronous];
        
        NSError *error = [request error];
        if (!error) {
            NSString *response = [request responseString];
            SBJsonParser *jsonParser = [SBJsonParser new];
            NSDictionary *feed = [jsonParser objectWithString:response error:nil];
            NSLog(@"RETURN: %@", [feed allKeys]);
            if ([[feed valueForKey:@"status"] isEqualToString:@"success"]) {
                NSLog(@"face.com request = success");
                NSDictionary *photo = [[feed objectForKey:@"photos"] objectAtIndex:0];
                double xPosition = [[[[[photo objectForKey:@"tags"] objectAtIndex:0] valueForKey:@"center"] valueForKey:@"x"] doubleValue];
                double yPosition = [[[[[photo objectForKey:@"tags"] objectAtIndex:0] valueForKey:@"center"] valueForKey:@"y"] doubleValue];
                NSString *mood = [[[[[photo objectForKey:@"tags"] objectAtIndex:0] objectForKey:@"attributes"] objectForKey:@"mood"] valueForKey:@"value"];
                //[_hud loadCrosshair:mood x:xPosition y:yPosition];
                CGSize size = [[CCDirector sharedDirector] winSize];
                crosshair.opacity = 255;
                crosshair.position = ccp((size.width * (xPosition/100)), (size.height * (1 - (yPosition/100))));
                
                [root performSelectorOnMainThread:@selector(updateMood:) withObject:mood waitUntilDone:YES];
            }
            
            //[self sendSMS];
            NSLog(@"%@",response);
        } else {
            NSLog(@"An error occured %d",[error code]);
        }
        
        _sendingRequest = NO;
        
        [pool drain];
    }   
}

- (void)sendSMS {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"Sending request");
    NSString *accountSid = @"";
    NSString *authToken = @"";
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages", accountSid, authToken, accountSid];
                   
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSLog(@"URL: %@", url);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:@"3034083446" forKey:@"To"];
    [request addPostValue:@"Angry Face Detected" forKey:@"Body"];
    [request addPostValue:@"4155992989" forKey:@"From"];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"%@",response);
    } else {
        NSLog(@"An error occured %d; %@",[error code], [request responseString]);
    }
    
    [pool drain];
}

- (void)dealloc {
    [super dealloc];
}

@end
