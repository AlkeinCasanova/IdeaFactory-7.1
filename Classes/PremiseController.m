//
//  PremiseController.m
//  Table
//
//  Created by Renato Casanova on 4/24/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//
//dispatch_queue_t queue;
//
//
//queue = dispatch_queue_create("com.premise.queue.", DISPATCH_QUEUE_SERIAL);
//
//NSLog(@"after que");
//
//dispatch_async(queue, ^{
//    NSLog(@"Descripción dentro del KIU %@",self.description);
//
//});
//
//NSLog(@"Despues kiu");
//
//NSLog(@"%@",self.description);
// NSLog(@"Index :%i",indexPath.row);

#import "PremiseController.h"

#import "URLConst.h"

#import "PremiseCell.h"
#import "AlertStrings.h"
#define kSelecterHiddenPosition -160
#define kSelecterListsPosition 160
#define kTotalCellsAllowed 20
#define DEBUGG 1
@interface PremiseController ()

{
    //Lists NagController
    UINavigationController *listNav;
    //FILE Management
    NSURL * factoryURL;
    NSURL * masterURL;
    
    NSMutableDictionary * factoryDictionary;
    NSMutableArray *factoryKeys;
    //FIlE right Label
    NSMutableArray *rightFactoryKeys;

    //List of Extra documents

    //Main TableView and PhantomCells
    NSMutableArray *phantomCellsArray;
    UITableView * _premiseTable;

    //ChecksForActiveCells
    BOOL isThereAnActiveCell;
    NSIndexPath* activeCell;
    NSIndexPath* lastActiveCell;
    //EndForCurrentACtive

    BOOL isMakingANewCell;

    NSNumber * preference;
    NSURL * prefURL;



    
}

@end

@implementation PremiseController


#pragma mark -
#pragma mark - Load

-(void)pragmatisim
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    prefURL = [[NSURL URLsetUpFrom:urlLibaryPreferences]URLByAppendingPathComponent:filePreferences];
    preference = [fileManager readDataOfClass:[NSNumber class] FromURL:prefURL];
    if (!preference) {
        preference = @0;
        [fileManager saveData:preference ToURL:prefURL];
        [fileManager resetLocalizedFactory];
        [fileManager resetLocalizedDataBase];
        [self reloadAllKeys];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * theUrl = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id={YOUR APP ID}&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:theUrl]];
}
-(void)addValueToPragmatisim
{
    
    preference = [NSNumber numberWithInt:[preference integerValue]+1];
    if ([preference integerValue] == 500) {
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"500!"
                                                      message:NSLocalizedString(@"Apparently, you like the app 500 hundres times.", @"Maybe just maybe, you did like the app! Wanna rate me?")
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"cancel", @"Negate the current desivice action")
                                            otherButtonTitles:NSLocalizedString(@"Yeah!", @"Confirmation button to review the app"),nil];
        [aler show];
    }
    if ([preference integerValue] == 1000) {
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"1000!"
                                                      message:NSLocalizedString(@"Quite amusing, you have tried for a thousand times to get a new story", @"Maybe just maybe, you did like the app! Wanna rate me?")
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"cancel", @"Negate the current desivice action")
                                            otherButtonTitles:NSLocalizedString(@"Yeah!", @"Confirmation button to review the app"),nil];
        [aler show];
    }


}
- (void)viewDidLoad
{

    [super viewDidLoad];
    [self pragmatisim];
    //Lugat donde preparar los archivos y/o crearlos
    [self URLsetUp];
    
    //Cosas iniciales de la tableView de Premise
    [self premiseTableViewSetUp];

    [self showCancelButton:NO];

    activeCell = [[NSIndexPath alloc]init];
    lastActiveCell = [[NSIndexPath alloc]init];
    phantomCellsArray = [NSMutableArray array];
    isMakingANewCell = NO;

    //enlace para el selecterView
    self.selecterController = [self.childViewControllers lastObject];
    [self maxUpdate];


}
-(void)maxUpdate
{
    [[NSFileManager defaultManager] iterateThroughRootHierarchyWhileUpdatingRootArchives:[NSURL URLsetUpFrom:urlDocuments] WithDepth:[NSMutableArray arrayWithObject:@0] AndDelegate:self];

}
-(void)URLsetUp
{
    //URL diecta a nuestas listas.
    factoryURL = [NSURL URLsetUpFrom:urlLibaryFactory];

//    masterURL =  [NSURL URLsetUpFrom:kDataMasterBools];

    //Agrega información o crea desde 0
    factoryDictionary =  [[NSFileManager defaultManager] readDataOfClass:[NSMutableDictionary class] FromURL:[factoryURL URLByAppendingPathComponent:filePremisesArch]];
    factoryKeys =        [[NSFileManager defaultManager] readDataOfClass:[NSMutableArray      class] FromURL:[factoryURL URLByAppendingPathComponent:filePremisesKeys      ]];
    rightFactoryKeys =   [[NSFileManager defaultManager] readDataOfClass:[NSMutableArray      class] FromURL:[factoryURL URLByAppendingPathComponent:fileRightLabelKeys ]];
    
}

