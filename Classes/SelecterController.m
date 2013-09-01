//
//  SelecterController.m
//  Table
//
//  Created by Renato Casanova on 5/25/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import "SelecterController.h"
#import "BWFileManagementAdditions.h"
#import "URLConst.h"
#import "AlertStrings.h"

#define kHiddenIntheRIGHT 480
#define kHiddenIntheLEFT -160
#define kPresenting 160
@interface SelecterController ()
{
    NSArray *pNameList;
    NSArray *iNameList;
    NSMutableArray *mBoolsTree;

    NSMutableArray *nameOfFolders;
    
    NSMutableArray *cPBoolBranch;
    NSMutableArray *cIBoolBranch;
    
    // Non edited bools
    BOOL sholdReturnUntouchedLists;
    BOOL isBottomTableView;
    BOOL presentedTableViewIsPrime;
    NSMutableArray *mUnBoolsTree;

    //Current Depth      
    NSMutableArray *selecterDepth;
    

    BOOL isPTablePresented;
    

}
@end

@implementation SelecterController

//GOOD
- (IBAction)backButtonPressed:(id)sender {
    [self presentLastTableView];
}

-(void)loadInitialDataAndBOOLS
{
    selecterDepth = [NSMutableArray arrayWithObject:@0];
    mBoolsTree = [NSMutableArray array];
    cPBoolBranch = [NSMutableArray array];
    cIBoolBranch = [NSMutableArray array];
    nameOfFolders = [NSMutableArray array];
}
//GOOD
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadInitialDataAndBOOLS];
}
- (void)didReceiveMemoryWarning{ [super didReceiveMemoryWarning];}

#pragma mark - Table view data source
//GOOD
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag) {
        return cPBoolBranch.count;

    }
    else
    {
        return cIBoolBranch.count;
    }
}
//DOIN GOOD FIX FILE ARRANGEMENT.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    id decicive;
    NSArray *kind;
    if (tableView.tag)
    {
        kind =cPBoolBranch[indexPath.row];
        if ([kind[2]respondsToSelector:@selector(objectAtIndex:)])

            decicive =NO;
            else
                decicive =kind[2];
    }
    else
    {
        kind =cIBoolBranch[indexPath.row];

        if ([kind[2]respondsToSelector:@selector(objectAtIndex:)])
            decicive =NO;
        else
            decicive =kind[2];
    }
    
    
    if ([kind[0]boolValue] ) //List
    {

        static NSString *CellIdentifier = @"listCell";
        SelecterCell *cell = (SelecterCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell setDelegate:self];

        cell.indentationLevel = 1;
        cell.imageView.image  = [UIImage imageNamed:kArtList];
        [cell activateImagesForSelectedState:[decicive boolValue] ];

        cell.textLabel.text = kind[1];
        return cell;    }
    else //Folder
    {

        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"folderCell" forIndexPath:indexPath];



        cell.textLabel.font = [UIFont fontWithName:kStringFont size:20];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        cell.textLabel.text = kind[1];
        cell.indentationLevel = 1;
        cell.imageView.image  = [UIImage imageNamed:kArtFolder];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;

        return cell;
    }





    
}

#pragma mark - Selcter Delegate
//BETTER
-(void)didSelectListCellAtIndexPath:(NSIndexPath *)indexPath fromTableView:(UITableView *)tableView
{
    NSMutableArray *kind;
    if (tableView.tag)
    {
        kind =[NSMutableArray arrayWithArray: cPBoolBranch[indexPath.row]];
        [kind replaceObjectAtIndex:2 withObject:@1];
        [cPBoolBranch replaceObjectAtIndex:indexPath.row withObject:kind];

        mBoolsTree =  [[NSFileManager defaultManager] iterateBoolsTree:mBoolsTree ToUpdateBranch:cPBoolBranch atDepthLevel:selecterDepth];
    }
    else
    {
        kind =[NSMutableArray arrayWithArray: cIBoolBranch[indexPath.row]];
        [kind replaceObjectAtIndex:2 withObject:@1];
        [cIBoolBranch replaceObjectAtIndex:indexPath.row withObject:kind];
        mBoolsTree =  [[NSFileManager defaultManager] iterateBoolsTree:mBoolsTree ToUpdateBranch:cIBoolBranch atDepthLevel:selecterDepth];
    }

    sholdReturnUntouchedLists = NO;
}

//BETTER
-(void)didDeselectListCellAtIndexPath:(NSIndexPath *)indexPath fromTableView:(UITableView *)tableView
{
    NSMutableArray *kind;
    if (tableView.tag)
    {
        kind =[NSMutableArray arrayWithArray: cPBoolBranch[indexPath.row]];
        [kind replaceObjectAtIndex:2 withObject:@0];
        [cPBoolBranch replaceObjectAtIndex:indexPath.row withObject:kind];

        mBoolsTree =  [[NSFileManager defaultManager] iterateBoolsTree:mBoolsTree ToUpdateBranch:cPBoolBranch atDepthLevel:selecterDepth];
    }
    else
    {
        kind =[NSMutableArray arrayWithArray: cIBoolBranch[indexPath.row]];
        [kind replaceObjectAtIndex:2 withObject:@0];
        [cIBoolBranch replaceObjectAtIndex:indexPath.row withObject:kind];
        mBoolsTree =  [[NSFileManager defaultManager] iterateBoolsTree:mBoolsTree ToUpdateBranch:cIBoolBranch atDepthLevel:selecterDepth];
    }

    sholdReturnUntouchedLists = NO;
}

