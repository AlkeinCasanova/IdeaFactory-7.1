//
//  FinderController.m
//  Table
//
//  Created by Renato Casanova on 4/21/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import "FinderController.h"
#import "URLConst.h"
#import "BWColors.h"

#import "MasterButton.h"

#import "AlertStrings.h"


@interface FinderController ()
{

    NSMutableArray * currentKindDepth;
    NSMutableArray *rootKeys;
    
    UIFont *fontMain;

    NSString* oldFolderName;
    NSURL *runningURL;

    NSIndexPath *selectedRow;
    BOOL isMovingRows;
    NSArray *movingStuff;
    BOOL isAllowedSending;

    
    
}
@end

@implementation FinderController



#pragma mark INITAL SETUP

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (isMovingRows) {
    }
    if ([tableView isEditing]) {

        NSArray * selected = [tableView indexPathsForSelectedRows];
        if (selected.count) {
            [self firstMenuInteractionLookin:YES];
        }
        else
        {
            [self firstMenuInteractionLookin:NO];
        }
    }
}
-(NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isMovingRows) {
        NSArray * kind =rootKeys[indexPath.row];
        if ([kind[0] boolValue]) {
            return nil;
        }
    }


//    if (isMovingRows) {
//        NSArray * kind =rootKeys[indexPath.row];
//        if ([kind[0] boolValue]) {
//            return nil;
//        }
//    }
//    if ([tableView isEditing]) {
//        NSArray * selected = [tableView indexPathsForSelectedRows];
//        if (selected.count) {
//            [self firstMenuInteractionLookin:YES];
//        }
//        else
//        {
//            [self firstMenuInteractionLookin:NO];
//        }
//
//    }
    return indexPath;
    
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([tableView isEditing] || isMovingRows) {

        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.textLabel.text hasSuffix:kDatabase])
            return nil;
    }
    if (isMovingRows) {
        NSArray * kind =rootKeys[indexPath.row];
        if ([kind[0] boolValue]) {
            return nil;
        }
    }



