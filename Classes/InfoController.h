//
//  InfoController.h
//  Table
//
//  Created by Renato Casanova on 5/31/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@protocol InfoProtocol <NSObject>
-(void)reloadAllKeys;
@end 
@interface InfoController : UIViewController <UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
//-(IBAction)wordsArchive:(id)sender;
-(IBAction)preferences:(id)sender;

@property (nonatomic,assign) id <InfoProtocol> delegate;

-(IBAction)finishedWritingReview:(UIStoryboardSegue*)sender;
- (IBAction)tellMeAboutMyApp:(id)sender;

@end
