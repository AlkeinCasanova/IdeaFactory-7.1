//
//  PremiseController.h
//  Table
//
//  Created by Renato Casanova on 4/24/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SelecterCell.h"

#import "PremiseData.h"
#import "PremiseCell.h"

#import "MasterButton.h"

#import "BWFileManagementAdditions.h"
#import "FinderController.h"
#import "SelecterController.h"
#import "InfoController.h"



@interface PremiseController : UIViewController  <PremiseProtocol,UITextFieldDelegate,FinderNavigationProtocol,FinderArchiveReferenceProtocol,InfoProtocol,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;

@property (weak, nonatomic) IBOutlet UIView *bottomMenu;
@property (weak, nonatomic) IBOutlet UIView *selecterContainer;
@property (weak, nonatomic) IBOutlet UIButton *addButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet MasterButton *masterButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButtonOut;
@property (weak, nonatomic) IBOutlet UIButton *selecterButton;
@property (weak, nonatomic) IBOutlet UIButton *ideaButotn;

@property (nonatomic) SelecterController* selecterController;

- (IBAction)shareIdea:(id)sender;
- (IBAction)add:(id)sender;
- (IBAction)edit:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)selecterButtonPressed:(id)sender;
- (IBAction)settingPressed:(id)sender;
- (IBAction)idea:(id)sender;

-(IBAction)cancelSegue:(UIStoryboardSegue*)sender;

-(IBAction)finishedWithSettings:(UIStoryboardSegue*)sender;

-(void)saveData;
@end
