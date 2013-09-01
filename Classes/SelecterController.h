//
//  SelecterController.h
//  Table
//
//  Created by Renato Casanova on 5/25/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SelecterCell.h"
@interface SelecterController : UIViewController <UITableViewDataSource,UITableViewDelegate,SelecterProtocol>

@property (weak, nonatomic) IBOutlet UITableView *pTable;
@property (weak, nonatomic) IBOutlet UITableView *iTable;
@property (weak, nonatomic) IBOutlet UIButton *backButtonOutLet;
@property (weak, nonatomic) IBOutlet UILabel *folderTitle;
- (IBAction)backButtonPressed:(id)sender;

//-(void)loadInitialDataAndBOOLS;
-(NSArray*)getPreferedLists;
-(void)applyPreferedLists:(NSArray*)bools;
@end