//        NSArray * kind =rootKeys[indexPath.row];
//    if ([kind[0] boolValue]) {
//        return nil;
//    }
//        if (isMovingRows) {
//            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
////
////            NSArray *selectedRows =  [self.tableView indexPathsForSelectedRows];
////            NSMutableArray *toMove = [NSMutableArray array];
////            for (int i = 0; i < selectedRows.count; i++) {
////                [toMove addObject:rootKeys[i]];
////            }
////
////            runningMovingRows = [NSArray  arrayWithArray:toMove];
//        }
    
    
    return indexPath;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([tableView isEditing]) {

        NSArray * selected = [tableView indexPathsForSelectedRows];
        if (selected.count) {
            [self firstMenuInteractionLookin:YES];
        }
        else
        {
            [self firstMenuInteractionLookin:NO];
        }
    }

    NSArray* kind = rootKeys[indexPath.row] ;

    if (isMovingRows) {
        
    }

    if ([tableView isEditing]) {
        if ([kind[0]boolValue])
            return;
    }


    else
    {
    if ([kind[0]boolValue]) {

        //CONCEPTS

        ConceptController* conceptController = (ConceptController*) [self.storyboard instantiateViewControllerWithIdentifier:@"conceptsController"];
        NSArray *contents = [[NSFileManager defaultManager]parseTextFileAt:[runningURL URLByAppendingPathComponent:[kind[1] stringByAppendingPathExtension:kTextSuffix]]];
        [conceptController setDelegate:self];
        [conceptController defineTitleOfList:kind[1]  backButton:oldFolderName andSetListsOfConcepts:contents andAllowEditing:isAllowedSending];
        
        [self presentViewController:conceptController animated:YES completion:^{}];

    }
    else
    {
        //FOLDER
        FinderController *listContoller = (FinderController *)[self.storyboard instantiateViewControllerWithIdentifier:@"finderController"];
        NSMutableArray *nextKindDepthLevel = [NSMutableArray arrayWithArray:currentKindDepth];
        [nextKindDepthLevel addObject:[NSNumber numberWithInt:indexPath.row]];

        [listContoller defineContentsAndFolderName:kind[1] andBackButtonName:self.folderNameText.text andLastURL:runningURL WithDepth:nextKindDepthLevel isMovingRows:isMovingRows andAllowsEditing:isAllowedSending];
        [listContoller setDelegate:self];
        [listContoller setReferenceDelegate:self.referenceDelegate];
        
        [self.navigationController pushViewController:listContoller animated:YES];

    }
//    [self performFadeingAnimatinos];
    [self saveData];
    selectedRow = indexPath;
    }
    

}
-(void)performFadeingAnimatinos
{
    [UIView animateWithDuration:0 animations:^{

        [self.masterButton setAlpha:0];
        [self.plusButton setAlpha:0];
    }];

    
}
-(void)defineContentsAndFolderName:(NSString *)folderName  andBackButtonName:(NSString*)backName andLastURL:(NSURL*)lastURL WithDepth:(NSMutableArray *)depth isMovingRows:(BOOL)movingRows andAllowsEditing:(BOOL)isAllowed
{
    
    

    isMovingRows = movingRows;

    [self.view setNeedsDisplay];
    [self.backButton setTitle:backName forState:UIControlStateNormal];
    oldFolderName = [folderName copy];
    [self.folderNameText setText:oldFolderName];
    
    currentKindDepth = depth;
    isAllowedSending = isAllowed;

    if ([folderName hasSuffix:kDatabase])
        isAllowedSending =NO;
    [self.folderNameText setEnabled:isAllowedSending];

    if (currentKindDepth.count ==1) {
        runningURL = lastURL;
    }
    else
    {
        runningURL = [lastURL URLByAppendingPathComponent:oldFolderName isDirectory:YES];
    }
    rootKeys = [[NSFileManager defaultManager] readDataOfClass:[NSMutableArray class] FromURL:[runningURL URLByAppendingPathComponent:kDataStructure]];
    [self updateReferences];


    isMovingRows = movingRows;
    if (isAllowedSending) {
        
    if (movingRows) {
        [self changeListControllerStateTo:listCmovingState];
    }
    else
    {
        [self changeListControllerStateTo:listCdefaultState];
    }
        }
    
    else{

        [self changeListControllerStateTo:liscCNotAllowedState];
    }



}
-(void)setInterfaceForAllowedEditing:(BOOL)isAllowedTheEditing
{
    if (isAllowedSending) {
        [self changeListControllerStateTo:listCdefaultState];
    }
    else
    {
        [self changeListControllerStateTo:liscCNotAllowedState];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.6f animations:^{

        [self.backButton setCenter:CGPointMake(40, self.backButton.center.y)];
        [self.backButton setAlpha:1];

        [self.folderNameText setCenter:CGPointMake(self.view.center.x, self.folderNameText.center.y)];
        [self.folderNameText setAlpha:1];

    }];


}
- (void)viewDidLoad
{
    [super viewDidLoad];

    isMovingRows =NO;
    fontMain = [UIFont fontWithName:kStringFont  size:20];
    runningURL = [[NSURL alloc]init];
    rootKeys = [NSMutableArray array];
    self.tableView.allowsMultipleSelectionDuringEditing =YES;
    [self.folderNameText setDelegate:self];


    [self.folderNameText setCenter:CGPointMake(300, self.folderNameText.center.y)];
    [self.folderNameText setAlpha:0];
    [self.backButton setCenter:CGPointMake(80, self.backButton.center.y)];
    [self.backButton setAlpha:0];
    
    
}
#pragma mark CURRENT LIST CONTROLLER
-(void)updateReferences
{
    [[NSFileManager defaultManager] updateReferencesOfRootFile:rootKeys atURL:runningURL shouldAnimateRows:self.tableView withDepth:currentKindDepth AndDelegate:self.referenceDelegate];
}
-(void)saveData
{

    [self updateReferences];
    [[NSFileManager defaultManager] saveData:rootKeys  ToURL:[runningURL URLByAppendingPathComponent:kDataStructure]];

}