-(void)saveData
{
    //Llamado cuando la aplcacion va a perder control o va a ser terminada.

    [[NSFileManager defaultManager] saveData:preference        ToURL:prefURL];
    [[NSFileManager defaultManager] saveData:factoryDictionary ToURL:[factoryURL URLByAppendingPathComponent:filePremisesArch]];
    [[NSFileManager defaultManager] saveData:factoryKeys       ToURL:[factoryURL URLByAppendingPathComponent:filePremisesKeys      ]];
    [[NSFileManager defaultManager] saveData:rightFactoryKeys  ToURL:[factoryURL URLByAppendingPathComponent:fileRightLabelKeys ]];
    
}
- (void)didReceiveMemoryWarning{
    //Supongo que tengo que hacer algo aqui..
    [super didReceiveMemoryWarning];}

-(void)premiseTableViewSetUp
{
    //Cosas iniciales de la tableView
    _premiseTable = (id)[self.view viewWithTag:1];
    [_premiseTable registerClass:[PremiseCell class] forCellReuseIdentifier:@"premiseCell"];
//    _premiseTable.backgroundColor = [UIColor clearColor];
    _premiseTable.separatorColor = [UIColor clearColor];


}
#pragma mark - Actions
- (IBAction)viewLists:(id)sender {

//    [self maxUpdate];
    listNav = [self.storyboard instantiateViewControllerWithIdentifier:@"mainNavigationController"];
    FinderController *listC = (id)[listNav topViewController];
    [listC setDelegate:self];
    [listC setReferenceDelegate:self];
    
    [listC defineContentsAndFolderName:NSLocalizedString(@"Lists", @"Lists as title") andBackButtonName:
     NSLocalizedString(@"back", @"Button title back") andLastURL:[NSURL URLsetUpFrom:urlDocuments] WithDepth:[NSMutableArray arrayWithObject:[NSNumber numberWithInt:0]] isMovingRows:NO andAllowsEditing:YES];
    [self presentViewController:listNav animated:YES completion:^{}];
}
- (IBAction)add:(id)sender {
    [self maxUpdate];
    if (factoryKeys.count <kTotalCellsAllowed) {

        NSIndexPath * path = [NSIndexPath  indexPathForItem:0 inSection:0];
        if (factoryKeys.count >1)
            [_premiseTable scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        
        [factoryKeys insertObject:kEmptyText atIndex:path.item];
        [rightFactoryKeys insertObject:NSLocalizedString(@"random", @"Default word for when a new premise is created") atIndex:path.item];

        NSMutableArray *arr = [[NSFileManager defaultManager]readDataOfClass:[NSMutableArray class] FromURL:[[NSURL URLsetUpFrom:urlDocuments] URLByAppendingPathComponent:kDataMasterBools]];

        [factoryDictionary setValue:arr forKey:factoryKeys[path.item]];
        [_premiseTable insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
//        dispatch_queue_t queue;
//        queue = dispatch_queue_create("com.premise.queue.", DISPATCH_QUEUE_SERIAL);
//        dispatch_async(queue, ^{
//
//        });


        isMakingANewCell =YES;
        [self makeCellChangeToState:premiseIdea atPath:path];
    }
    
}
//FIXME
- (void)randomizeWordsAtIndexPath:(NSIndexPath *)indexPath
{

    NSString * currentPrem = factoryKeys[indexPath.row];

    NSArray *boolList = factoryDictionary[currentPrem];
    NSArray *arry =  [[NSFileManager defaultManager]iterateThroughTreeWhileParsingSelectedTextFiles:boolList AtDepth:[NSURL URLsetUpFrom:urlDocuments]];



    PremiseCell *premCell = (PremiseCell*)[_premiseTable cellForRowAtIndexPath:indexPath];
    int randomW = 0;

    NSString *randomWordToSend;
    if (arry == nil) {
        randomWordToSend =
        NSLocalizedString(@"Select a list", @"Returned word when no there are no selected list in the premise cell");
        
    }
    else  if (arry.count ==0) {

        randomWordToSend =
        NSLocalizedString(@"Empty lists", @"Retunred word when the lists ARE empty");
    }
    else
    {

        randomW = arc4random() %  arry.count;

        randomWordToSend = arry[randomW];
    
    }
    [premCell randomize:randomWordToSend];
    [rightFactoryKeys insertObject:randomWordToSend atIndex:indexPath.row];
}
- (IBAction)idea:(UIButton *)sender {

    [self addValueToPragmatisim];
    
    for (PremiseCell * cell in [_premiseTable visibleCells]) {
        if (cell.currentState == premiseRandomizer) {
            return;
        }
    }
    if (factoryKeys.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
                              NSLocalizedString(@"Empty premises", @"When there are no premises") message:
                              NSLocalizedString(@"Generate Idea but there are no premises", @"For this to work, you have add one premise. Touch the plus button to create a new one.") delegate:nil cancelButtonTitle:
                              NSLocalizedString(@"All right.", @"Used text for dismissing a presented alert view. As Ok") otherButtonTitles:   nil];
        [alert show];
    }
    for (int i = 0 ; i < factoryKeys.count; i++) {
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self randomizeWordsAtIndexPath:indexPath];

    }
}
- (IBAction)edit:(MasterButton*)sender {
    switch (sender.currentState) {

        case masterEdit:

            if (factoryKeys.count == 0)
                break;
            for (PremiseCell * cell in [_premiseTable visibleCells]) {
                if (cell.currentState == premiseRandomizer) {
                    
                    
                    return;
                }
            }



            [self enableBottomMenu:NO];
            [sender changeMasterStateTo:masterDone];
            break;
        case masterDone:

            [_premiseTable setEditing:NO animated:YES];

            [self enableBottomMenu:YES];
            [sender changeMasterStateTo:masterEdit];

            break;
        case masterSave:

            [self shouldChangeToPresentationStateCellAtIndex:activeCell];

            
            break;
        default:
            break;
    }
}
- (IBAction)cancel:(id)sender {
    if (isMakingANewCell)

    [self makeCellChangeToState:premiseDelete atPath:activeCell];
        
    
    else
    [self makeCellChangeToState:premiseCancel atPath:activeCell];
}
//FIXME
- (IBAction)shareIdea:(id)sender {

    NSArray *cells = [_premiseTable visibleCells];
    NSMutableArray* listsOfWords = [NSMutableArray array];
    [listsOfWords addObject:
     NSLocalizedString(@"Tell me a story with this:", @"Used for sharing with people through (i.e. fb, msg, twitter)")];
    for (PremiseCell* cell in cells) {

        NSString * left = cell.leftLabel.text;

        NSString *right = cell.rightLabel.text;
        if ([right isEqualToString:
             NSLocalizedString(@"Empty lists", @"Retunred word when the lists ARE empty")] || [right isEqualToString:
                                                          NSLocalizedString(@"Select a list", @"Returned word when no there are no selected list in the premise cell")])
            continue;
        
        NSString* str = [[left stringByAppendingString:@": "] stringByAppendingString:right];
        [listsOfWords addObject:str];
    }
    UIActivityViewController * viewC = [[UIActivityViewController alloc]initWithActivityItems:listsOfWords applicationActivities:nil];
    [self presentViewController:viewC animated:YES completion:nil];
    

}
- (IBAction)selecterButtonPressed:(id)sender {

    PremiseCell * cell = (id)[_premiseTable cellForRowAtIndexPath:activeCell];
    [cell.leftText resignFirstResponder];
    [self selecterButtonShow:NO];

}
- (IBAction)settingPressed:(UIButton*)sender {
    
//    CGAffineTransform affine = CGAffineTransformMakeRotation(M_PI/2);
//    [UIView animateWithDuration:0.3f animations:^{
//
//        sender.transform = affine;
//    } ];
}



