//
//  ConceptController.m
//  Table
//
//  Created by Renato Casanova on 4/20/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import "ConceptController.h"
#import "URLConst.h"
#import "MasterButton.h"
#import "AlertStrings.h"
@interface ConceptController ()
{
    NSString * oldListName;
    NSMutableArray* listsConcepts;
}
@end

@implementation ConceptController

-(IBAction)backButtonDidPressed:(id)sender {
    [self sortConcepts];
    if ([self.conceptTitle.text isEqualToString:kEmptyText]) {

        UIAlertView * alertEmpty = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Empty name.", @"There is no name written") message:
                                    NSLocalizedString(@"Write the name of the list and then touch add.", @"Add name of list") delegate:nil cancelButtonTitle:
                                    NSLocalizedString(@"All right.", @"Used text for dismissing a presented alert view. As Ok") otherButtonTitles: nil];
        [self.conceptTitle becomeFirstResponder];
        [alertEmpty show];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(realllocateConceptList:ofList:andChangeItsNameTo:)]) {
        if(![self.delegate realllocateConceptList:[NSArray arrayWithArray:listsConcepts] ofList:oldListName andChangeItsNameTo:self.conceptTitle.text])
        {
            UIAlertView * alertEmpty = [[UIAlertView alloc]initWithTitle:
                                        NSLocalizedString(@"Existing Name.", @"The name you want to use, already exists.") message:
                                        NSLocalizedString(@"The name of the desired list, already exists. Try a different one.", @"Duplicating LIST") delegate:nil cancelButtonTitle:
                                        NSLocalizedString(@"All right.", @"Used text for dismissing a presented alert view. As Ok") otherButtonTitles: nil];

            [self.conceptTitle becomeFirstResponder];
            [alertEmpty show];
        
        }
            
    }
}

-(void)defineTitleOfList:(NSString*)list backButton:(NSString*)backFolder andSetListsOfConcepts:(NSArray*)concepts andAllowEditing:(BOOL)isAllowed
{

    [self.view setNeedsDisplay];
    oldListName = [list copy];
    [self.conceptTitle setText:oldListName];

    [self.conceptTitle setEnabled:isAllowed];

    listsConcepts = [NSMutableArray arrayWithArray:concepts];
    [self.tableView reloadData];
    [self.backButton setTitle:backFolder forState:UIControlStateNormal];
    [self.textField becomeFirstResponder];
    
                   

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    listsConcepts = [NSMutableArray array];
    [self.backButton setCenter:CGPointMake(self.backButton.center.x, -50)];
    [UIView animateWithDuration:0.4 animations:^{

        [self.backButton setCenter:CGPointMake(self.backButton.center.x, 20)];
        
    }];

   
}

#pragma mark - TextField Related
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listsConcepts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    cell.textLabel.text =[listsConcepts objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont fontWithName:kStringFont size:20];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [listsConcepts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{ return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{

//    if ([textField tag] == 10) {
//        [self.masterButton changeMasterStateTo:masterDone];
//    }
//    else
//    {
    [self.masterButton changeMasterStateTo:masterHide];
//    }

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {



    if ([textField tag] == 10) {

        [textField resignFirstResponder];
        return NO;
    }

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [listsConcepts insertObject:textField.text atIndex:indexPath.row];

    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    textField.text = kEmptyText;

    return NO;
}
#pragma mark - Table view delegate


- (IBAction)masterPressed:(MasterButton*)sender {
    switch (sender.currentState) {
        case masterDone:


            [self.conceptTitle resignFirstResponder];
            [self.tableView setEditing:NO animated:YES];
            [sender changeMasterStateTo:masterEdit];

            break;
        case masterEdit:
            


            [self.conceptTitle becomeFirstResponder];
            [self.tableView setEditing:YES animated:YES];
            [sender changeMasterStateTo:masterHide];

            break;
        case masterHide:
            [self.textField resignFirstResponder];
            [self.conceptTitle resignFirstResponder];
            if (sender.lastState == masterHide) {

                [sender changeMasterStateTo:masterDone];
                
            }
            else
            [sender changeMasterStateTo:masterEdit];

        default:
            break;
    }
}

- (void)sortConcepts {
    NSArray *sortedArray;
    sortedArray = [listsConcepts sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    listsConcepts = [NSMutableArray arrayWithArray:sortedArray];
    [self.tableView reloadData];
    
}
@end