-(BOOL)wantsToCreateNewArchive:(NSString *)archiveName isList:(BOOL)isList
{
    if ([self checkForDuplicate:archiveName asList:isList])
        return NO;


    if (isList)
        [kEmptyText writeToURL:[runningURL URLByAppendingPathComponent:[archiveName stringByAppendingPathExtension:kTextSuffix]] atomically:YES encoding:NSUTF8StringEncoding error:nil];

    else

        [[NSFileManager defaultManager]createDirectoryAtURL:[runningURL URLByAppendingPathComponent:archiveName isDirectory:YES] withIntermediateDirectories:NO attributes:nil error:nil];

    [self saveData];

    if (self.presentedViewController)
        [self dismissViewControllerAnimated:YES completion:^{}];
    
    return YES;

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)cell

{
    if ([segue.identifier isEqualToString:@"newArchive"]) {
        NewArchiveController* archC = [segue destinationViewController];
        [archC setDelegate:self];
        [archC setFolderCreation:NO];
    }
    if ([segue.identifier isEqualToString:@"newFolder"]) {
        NewArchiveController* archC = [segue destinationViewController];
        [archC setDelegate:self];
        [archC setFolderCreation:isMovingRows];
    }
}

#pragma mark Buttons
- (IBAction)moveButtonPressed:(id)sender {


    NSArray * selectedRows = [self.tableView indexPathsForSelectedRows];
    NSFileManager * fileMngr = [NSFileManager defaultManager];
    
    NSURL * tempURL = [NSURL URLsetUpFrom:urlTmp];
    for (int i = 0;i< selectedRows.count; i++) {
        NSIndexPath * path = selectedRows[i];
        NSArray *kind = rootKeys[path.row];
        
        if ([kind[0]boolValue])
            //List
        {
        
            [fileMngr moveItemAtURL:[[runningURL URLByAppendingPathComponent:kind[1]]URLByAppendingPathExtension:kTextSuffix] toURL:[[tempURL URLByAppendingPathComponent:kind[1]]URLByAppendingPathExtension:kTextSuffix] error:nil];
        }

        else    //Folder
        {
            [fileMngr moveItemAtURL:[runningURL URLByAppendingPathComponent:kind[1] isDirectory:YES] toURL:[tempURL URLByAppendingPathComponent:kind[1] isDirectory:YES] error:nil];
        }

    }


    [self updateReferences];
    [self changeListControllerStateTo:listCmovingState];
}
-(void)topMenuChangeColorToMovingState:(BOOL)isMoving
{
    isMovingRows =isMoving;
    if (isMoving) {
        [self.topMenu setBackgroundColor:hexColor(0x000000)];
    }
    else{
        [self.topMenu setBackgroundColor:rgb(96, 78, 151)];
        
    }

    
    
}
- (IBAction)deleteButtonPressed:(id)sender {


    NSArray *selecteRows= [self.tableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in selecteRows) {
        
        NSArray * kind = rootKeys[indexPath.row];
        NSURL *archiveURL = [runningURL URLByAppendingPathComponent:kind[1]] ;

        NSError *error;
        if ([kind[0]boolValue])
            archiveURL= [archiveURL URLByAppendingPathExtension:kTextSuffix];


        [[NSFileManager defaultManager] removeItemAtURL:archiveURL error:&error];
        if (error) {
            NSLog(@"Error while deleting. %@",error);
        }
    }
    [self saveData];


    [self firstMenuInteractionLookin:NO];

    if (rootKeys.count == 0) {
        [self masterButtonPressed:self.masterButton];
    }



}