#pragma mark  Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"listsSegue"]) {
        UINavigationController* nav = [segue destinationViewController];
        FinderController* lists = (id)[nav topViewController];
        [lists setDelegate:self];
    }

    if ([segue.identifier isEqualToString:@"infoSegue"]) {
        InfoController * infoC = [segue destinationViewController];
        [infoC setDelegate:self];
    }
    
    
}
-(void)reloadAllKeys
{

    [self URLsetUp];
    [_premiseTable reloadData];
}
-(IBAction)finishedWithSettings:(UIStoryboardSegue*)sender
{

//    CGAffineTransform affine = CGAffineTransformMakeRotation(M_PI/2);
//    [UIView animateWithDuration:0.3f animations:^{
//
//        self.settingButton.transform = CGAffineTransformMakeRotation(0);;
//    } ];

}

#pragma mark - TableView Delegate
//WARNING
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [factoryDictionary removeObjectForKey:factoryKeys[indexPath.row]];
    [factoryKeys removeObjectAtIndex:indexPath.row];
    [rightFactoryKeys removeObjectAtIndex:indexPath.row];
    
    [_premiseTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    
    if (factoryKeys.count==0 )
    {
        [self enableBottomMenu:YES];
        [self.masterButton changeMasterStateTo:masterDone];
        [self edit:self.masterButton];
    }
    //    [self makeCellBecomeActive:NO atPath:nil andChangeItsStateTo:premisePresentation];
    else{
//        [self enableBottomMenu:NO];
    }

    [self saveData];
}
//WARNING
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //Si es mayor al total de premise Cell, se van a crear unas "fantasma" para que se pueda editar el texto de el premise Cell
    if (factoryKeys.count>indexPath.row) {


//        PremiseCell *cell = [[PremiseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"premiseCell"];
        PremiseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"premiseCell" forIndexPath:indexPath];
        
        //Cricual enlazar estos dos protocols a, se otra manera no "sabra" que ourre con este premise cell
        [cell setDelegate:self];
        [cell.leftText setDelegate:self];

        cell.rightLabel.text = rightFactoryKeys[indexPath.row];
        NSString* str = factoryKeys[indexPath.row];
        cell.leftLabel.text = str;


        //Mientra el texto de la celda NO sea un espacio, siginifica que tiene que presentarse
        if (![str isEqualToString:kEmptyText] )
            [cell changePremiseCellStateTo:premisePresentation];

        return cell;
    }
    else
    {
        //celda fantasma
        UITableViewCell *phatnomCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"phantomCell"];
        phatnomCell.selectionStyle = UITableViewCellSelectionStyleNone;
        phatnomCell.textLabel.text = @"Something";
        phatnomCell.textLabel.textColor = [UIColor blackColor];
        return phatnomCell;

    }
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{ return YES;}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{return 50;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{return (factoryKeys.count + phantomCellsArray.count);}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{return YES;}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    id object = factoryKeys[sourceIndexPath.row];
    [factoryKeys removeObjectAtIndex:sourceIndexPath.row];
    [factoryKeys insertObject:object atIndex:destinationIndexPath.row];
    

}
-(BOOL)shouldDismissPresentedViewControllerAndSetNewTextTo:(NSString *)newName fromOlfName:(NSString *)oldName AndIsMovingRows:(BOOL)isMoving
{
    if ([self presentedViewController]) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    return YES;
}
#pragma mark - Lists Delegate Translation
#pragma mark - Lists Delegate
-(void)finderControllerWantsToCreateNewArchiveReference:(NSArray *)refrence AtDepth:(NSArray *)depthLevel
{


    NSFileManager *fileMngr = [NSFileManager defaultManager];
    int laps = [factoryKeys count];
    for (int i = 0; i < laps; i++) {

        NSMutableArray * mutableTree = [NSMutableArray arrayWithArray: factoryDictionary[factoryKeys[i]]];
        NSMutableArray *currentBranch = [fileMngr iterateForBranchInTree:mutableTree atDepthLevel:depthLevel];
        [currentBranch insertObject:refrence atIndex:0];
        factoryDictionary[factoryKeys[i]] = [fileMngr  iterateBoolsTree:mutableTree ToUpdateBranch:currentBranch atDepthLevel:depthLevel];
    }
}
-(void)finderControllerWantsToCorroborateNewArchivesAtDepth:(NSArray *)depthLevel ComparedWithArchiveReferences:(NSArray *)references
{
    NSFileManager *fileMngr = [NSFileManager defaultManager];
//    NSMutableArray * masterTree = [fileMngr readDataOfClass:[[NSMutableArray array]class] FromURL:masterURL];
////    NSMutableArray * masterBranch = [fileMngr iterateForBranchInTree:masterTree atDepthLevel:depthLevel];
////    NSMutableArray * toCreate;
////    toCreate = [NSMutableArray objectsFrom:references thatAintHere:masterBranch];
////    
////    for (NSArray *kind in toCreate) {
////        [masterBranch insertObject:kind atIndex:0];
////    }
//    [fileMngr saveData:[fileMngr iterateBoolsTree:masterTree ToUpdateBranch:[NSMutableArray arrayWithArray:references] atDepthLevel:depthLevel] ToURL:masterURL];


    
    int laps = [factoryKeys count];
    for (int i = 0; i < laps; i++) {
       
        NSMutableArray * mutableTree = [NSMutableArray arrayWithArray: factoryDictionary[factoryKeys[i]]];
        NSMutableArray *currentBranch = [fileMngr iterateForBranchInTree:mutableTree atDepthLevel:depthLevel];
        NSMutableArray * toCreate = [NSMutableArray objectsFrom:references thatAintHere:currentBranch];
        if (toCreate.count == 0 || !toCreate) 
            break;
        factoryDictionary[factoryKeys[i]] = [fileMngr  iterateBoolsTree:mutableTree ToUpdateBranch:[NSMutableArray arrayWithArray:references] atDepthLevel:depthLevel];

        [self saveData];
    }
}
-(void)finderControllerWantsToDeleteArchiveReferences:(NSArray *)toDeleteIndexPaths AtDepth:(NSArray *)depthLevel
{

    NSFileManager *fileMngr = [NSFileManager defaultManager];
    int laps = [factoryKeys count];
    for (int i = 0; i < laps; i++) {

        NSMutableArray * mutableTree = [NSMutableArray arrayWithArray: factoryDictionary[factoryKeys[i]]];
        NSMutableArray *currentBranch = [fileMngr  iterateForBranchInTree:mutableTree atDepthLevel:depthLevel];

        NSMutableArray *toDelete = [NSMutableArray array];
        for (int  i = 0;  i < toDeleteIndexPaths.count ; i++) {
            NSIndexPath * path = [toDeleteIndexPaths objectAtIndex:i];
            id kindToDelete = [currentBranch objectAtIndex:path.row];
            [toDelete addObject:kindToDelete];
        }
        [currentBranch removeObjectsInArray:toDelete];

    factoryDictionary[factoryKeys[i]] = [fileMngr iterateBoolsTree:mutableTree ToUpdateBranch:currentBranch atDepthLevel:depthLevel];
    }

}
-(void)finderControllerWantsToCorroborateDeletedArchivesAtDepth:(NSArray *)depthLevel ComparedWithArchiveReferences:(NSArray *)references
{
//    NSFileManager *fileMngr = [NSFileManager defaultManager];
//    NSMutableArray * masterTree = [fileMngr readDataOfClass:[[NSMutableArray array]class] FromURL:masterURL];
//    NSMutableArray * masterBranch = [fileMngr iterateForBranchInTree:masterTree atDepthLevel:depthLevel];
//    NSMutableArray * toDeleteIndexPaths;
//    toDeleteIndexPaths = [NSMutableArray indexesOfObjectsFrom:references thatAintHere:masterBranch];
//
//    NSMutableArray *toDelete = [NSMutableArray array];
//    for (int  i = 0;  i < toDeleteIndexPaths.count ; i++) {
//        NSIndexPath * path = [toDeleteIndexPaths objectAtIndex:i];
//        id kindToDelete = [masterBranch objectAtIndex:path.row];
//        [toDelete addObject:kindToDelete];
//    }
//    [masterBranch removeObjectsInArray:toDelete];
//    [fileMngr saveData:[fileMngr iterateBoolsTree:masterTree ToUpdateBranch:masterBranch atDepthLevel:depthLevel] ToURL:masterURL];
    NSFileManager *fileMngr = [NSFileManager defaultManager];
//    NSMutableArray * masterTree = [fileMngr readDataOfClass:[[NSMutableArray array]class] FromURL:masterURL];
//    //    NSMutableArray * masterBranch = [fileMngr iterateForBranchInTree:masterTree atDepthLevel:depthLevel];
//    //    NSMutableArray * toCreate;
//    //    toCreate = [NSMutableArray objectsFrom:references thatAintHere:masterBranch];
//    //
//    //    for (NSArray *kind in toCreate) {
//    //        [masterBranch insertObject:kind atIndex:0];
//    //    }
//    [fileMngr saveData:[fileMngr iterateBoolsTree:masterTree ToUpdateBranch:[NSMutableArray arrayWithArray:references] atDepthLevel:depthLevel] ToURL:masterURL];

    

    int laps = [factoryKeys count];
    for (int i = 0; i < laps; i++) {

        NSMutableArray * mutableTree = [NSMutableArray arrayWithArray: factoryDictionary[factoryKeys[i]]];
        NSMutableArray *currentBranch = [fileMngr  iterateForBranchInTree:mutableTree atDepthLevel:depthLevel];
        NSMutableArray * toDeleteIndexPaths = [NSMutableArray indexesOfObjectsFrom:references thatAintHere:currentBranch];
        if (toDeleteIndexPaths.count == 0 || !toDeleteIndexPaths) 
            break;
        factoryDictionary[factoryKeys[i]] = [fileMngr iterateBoolsTree:mutableTree ToUpdateBranch:[NSMutableArray arrayWithArray:references] atDepthLevel:depthLevel];

    }

    [self saveData];
    
}
-(void)finderControllerMovedArchiveFrom:(NSIndexPath *)fromIndexPath ToIndexPath:(NSIndexPath *)toIndexPath AtDepth:(NSMutableArray*)depthLevel
{
   
//
    NSFileManager *fileMngr = [NSFileManager defaultManager];
//    NSMutableArray * masterTree = [fileMngr readDataOfClass:[[NSMutableArray array]class] FromURL:masterURL];
//    NSMutableArray * masterBranch = [fileMngr iterateForBranchInTree:masterTree atDepthLevel:depthLevel];
//
//    id str = masterBranch[fromIndexPath.row];
//    [masterBranch removeObjectAtIndex:fromIndexPath.row];
//    [masterBranch insertObject:str atIndex:toIndexPath.row];
//
//    [fileMngr saveData:[fileMngr iterateBoolsTree:masterTree ToUpdateBranch:masterBranch atDepthLevel:depthLevel] ToURL:masterURL];

    int laps = [factoryKeys count];
    for (int i = 0; i < laps; i++) {


        NSMutableArray * mutableTree = [NSMutableArray arrayWithArray:factoryDictionary[factoryKeys[i]]];
        NSMutableArray *currentBranch = [fileMngr  iterateForBranchInTree:mutableTree atDepthLevel:depthLevel];
        
        id str = currentBranch[fromIndexPath.row];
        [currentBranch removeObjectAtIndex:fromIndexPath.row];
        [currentBranch insertObject:str atIndex:toIndexPath.row];
        
        factoryDictionary[factoryKeys[i]] = [fileMngr iterateBoolsTree:mutableTree ToUpdateBranch:currentBranch atDepthLevel:depthLevel];

        [self saveData];

    }
}
#pragma mark - Premise Cell Delegate
-(void)wantsToRandomizeTextAtIndex:(NSIndexPath *)indexPath
{

    [self addValueToPragmatisim];
    [self randomizeWordsAtIndexPath:indexPath];
    
    
}
-(void)controllerShouldEnable:(BOOL)enable
{

}
-(void)willDeleteCellAtIndexPath:(NSIndexPath *)indexPath
{

    [factoryDictionary removeObjectForKey:factoryKeys[indexPath.row]];
    [factoryKeys removeObjectAtIndex:indexPath.row];
    [rightFactoryKeys removeObjectAtIndex:indexPath.row];
    [_premiseTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    if (factoryKeys.count==0 )
    {
        [self enableBottomMenu:YES];
        [self.masterButton changeMasterStateTo:masterDone];
        [self edit:self.masterButton];
    }
}

-(void)shouldChangeToIdeaStateCellAtIndex:(NSIndexPath*)indexPath
{
//    [self maxUpdate];
    if (!isThereAnActiveCell)
    [self makeCellChangeToState:premiseIdea atPath:indexPath];
    
}
-(void)shouldChangeToPresentationStateCellAtIndex:(NSIndexPath*)indexPath
{
    PremiseCell * cell = (PremiseCell*)[_premiseTable cellForRowAtIndexPath:activeCell];
    NSString * cellName = cell.leftText.text;

    //Si el texto no cambió, continua.
    if (![cellName isEqualToString:cell.leftLabel.text]) {
        //Revisar si ya existe
        if ([cellName isEqualToString:kEmptyText])  {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
                                  NSLocalizedString(@"Empty name.", @"There is no name written") message:
                                  NSLocalizedString(@"To save a premise, \n write the name of it.", @"When the user is stuck because he didnt write the name of the premise") delegate:nil cancelButtonTitle:
                                  NSLocalizedString(@"All right.", @"Used text for dismissing a presented alert view. As Ok") otherButtonTitles: nil];

            [alert show];
            [cell.leftText becomeFirstResponder];
            return;
        }
        for (NSString* str in factoryKeys) {

            
            if ([cellName isEqualToString:str]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
                                      NSLocalizedString(@"Existing Name.", @"The name you want to use, already exists.") message:
                                      NSLocalizedString(@"You already have a premise with such name, try a different one.", @"Duplicate of premise name") delegate:nil    cancelButtonTitle:
                                      NSLocalizedString(@"All right.", @"Used text for dismissing a presented alert view. As Ok") otherButtonTitles: nil];
                [alert show];
                [cell.leftText becomeFirstResponder];
                return;
            }
        }
        
    }
    [self makeCellChangeToState:premisePresentation atPath:activeCell];

    [self.masterButton changeMasterStateTo:masterDone];
    [self edit:self.masterButton];
    [self saveData];



}