//FIXME
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isBottomTableView =NO;

    NSNumber * level = [NSNumber numberWithInt:indexPath.row];
    
    NSString *buttonName;
    
    [selecterDepth addObject:level];
    
//    [self presentNextTableViewAsPrime:!tableView.tag AndButtonNextText:buttonName WithAnimation:YES];
    if (tableView.tag)//Table Is Prime
    {
       NSArray *kind =  cPBoolBranch[indexPath.row];
        buttonName = kind[1];
        
        [self presentNextTableViewAsPrime:NO andFolderName:buttonName WithAnimation:YES];
    }
    else
    {


        NSArray *kind =  cIBoolBranch[indexPath.row];
        buttonName = kind[1];
        [self presentNextTableViewAsPrime:YES andFolderName:buttonName WithAnimation:YES];
    }
}

-(void)presentNextTableViewAsPrime:(BOOL)prime andFolderName:(NSString*)folder WithAnimation:(BOOL)animate
{
    presentedTableViewIsPrime =prime;

    

    if (prime)
    {
        if (self.pTable.center.x != kHiddenIntheRIGHT)
            [self.pTable setCenter:CGPointMake(kHiddenIntheRIGHT, self.pTable.center.y)];

        cPBoolBranch= [[NSFileManager defaultManager] iterateForBranchInTree:mBoolsTree atDepthLevel:selecterDepth];


        [self.pTable reloadData];
        if (animate){
            [UIView animateWithDuration:0.4 animations:^{

                [self.iTable setCenter:CGPointMake(kHiddenIntheLEFT, self.pTable.center.y)];
                [self.pTable setCenter:CGPointMake(kPresenting,self.iTable.center.y)];
            }];
        }
        else{
            [self.iTable setCenter:CGPointMake(kHiddenIntheLEFT, self.pTable.center.y)];
            [self.pTable setCenter:CGPointMake(kPresenting,self.iTable.center.y)];
        }


    }
    else
    {
        if (self.iTable.center.x != kHiddenIntheRIGHT)
            [self.iTable setCenter:CGPointMake(kHiddenIntheRIGHT, self.iTable.center.y)];


        cIBoolBranch= [[NSFileManager defaultManager] iterateForBranchInTree:mBoolsTree atDepthLevel:selecterDepth];

        [self.iTable reloadData];
        if (animate) {
            [UIView animateWithDuration:0.4 animations:^{

                [self.iTable setCenter:CGPointMake(kPresenting,self.iTable.center.y)];
                [self.pTable setCenter:CGPointMake(kHiddenIntheLEFT, self.pTable.center.y)];

            }];
        }
        else{

            [self.iTable setCenter:CGPointMake(kPresenting,self.iTable.center.y)];
            [self.pTable setCenter:CGPointMake(kHiddenIntheLEFT, self.pTable.center.y)];

        }
    }
    
    if (isBottomTableView) {
        [self.backButtonOutLet setCenter:CGPointMake(-60, self.backButtonOutLet.center.y)];
    }
    else
    {
        
        [self performFadeInButtonWithText:self.folderTitle.text];
        [self performFadeInText:folder];
        [nameOfFolders addObject:folder];
    }

}

-(void)applyPreferedLists:(NSMutableArray*)bools
{


    [self loadInitialDataAndBOOLS];
    NSMutableArray *safe = [NSMutableArray arrayWithArray:bools];
    sholdReturnUntouchedLists = YES;
    mUnBoolsTree = bools;
    isBottomTableView =YES;


    mBoolsTree = safe;
    NSString * toSend =
    NSLocalizedString(@"Lists", @"Lists as title");
    [self performFadeInText:toSend];
    [nameOfFolders addObject:toSend];

    [self presentNextTableViewAsPrime:YES andFolderName:toSend WithAnimation:NO];
}
-(NSMutableArray *)getPreferedLists
{

    NSMutableArray * arrayToGet = [NSMutableArray arrayWithArray:mBoolsTree];

    [self loadInitialDataAndBOOLS];
    if (sholdReturnUntouchedLists)
        return mUnBoolsTree;
    
    return [NSMutableArray arrayWithArray:arrayToGet];
}

