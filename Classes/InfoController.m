//
//  InfoController.m
//  Table
//
//  Created by Renato Casanova on 5/31/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import "InfoController.h"
#import "BWFileManagementAdditions.h"
#import "URLConst.h"
#import "AlertStrings.h"

@interface InfoController ()

@end

@implementation InfoController
-(IBAction)finishedWritingReview:(UIStoryboardSegue*)sender
{

}
- (IBAction)emailSupport:(id)sender
{
}
- (IBAction)tellMeAboutMyApp:(id)sender {

    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    NSString *model = [[UIDevice currentDevice] model];
    NSString *version = @"1.0";
    NSString *build = @"100";
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setToRecipients:[NSArray arrayWithObjects: @"renato.casanova@me.com",nil]];
    [mailComposer setSubject:[NSString stringWithFormat: @"IdeaFactory Concern V%@ (build %@).",version,build]];
    NSString *supportText = [NSString stringWithFormat:@"Device: %@\niOS Version:%@\n\n",model,iOSVersion];
    supportText = [supportText stringByAppendingString: NSLocalizedString(@"Please describe your concern. Ill be glad to support you.", @"Some body text for when the user is going to write me a review personally")];
    [mailComposer setMessageBody:supportText isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}
//And finally, add the delegate method that will be called after “Send” or “Cancel” has been tapped by the user.

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//- (IBAction)wordsArchive:(id)sender {
//
//
//    [[NSFileManager defaultManager] resetLocalizedDataBase];
//    
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Reaload of Database", @"Title for current messase alert that warns the user the confirmation for the loading of the current database")  message:NSLocalizedString(@"Succesful in the creation of the databse", @"Body messge to adive the user of the succesful creation of the database") delegate:nil cancelButtonTitle:NSLocalizedString(@"All right.", @"Used text for dismissing a presented alert view. As Ok") otherButtonTitles: nil];
//        [alert show];
//    
//}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{


    [[NSFileManager defaultManager] resetLocalizedFactory];
    [[NSFileManager defaultManager] resetLocalizedDataBase];

    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadAllKeys)]) 
        [self.delegate reloadAllKeys];
    
}

- (IBAction)preferences:(id)sender {
    
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Warning", @"Title for alert to continue the deletion of the current premises") message:
                              NSLocalizedString(@"Loading the default premises, will cause the deletion of the current ones.", @"Deleting all the current premises main presentation")
                              delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Negate the current desivice action") otherButtonTitles: NSLocalizedString(@"erase", @"Confirmation of the current action, that will cause the deletion of the premises"),nil];
        [alert show];

}
@end
