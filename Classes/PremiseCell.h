//
//  PremiseCell.h
//  Table
//
//  Created by Renato Casanova on 4/25/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import <UIKit/UIKit.h>

enum premiseState {
    //ACTIVE CELL.

    premiseIdea=1,


    //NOT ACTIVE CELL.
    premisePresentation = 10,
    premiseRandomizer =11,

    premiseEdit =100,
    premiseDelete = 101,
    premiseCancel =102,


    
    };
@class PremiseCell;
@protocol PremiseProtocol <NSObject>

@optional
-(void)premiseWillChangeToState:(enum premiseState)state;

-(void)premiseCell:(PremiseCell*)premiseCell wantsToMoveFromHere:(NSIndexPath*)indexPath;
-(void)controllerShouldEnable:(BOOL)yes;
-(void)wantsToRandomizeTextAtIndex:(NSIndexPath* )indexPath;
@required


-(void)willDeleteCellAtIndexPath:(NSIndexPath*)indexPath;
-(void)shouldChangeToIdeaStateCellAtIndex:(NSIndexPath*)indexPath;
-(void)shouldChangeToPresentationStateCellAtIndex:(NSIndexPath*)indexPath;
@end

@interface PremiseCell : UITableViewCell  

@property (nonatomic) BOOL cellIsActive;
@property (nonatomic) enum premiseState currentState;
@property (nonatomic) enum premiseState lastCurrentState;

@property (nonatomic) UIView *leftView;
@property (nonatomic) UILabel *leftLabel;
@property (nonatomic) UITextField *leftText;
@property (nonatomic) UIView *rightView;
@property (nonatomic) UILabel *rightLabel;


@property(nonatomic)id <PremiseProtocol> delegate;

-(void)changePremiseCellStateTo:(enum premiseState)state;
-(void)randomize:(NSString*)string;



@end



