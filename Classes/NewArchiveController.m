//
//  NewArchiveController.m
//  Table
//
//  Created by Renato Casanova on 5/27/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import "NewArchiveController.h"
#import "AlertStrings.h"

@interface NewArchiveController ()
{
    BOOL isWritingAList;
    BOOL isFolderOnly;
}
@end

@implementation NewArchiveController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.listName becomeFirstResponder];
    [self.listName setDelegate:self];


    isWritingAList = YES;
    [self.TypeTitle setText:NSLocalizedString(@"newArchive", @"Cuando vas a crear un archivo nuevo")];
    
    if (isFolderOnly) {

        [self changeFileTypePressed:nil];
        [self.changeFileTypeButton setHidden:YES];
        [self.iconButton setUserInteractionEnabled:NO];
        [self.view setNeedsDisplay];
        [self.TypeTitle setText:NSLocalizedString(@"newFolder", @"Cuando vas a crear un folder nuevo")];
    }
}
-(void)setFolderCreation:(BOOL)folderOnly
{
    isFolderOnly =folderOnly;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self createNewList:nil];
    return NO;
}
- (IBAction)createNewList:(id)sender {
    if ([self.listName.text isEqualToString:kEmptyText])

    {
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:
                              NSLocalizedString(@"Empty name.", @"There is no name written") message:
                              NSLocalizedString(@"Write the name of the list and then touch add.", @"Add name of list") delegate:nil cancelButtonTitle:
                              NSLocalizedString(@"All right.", @"Used text for dismissing a presented alert view. As Ok") otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wantsToCreateNewArchive:isList:)]) {

        if ([self.delegate wantsToCreateNewArchive:self.listName.text isList:isWritingAList])
        
            self.listName.text = kEmptyText;
        
        
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:
                                  NSLocalizedString(@"Existing Name.", @"The name you want to use, already exists.") message:
                                  NSLocalizedString(@"The name of the desired archive, already exists. Try a different one.", @"Duplicating ARCHIVE") delegate:nil cancelButtonTitle:
                                  NSLocalizedString(@"All right.", @"Used text for dismissing a presented alert view. As Ok") otherButtonTitles:nil];
            [alert show];

        }
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)animateButton:(BOOL)isWrtingAList
{
    NSString * text =
    NSLocalizedString(@"folder", @"creation of new folder button title");
    NSString *labelText =
    NSLocalizedString(@"List Name:", @"Gray advise for current creation ->list");
    NSString * iconName = kArtList;
    if (!isWrtingAList) {
        text =
        NSLocalizedString(@"list", @"creation of new list Button title");
        labelText =
        NSLocalizedString(@"Folder Name:", @"Gray adviser for current creation ->folder");
        iconName = kArtFolder;
    }
    [UIView animateWithDuration:0.3f animations:^{
        
        [self.changeFileTypeButton setCenter:CGPointMake(400, self.changeFileTypeButton.center.y)];
        [self.labelForType setCenter:CGPointMake(-100, self.labelForType.center.y)];
        [self.iconType setCenter:CGPointMake(-100, self.iconType.center.y)];

    }


completion:^(BOOL finished){
    
        [self.changeFileTypeButton setTitle:text forState:UIControlStateNormal];
    [self.labelForType setText:labelText];
    [self.iconType setImage:[UIImage imageNamed:iconName]];
    
        [UIView animateWithDuration:0.3f animations:^{


            [self.labelForType setCenter:CGPointMake(75, self.labelForType.center.y)];
        [self.changeFileTypeButton setCenter:CGPointMake(282, self.changeFileTypeButton.center.y)];
            [self.iconType setCenter:CGPointMake(36, self.iconType.center.y)];
        }];
    }
     ];
}

- (IBAction)changeFileTypePressed:(id)sender {

    if (isWritingAList)
        isWritingAList = NO;
    else
        isWritingAList =YES;
    [self animateButton:isWritingAList];
    
    

}
@end
