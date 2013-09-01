//
//  NewArchiveController.h
//  Table
//
//  Created by Renato Casanova on 5/27/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterButton.h"
@protocol NewArchiveProtocol <NSObject>

@required

-(BOOL)wantsToCreateNewArchive:(NSString*)archiveName isList:(BOOL)isList;

@end
@interface NewArchiveController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UITextField *listName;
@property (weak, nonatomic) IBOutlet UIImageView *iconType;

@property (nonatomic, assign) id <NewArchiveProtocol> delegate;
@property (weak, nonatomic) IBOutlet MasterButton *changeFileTypeButton;
- (IBAction)changeFileTypePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelForType;
@property (weak, nonatomic) IBOutlet UILabel *TypeTitle;

-(void)setFolderCreation:(BOOL)folderOnly;

@end