- (IBAction)chooseButtonPressed:(id)sender {
    isMovingRows =NO;
    NSFileManager *fileMngr = [NSFileManager defaultManager];
    NSURL *tempURL = [NSURL URLsetUpFrom:urlTmp];
    NSArray * movedStuff =[fileMngr enumerateDirectoryComponentsFromURL:tempURL];
    for (NSArray * kind in movedStuff) {
        NSURL * temporal =nil;
        NSURL *futureRunning =nil;
        if ([kind[0]boolValue]) {
            temporal =[[tempURL URLByAppendingPathComponent:kind[1]] URLByAppendingPathExtension:kTextSuffix];
            futureRunning =[[runningURL URLByAppendingPathComponent:kind[1]] URLByAppendingPathExtension:kTextSuffix];
            
             
        }
        else
        {
            temporal = [tempURL URLByAppendingPathComponent:kind[1] isDirectory:YES];
            futureRunning =[runningURL URLByAppendingPathComponent:kind[1]];
            
        }

        [fileMngr moveItemAtURL:temporal toURL:futureRunning error:nil];

    }
    [self updateReferences];
    [self.masterButton changeMasterStateTo:masterEdit];
    [self changeListControllerStateTo:listCdefaultState];

    

}
- (IBAction)CreateFolderPressed:(id)sender {

}
- (IBAction)masterButtonPressed:(MasterButton*)sender {

    switch (sender.currentState) {
        case masterDone:

            [sender changeMasterStateTo:masterEdit];
            [self changeListControllerStateTo:listCdefaultState];
            

            break;
        case masterEdit:
            if (rootKeys.count == 0)
                return;
            [sender changeMasterStateTo:masterDone];
            [self changeListControllerStateTo:listCselectionState];


            break;

        default:
            break;
    }
    
}
-(void)changeListControllerStateTo:(enum listControllerState)state
{
    switch (state) {
        case listCdefaultState:
            [self.tableView setEditing:NO animated:YES];
            isMovingRows=NO;
            [self presentBackButton:YES];
            [self topMenuChangeColorToMovingState:NO];
            [self presentFirstMenu:NO];
            [self presentSecondMenu:NO];
            [self presentMaterButton:YES];

            break;

        case listCselectionState:


            [self.tableView setEditing:YES animated:YES];
            isMovingRows= NO;
            [self presentBackButton:NO];
            [self presentFirstMenu:YES];

            [self presentMaterButton:YES];


            break;

        case listCmovingState:
            isMovingRows=YES;
            [self.tableView setEditing:NO animated:YES];
            [self presentSecondMenu:YES];
            [self presentBackButton:YES];
            [self topMenuChangeColorToMovingState:YES];

            [self presentMaterButton:NO];
            break;
        case liscCNotAllowedState:
            isMovingRows = NO;
            [self.normalMenu setHidden:YES];
            [self.masterButton setHidden:YES];
            
            break;
        default:
            break;
    }
}
-(void)presentBackButton:(BOOL)present
{
    int p = -40;
    if (present) {
        p = 20;
    }
    [UIView animateWithDuration:0.4f animations:^{
        [self.backButton setCenter:CGPointMake(self.backButton.center.x, p)];
    }];
}
-(void)presentMaterButton:(BOOL)present
{
    int p = -40;
    if (present) {
        p = 20;
    }
    [UIView animateWithDuration:0.4f animations:^{
        [self.masterButton setCenter:CGPointMake(self.masterButton.center.x, p)];
    }];
}

-(void)firstMenuInteractionLookin:(BOOL)enabled
{
    [self.editingFirstMenu setUserInteractionEnabled:enabled];

    for (UIButton * buton in
         [self.editingFirstMenu subviews]) {
        if (enabled) {
            [buton setAlpha:1];

        }
        else
        {
            [buton setAlpha:0.5f];
        }
    }
}
-(void)presentFirstMenu:(BOOL)present
{
    [self firstMenuInteractionLookin:NO];
    NSInteger preseting = 52;

    if (present) {

        preseting = -52;
        if (self.editingFirstMenu.center.y == self.normalMenu.center.y) {
            preseting =0;
        }
    }
    else
    {
        preseting = 0;
        if (self.editingFirstMenu.center.y == self.normalMenu.center.y) {
            preseting= 52;
        }

        
    }

    [UIView animateWithDuration:0.3f animations:^{
        [self.editingFirstMenu setCenter:CGPointMake(self.editingFirstMenu.center.x, self.editingFirstMenu.center.y +preseting)];
    }];
    
    
}