#pragma mark Cell Keyboard Delegate
//Cuando se incia la edicion del text de premice CEll
-(void)textFieldDidBeginEditing:(UITextField *)textField
{

    [self selecterButtonShow:YES];

}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    PremiseCell * cell = (id)[_premiseTable cellForRowAtIndexPath:activeCell];
    [cell.leftText resignFirstResponder];
    [self selecterButtonShow:NO];
    return NO;
}



#pragma mark - Active Cell
-(void)removeIfNeededPhantomCellsOfTableView:(UITableView *)tableView
{
    if (phantomCellsArray.count != 0) {

        int removeTotalCells = [phantomCellsArray count];

        for (int i = 0; i <removeTotalCells; i++) {
            NSIndexPath*indexForRows = [NSIndexPath indexPathForItem:(factoryKeys.count) inSection:0];

            [phantomCellsArray removeObjectAtIndex:0];
            [_premiseTable deleteRowsAtIndexPaths:@[indexForRows] withRowAnimation:UITableViewRowAnimationNone];

        }
    }
}
- (void)insertIfNeededPhantomCellsAt:(NSIndexPath *)indexPath AtTableView:(UITableView *)tableView
{
    int hiddenCells = factoryKeys.count - 10;//[tableView visibleCells].count;
    int numberOfCellsToInsert = indexPath.row -hiddenCells;

    if (indexPath.row > hiddenCells) {

        for (int i = 0 ; i <numberOfCellsToInsert; i++) {

            [phantomCellsArray addObject:@"phatomCell"];
            NSIndexPath*indexForRows = [NSIndexPath indexPathForItem:(factoryKeys.count+i) inSection:0];
            [_premiseTable insertRowsAtIndexPaths:@[indexForRows] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    [_premiseTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

}


-(void)selecterContainerShow:(BOOL)show
{
    float speedOfAnimation = 0.7;
    int position =800;
    if (show)
    {
        position = 280;
        speedOfAnimation =0.4; 
    }
    [UIView animateWithDuration:speedOfAnimation animations:^{
        [self.selecterContainer setCenter:CGPointMake(self.selecterContainer.center.x, position)];}];

}
-(void)showCancelButton:(BOOL)onOrOff{
    int finalLocation= -60;
    int inverse =24;
    if (onOrOff)
    {finalLocation = 38;
        inverse =-60;};

    [UIView animateWithDuration:0.4 animations:^{
        [self.cancelButtonOut setCenter:CGPointMake(finalLocation, self.cancelButtonOut.center.y)];
        [self.settingButton setCenter:CGPointMake(inverse, self.settingButton.center.y)];
    }
     ];
}
-(void)selecterButtonShow:(BOOL)show
{  int position =kSelecterHiddenPosition;
    if (show)
        position = kSelecterListsPosition;
    [self.selecterButton setCenter:CGPointMake(position, self.selecterContainer.center.y)];
}
-(void)enableBottomMenu:(BOOL)enable
{
    [self.ideaButotn setEnabled:enable];
    [self.addButtonOutlet setEnabled:enable];
    [self.listButton setEnabled:enable];
    [self.shareButton setEnabled:enable];
}
#pragma mark 
-(void)makeCellChangeToState:(enum premiseState)state atPath:(NSIndexPath*)indexPath
{
    PremiseCell*cell = (id)[_premiseTable cellForRowAtIndexPath:indexPath];
    if (!(cell && [cell respondsToSelector:@selector(changePremiseCellStateTo:)]))
        return;


    [cell changePremiseCellStateTo:state];

    BOOL active = NO;
    if (state == premiseIdea) {
        active = YES;
    }
    if (isMakingANewCell)
    {
        [self.masterButton changeMasterStateTo:masterDone];
        [self edit:self.masterButton];
    }
    if (!active)
    {
        isMakingANewCell = NO;
        [self.masterButton changeMasterStateTo:masterEdit];
//        [self edit:self.masterButton];

        [self removeIfNeededPhantomCellsOfTableView:_premiseTable];
        lastActiveCell = activeCell;

    }
//    [self enableBottomMenu:!active];
    [cell setCellIsActive:active];
    [self showCancelButton:active];
    [self selecterContainerShow:active];
    [self selecterButtonShow:active];
    [self enableBottomMenu:!active];
    [_premiseTable setScrollEnabled:!active];


    switch (state) {

        case premiseIdea:
            [self insertIfNeededPhantomCellsAt:indexPath AtTableView:_premiseTable];
            [self.selecterController applyPreferedLists:factoryDictionary[factoryKeys[indexPath.row]]];
            [self.masterButton changeMasterStateTo:masterSave];
            
            break;
        case premisePresentation:

            factoryDictionary[factoryKeys[indexPath.row]] = [self.selecterController getPreferedLists];

            if (!([factoryKeys[indexPath.row] isEqualToString:cell.leftLabel.text])) {
                [factoryDictionary exchangeOldKey:factoryKeys[indexPath.row] WithNewKey:cell.leftLabel.text];
                factoryKeys[indexPath.row] = cell.leftLabel.text;
            }
            break;

           
        default:
            break;
    }
   
    isThereAnActiveCell = active;
    activeCell = indexPath;
    
    
}

@end
