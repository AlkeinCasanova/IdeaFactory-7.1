//
//  FinderController.h
//  Table
//
//  Created by Renato Casanova on 4/21/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWFileManagementAdditions.h"
#import "NewArchiveController.h"
#import "ConceptController.h"
#import "FinderControllerProtocols.h"

enum listControllerState {
    listCdefaultState = 0,
    listCmovingState = 1,
    listCselectionState = 2,
    liscCNotAllowedState = 3,
    };
@class MasterButton;


@interface FinderController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,NewArchiveProtocol,FinderNavigationProtocol,ConceptsNavigationProtocol>
@property (weak, nonatomic) IBOutlet UIView *normalMenu;

@property (weak, nonatomic) IBOutlet UIView *editingFirstMenu;
@property (weak, nonatomic) IBOutlet UIView *editingSecondMenu;
@property (weak, nonatomic) IBOutlet UIView *topMenu;
- (IBAction)moveButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)chooseButtonPressed:(id)sender;
- (IBAction)CreateFolderPressed:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *folderNameText;
@property (weak, nonatomic) IBOutlet MasterButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MasterButton *masterButton;
@property (weak, nonatomic) IBOutlet UIView *plusButton;

@property (nonatomic)enum listControllerState controllerCurrentState;
@property (nonatomic,assign) id <FinderNavigationProtocol> delegate;
@property (nonatomic,assign) id <FinderArchiveReferenceProtocol> referenceDelegate;


- (IBAction)masterButtonPressed:(MasterButton*)sender;
-(void)defineContentsAndFolderName:(NSString *)folderName  andBackButtonName:(NSString*)backName andLastURL:(NSURL*)lastURL WithDepth:(NSMutableArray *)depth isMovingRows:(BOOL)movingRows andAllowsEditing:(BOOL)isAllowed;

-(IBAction)cancel:(UIStoryboardSegue*)sender;

@end
