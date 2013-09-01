//
//  ConceptController.h
//  Table
//
//  Created by Renato Casanova on 4/20/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
@class MasterButton;


@protocol ConceptsNavigationProtocol <NSObject>

@required
-(BOOL)realllocateConceptList:(NSArray*)concepts ofList:(NSString*)list andChangeItsNameTo:(NSString*)newNameList;

@end
@interface ConceptController : UIViewController <UITextFieldDelegate>


-(void)defineTitleOfList:(NSString*)list backButton:(NSString*)backFolder andSetListsOfConcepts:(NSArray*)concepts andAllowEditing:(BOOL)isAllowed;
- (IBAction)masterPressed:(MasterButton*)sender;
- (void)sortConcepts;

@property (weak, nonatomic) IBOutlet MasterButton *backButton;

@property (nonatomic,assign) id <ConceptsNavigationProtocol> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *conceptTitle;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet MasterButton *masterButton;
-(IBAction)backButtonDidPressed:(id)sender;
@end