-(void)presentSecondMenu:(BOOL)present
{
    
    NSInteger preseting;

    if (present) {

        preseting = -52;
        if (self.editingSecondMenu.center.y == self.normalMenu.center.y) {
            preseting =0;
        }
    }
    else
    {
        preseting = 0;
        if (self.editingSecondMenu.center.y == self.normalMenu.center.y) {
            preseting= 52;
        }

        
    }
    [UIView animateWithDuration:0.3f animations:^{
        [self.editingSecondMenu setCenter:CGPointMake(self.editingSecondMenu.center.x, self.editingSecondMenu.center.y +preseting)];
    }];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString: kEmptyText]) {
        UIAlertView * alertEmpty = [[UIAlertView alloc]initWithTitle:
                                    NSLocalizedString(@"Empty name.", @"There is no name written") message:
                                    NSLocalizedString(@"Write the name of the list and then touch add.", @"Add name of list") delegate:nil cancelButtonTitle:
                                    NSLocalizedString(@"All right.", @"Used text for dismissing a presented alert view. As Ok") otherButtonTitles: nil];
        [alertEmpty show];
        return NO;
    }

    [textField resignFirstResponder];
    return NO;

}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rootKeys.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"listCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    [cell.textLabel setFont:fontMain];
    cell.selectionStyle =UITableViewCellSelectionStyleGray;
    cell.indentationLevel = 1;
    NSArray * kind = rootKeys[indexPath.row];
    if ([kind[0] boolValue]) 
        cell.imageView.image  = [UIImage imageNamed:kArtList];

    else
    
        cell.imageView.image  = [UIImage imageNamed:kArtFolder];


    cell.textLabel.text = kind[1];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text hasSuffix:kDatabase])
        return NO;
    return YES;
}
-(BOOL)checkForDuplicate:(NSString *)name asList:(BOOL)type
{
    // As fil
    NSNumber * typeOfArchive = [NSNumber numberWithBool:type];
    for (NSArray *kind in rootKeys) {
        if ([kind[0]  isEqual:typeOfArchive])
            if ([kind[1]isEqualToString:name] ) 
                return YES;
            
    }
    return NO;

}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {


        NSArray * kind = rootKeys[indexPath.row];
        NSURL *archiveURL = [runningURL URLByAppendingPathComponent:kind[1]] ;
        
        NSError *error;
        if ([kind[0]boolValue])
            archiveURL= [archiveURL URLByAppendingPathExtension:kTextSuffix];

        
        [[NSFileManager defaultManager] removeItemAtURL:archiveURL error:&error];
        if (error) {
            NSLog(@"Error while deleting. %@",error);
        }


    [self updateReferences];
        
    }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
    
    id quickKind = rootKeys[fromIndexPath.row];
    [rootKeys removeObjectAtIndex:fromIndexPath.row];
    [rootKeys insertObject:quickKind atIndex:toIndexPath.row];

    if (self.referenceDelegate && [self.referenceDelegate respondsToSelector:@selector(finderControllerMovedArchiveFrom:ToIndexPath:AtDepth:)])
        [self.referenceDelegate finderControllerMovedArchiveFrom:fromIndexPath ToIndexPath:toIndexPath AtDepth:currentKindDepth];

    [[NSFileManager defaultManager] saveData:rootKeys  ToURL:[runningURL URLByAppendingPathComponent:kDataStructure]];
   
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}
#pragma mark - Concepts Delagete