//WARNING
-(void)presentLastTableView
{

    int indexToDeselec = [[selecterDepth lastObject] integerValue];
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:indexToDeselec inSection:0];

    [selecterDepth removeLastObject];
    if (presentedTableViewIsPrime) {

        presentedTableViewIsPrime=NO;
        if (self.iTable.center.x != kHiddenIntheLEFT)
            [self.iTable setCenter:CGPointMake(kHiddenIntheLEFT, self.iTable.center.y)];
        



        cIBoolBranch = [[NSFileManager defaultManager] iterateForBranchInTree:mBoolsTree atDepthLevel:selecterDepth];
        [self.iTable reloadData];

        [self.iTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];

        [UIView animateWithDuration:0.3 animations:^{
            [self.iTable setCenter:CGPointMake(kPresenting, self.iTable.center.y)];
            [self.pTable setCenter:CGPointMake(kHiddenIntheRIGHT,self.pTable.center.y)];

        } completion:^(BOOL finished){

            [self.iTable deselectRowAtIndexPath:indexPath animated:YES];
        }];
        
    }
    else{


        presentedTableViewIsPrime=YES;

        if (self.pTable.center.x != kHiddenIntheLEFT)
            [self.pTable setCenter:CGPointMake(kHiddenIntheLEFT, self.pTable.center.y)];
        

        cPBoolBranch = [[NSFileManager defaultManager] iterateForBranchInTree:mBoolsTree atDepthLevel:selecterDepth];
        [self.pTable reloadData];

        [self.pTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];


        [UIView animateWithDuration:0.3 animations:^{
            [self.pTable setCenter:CGPointMake(kPresenting, self.pTable.center.y)];
            [self.iTable setCenter:CGPointMake(kHiddenIntheRIGHT,self.iTable.center.y)];

        }completion:^(BOOL finished){
            [self.pTable deselectRowAtIndexPath:indexPath animated:YES];

        }];

    }
    if (selecterDepth.count == 1) {
        isBottomTableView =YES;

        [nameOfFolders removeLastObject];
        [self performFadeOutButtonWithText:kEmptyText Animated:NO];
        [self performFadeOutText:
         NSLocalizedString(@"Lists", @"Lists as title")];

    }
    else
    {

        [nameOfFolders removeLastObject];

        [self performFadeOutText:[self.backButtonOutLet titleForState:UIControlStateNormal]];
        int length = nameOfFolders.count;
        [self performFadeOutButtonWithText:nameOfFolders[(length-2)] Animated:YES];
        


    }


    
}
-(void)performFadeInText:(NSString*)newText
{
    [UIView animateWithDuration:0.1f
                     animations:^{

                         [self.folderTitle setAlpha:0];
                         [self.folderTitle setCenter:CGPointMake(0, self.folderTitle.center.y)];


                     } completion:^(BOOL finished ){


                         [self.folderTitle setText:newText];
                         [self.folderTitle setAlpha:1];

                         [self.folderTitle setCenter:CGPointMake(420, self.folderTitle.center.y)];
                         [UIView animateWithDuration:0.4 animations:^{

                             [self.folderTitle setCenter:CGPointMake(160, self.folderTitle.center.y)];
                         }];

                     }];
    
}
-(void)performFadeOutText:(NSString*)newText
{
    [UIView animateWithDuration:0.1f
                     animations:^{

                         [self.folderTitle setAlpha:0];

                         [self.folderTitle setCenter:CGPointMake(180, self.folderTitle.center.y)];


                     } completion:^(BOOL finished ){
                         [self.folderTitle setText:newText];

                         [self.folderTitle setAlpha:1];

                         [self.folderTitle setCenter:CGPointMake(-60, self.folderTitle.center.y)];

                         [UIView animateWithDuration:0.2 animations:^{

                             [self.folderTitle setCenter:CGPointMake(160, self.folderTitle.center.y)];
                         }];
                         
                     }];
    
}

-(void)performFadeInButtonWithText:(NSString*)str
{
    [UIView animateWithDuration:0.1f
                     animations:^{
                         [self.backButtonOutLet setCenter:CGPointMake(-60, self.backButtonOutLet.center.y)];


                     } completion:^(BOOL finished ){
                         [self.backButtonOutLet setTitle:str forState:UIControlStateNormal];
                         [self.backButtonOutLet setAlpha:0];
                         [self.backButtonOutLet setCenter:CGPointMake(120, self.backButtonOutLet.center.y)];
                         [UIView animateWithDuration:0.2 animations:^{

                             [self.backButtonOutLet setAlpha:1];
                             [self.backButtonOutLet setCenter:CGPointMake(38, self.backButtonOutLet.center.y)];
                         }];
                         
                     }];
    
}
-(void)performFadeOutButtonWithText:(NSString*)text Animated:(BOOL)animated
{

    [UIView animateWithDuration:0.1f
                     animations:^{

                         [self.backButtonOutLet setAlpha:0];
                         [self.backButtonOutLet setCenter:CGPointMake(120, self.backButtonOutLet.center.y)];


                     } completion:^(BOOL finished ){


                         [self.backButtonOutLet setTitle:text forState:UIControlStateNormal];
                         [self.backButtonOutLet setCenter:CGPointMake(-60, self.backButtonOutLet.center.y)];
                         if (animated) {
                             [UIView animateWithDuration:0.2 animations:^{

                                 [self.backButtonOutLet setAlpha:1];
                                 [self.backButtonOutLet setCenter:CGPointMake(38, self.backButtonOutLet.center.y)];
                             }];
                         }

                     }];

}

@end