-(BOOL)realllocateConceptList:(NSArray *)concepts ofList:(NSString *)oldListName  andChangeItsNameTo:(NSString*)newNameList
{
    if ([self presentedViewController]) {

    NSString * text = [concepts componentsJoinedByString:@"\n"];
        
    if ([oldListName isEqualToString:newNameList]) {



        [text writeToURL:[runningURL URLByAppendingPathComponent:[oldListName stringByAppendingPathExtension:kTextSuffix]] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        

    }
    else
    {
        if ([self checkForDuplicate:newNameList asList:YES])
            return NO;
        
        [[NSFileManager defaultManager]removeItemAtURL:[runningURL URLByAppendingPathComponent:[oldListName stringByAppendingPathExtension:kTextSuffix]] error:nil];
        [text writeToURL:[runningURL URLByAppendingPathComponent:[newNameList stringByAppendingPathExtension:kTextSuffix]] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
    }

        [self dismissViewControllerAnimated:YES completion:^{}];
        [self performSelector:@selector(deselectRow:) withObject:selectedRow afterDelay:0.2f];
        
    }

    [self updateReferences];
    return YES;
}

-(void)deselectRow:(NSIndexPath*)indexPath
{
    [self.tableView deselectRowAtIndexPath:selectedRow animated:YES];

}
#pragma mark BACKWARDS CONNECTION
- (IBAction)backButton:(id)sender {
    if (currentKindDepth.count ==1 && isMovingRows) {
        [self chooseButtonPressed:nil];
    }
    [self saveData];

    
    if ([self.folderNameText.text isEqualToString:kEmptyText]) {
        UIAlertView * alertEmpty = [[UIAlertView alloc]initWithTitle:
                                    NSLocalizedString(@"Empty name.", @"There is no name written") message:
                                    NSLocalizedString(@"Write the name of the folder and then touch add.", @"Add name of folder") delegate:nil cancelButtonTitle:
                                    NSLocalizedString(@"All right.", @"Used text for dismissing a presented alert view. As Ok") otherButtonTitles: nil];
        [alertEmpty show];
        [self.folderNameText becomeFirstResponder];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldDismissPresentedViewControllerAndSetNewTextTo:fromOlfName:AndIsMovingRows:)]) {
        if ([self.delegate shouldDismissPresentedViewControllerAndSetNewTextTo:self.folderNameText.text fromOlfName:oldFolderName AndIsMovingRows:isMovingRows])
        {
            [UIView animateWithDuration:0.2f animations:^{
                [self.backButton setCenter:CGPointMake(200, self.backButton.center.y)];
                [self.backButton setAlpha:0];
            }];
            
        }
        else
        {

            UIAlertView * alertEmpty = [[UIAlertView alloc]initWithTitle:
                                        NSLocalizedString(@"Existing Name.", @"The name you want to use, already exists.") message:
                                        NSLocalizedString(@"The name of the desired folder, already exists. Try a different one.", @"Duplicating FOLDER") delegate:nil cancelButtonTitle:
                                        NSLocalizedString(@"All right.", @"Used text for dismissing a presented alert view. As Ok") otherButtonTitles: nil];
            [alertEmpty show];
            [self.folderNameText becomeFirstResponder];

        }
        

    }
    
}

-(BOOL)shouldDismissPresentedViewControllerAndSetNewTextTo:(NSString *)newName fromOlfName:(NSString *)oldName AndIsMovingRows:(BOOL)isMoving
{

    if (self.navigationController) {
        isMovingRows = isMoving;
  
    if (doesnt[oldName isEqualToString:newName]) {
        if ([self checkForDuplicate:newName asList:NO])
            return NO;
//
        NSError* error;
//
        if(![[NSFileManager defaultManager]moveItemAtURL:[runningURL URLByAppendingPathComponent:oldName isDirectory:YES] toURL:[runningURL URLByAppendingPathComponent:newName isDirectory:YES] error:&error])
            NSLog(@"Erro unable to move file: %@", [error localizedDescription]);
        

        [self.tableView reloadData];
    }

        if (isMovingRows) {
            [self changeListControllerStateTo:listCmovingState];
        }
        else
            [self changeListControllerStateTo:listCdefaultState];
        
        [self updateReferences];
        [self performSelector:@selector(deselectRow:) withObject:selectedRow afterDelay:0.2f];
        [self.navigationController popViewControllerAnimated:YES];

    }
    return YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
