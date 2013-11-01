//
//  PremiseCell.m
//  Table
//
//  Created by Renato Casanova on 4/25/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import "PremiseCell.h"
#import "AlertStrings.h"
#import "BWColors.h"

#define kRightViewHidden 660
#define kRightViewShow 260

#define kFlyButtonSize 40
#define kFlyButtonWithSizeForDelete 80

#define kFlyingCenter 220
#define kFlyButtonRight 220
#define kFlyButtonMiddle 120
#define kFlyButtonDelete 420
#define kFlyButtonHiddenTOLEFT -100

#define kFlyButtonMiddleText @">"
#define kFlyButtonRightText @"<"


#define kLeftViewNormalPosition 130
#define kLeftViewHiddenPosition -130
@interface PremiseCell ()
{

    UIFont *fontMain;
    UIFont *fontSmall;

    UIButton *magicButton;
    UIButton *controllerButton;

    UIView *bottomView;
    UITableView* bottomTableView;

    NSString* textForLaterUse;





}

@end
@implementation PremiseCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //Required code for inital setup and noral behaviour.
        [self backGroundColorsSetUp];
        [self setFrame:CGRectMake(0, 0, 320, 50)];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

        [self movingControlerSetUp];
        [self leftViewSetUp];
        [self rightViewSetUp];
        self.backgroundColor = [UIColor clearColor];
        
        _cellIsActive =NO;



    }
    return self;
    
}

-(void)prepareForReuse
{
    [self changePremiseCellStateTo:premisePresentation];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (self.cellIsActive) {
        return;
    }
    if (self.currentState == premiseIdea ) {
        return;
    }
    if (editing) 
            [self changePremiseCellStateTo:premiseEdit];
        else
        {

                [self changePremiseCellStateTo:premisePresentation];
            
        }
//
    [super setEditing:editing animated:animated];
}

#pragma mark - ChageState
-(void)randomize:(NSString*)string
{
    textForLaterUse = [string copy];
    [self changePremiseCellStateTo:premiseRandomizer];
}

-(void)controllerButtonDidPressed
{

    NSIndexPath * indexPath = [self currentIndexPath];

    if (self.delegate && [self.delegate respondsToSelector:@selector(premiseCell:wantsToMoveFromHere:)]) 
        [self.delegate premiseCell:self wantsToMoveFromHere:indexPath];
    

}
-(void)wantsRandomWord
{


    NSIndexPath * indexPath = [self currentIndexPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(wantsToRandomizeTextAtIndex:)]) 
        [self.delegate wantsToRandomizeTextAtIndex:indexPath];
    
}
- (UITableView *)_containingTableView
{
      UIView *tableView = self.superview;

     while (tableView)
        {
           if ([tableView isKindOfClass:[UITableView class]])
                   {
                         return (UITableView *)tableView;
                       }

                tableView = tableView.superview;
            }

     return nil;
}
-(NSIndexPath*)currentIndexPath
{
    id table = [self _containingTableView];
    NSIndexPath* indexPath;
    if ([table respondsToSelector:@selector(indexPathForCell:)]) {
        return indexPath = [table indexPathForCell:self];
    }
    return nil;
}
-(void)magicButtonDidPressed
{



    NSIndexPath * indexPath = [self currentIndexPath];



    switch (self.currentState) {
        case premiseIdea:

            if (self.delegate && [self.delegate respondsToSelector:@selector(shouldChangeToPresentationStateCellAtIndex:)])
            [self.delegate  shouldChangeToPresentationStateCellAtIndex:indexPath];

            break;

        case premiseEdit:


            [self changePremiseCellStateTo:premiseDelete];

            break;
        case premisePresentation:


            if (self.delegate && [self.delegate respondsToSelector:@selector(shouldChangeToIdeaStateCellAtIndex:)])
            [self.delegate shouldChangeToIdeaStateCellAtIndex:indexPath];

            break;
        default:
            break;
    }
    
}
-(void)changePremiseCellStateTo:(enum premiseState)state
{
    [self animateLeftViewToPosition:kLeftViewNormalPosition];
    [self animateContollerToShow:NO];

    if (self.delegate && [self.delegate respondsToSelector:@selector(premiseWillChangeToState:)]) 
        [self.delegate premiseWillChangeToState:state];

    


    _lastCurrentState =_currentState;
    
    _currentState = state;
//    NSLog(@"Last State: %i",_lastCurrentState);
//    NSLog(@"CurreState: %i",_currentState);
    switch (state) {
        case premisePresentation:
            [self presentText:YES];
            [self animateRightViewToLocation:kRightViewShow];
            [self animateFlyButtonToLocation:kFlyButtonMiddle WithText:kFlyButtonMiddleText];

            break;
            
        case premiseIdea:
            [self editText];
            [self animateRightViewToLocation:kRightViewHidden];
            [self animateFlyButtonToLocation:kFlyButtonRight WithText:kFlyButtonRightText];
            break;


        
        case premiseRandomizer:
            
            [self animateRightViewForRandom];
             break;
        case premiseCancel:


            [self presentText:NO];
            [self changePremiseCellStateTo:premisePresentation];
            break;
        case premiseEdit:

//            [self animateContollerToShow:YES];
            [self presentText:YES];
            [self animateRightViewToLocation:kRightViewHidden];
            [self animateFlyButtonToLocation:kFlyButtonDelete WithText:kEmptyText];
            [self moveLeftLabelReadyForEditing];
            
            break;

        case premiseDelete:


            [self changePremiseCellStateTo:premisePresentation];
            
            [self animateForDeletion];
            break;
        default:
            break;
    }
    [self moveLeftLabelReadyForEditing];


}

#pragma mark - Text Preservation

-(void)presentText:(BOOL)shouldPresentText
{

    if (shouldPresentText) {
        if (self.lastCurrentState == premiseIdea)
            self.leftLabel.text = self.leftText.text;
        
        
        if ([self.leftLabel.text isEqualToString:kEmptyText]) 
            self.leftLabel.text =NSLocalizedString(@"Write name of premise", @"WriteNameOfPremise beacuse it is empty");


    }

    [self.leftText resignFirstResponder];
    [self.leftLabel setHidden:NO];
    [self.leftText setHidden:YES];

}
-(void)editText

{
    _leftText.text =_leftLabel.text;

    if ([_leftLabel.text isEqualToString:NSLocalizedString(@"Write name of premise", @"WriteNameOfPremise beacuse it is empty")]) {
        _leftText.text =kEmptyText;
        _leftText.placeholder =NSLocalizedString(@"Write name of premise", @"WriteNameOfPremise beacuse it is empty");
    }
    
    [_leftLabel setHidden:YES];
    [_leftText setHidden:NO];
    [_leftText becomeFirstResponder];
}



#pragma mark - State Animations

-(void)animateContollerToShow:(BOOL)show
{
    int position = 350;
    if (show)  position = 290;

    [UIView animateWithDuration:0.3f animations:^{
        [controllerButton setCenter:CGPointMake(position, controllerButton.center.y)];
    }];
}
-(void)animateRightViewForRandom
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(controllerShouldEnable:)])
//        [self.delegate controllerShouldEnable:NO];

    [UIView animateWithDuration:0.4f animations:^{
        [_rightView setCenter:CGPointMake(kRightViewHidden, 30)];
        
    } completion:^(BOOL finished){

            [UIView animateWithDuration:0.7f animations:^{
                
                [self.rightLabel setText:textForLaterUse];
                [_rightView setCenter:CGPointMake(kRightViewShow, 30)];} completion:^(BOOL finished)
             {

                 [self changePremiseCellStateTo:premisePresentation];
             }
                 
                ];

        



    }];

}
-(void)animateRightViewToLocation:(int)location
{
    [UIView animateWithDuration:0.5f animations:^{
        [_rightView setCenter:CGPointMake(location, 30)];
    }];
    
}
-(void)animateFlyButtonToLocation:(int)location WithText:(NSString*)text
{
    CGRect magicFrame;

        [magicButton setBackgroundImage:[UIImage imageNamed:@"buttonDisc"] forState:UIControlStateNormal ];
        magicFrame = CGRectMake(location, 0, kFlyButtonSize, kFlyButtonSize);
        magicButton.titleLabel.font = fontMain;
       
    [UIView animateWithDuration:0.6
                     animations:^{

                         [magicButton setFrame:magicFrame];

                         [magicButton setTitle:text forState:UIControlStateNormal];
                         
                     }];
}
-(void)animateLeftViewToPosition:(int)position

{
        [UIView animateWithDuration:1 animations:^{
            [_leftView setCenter:CGPointMake(position, 20)];
        }];
    

    
    
}

-(void)moveLeftLabelReadyForEditing
{
    int location = 0;
    if (_currentState == premiseEdit) {
        location=95;
    }
    else
        location =65;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.leftLabel setCenter:CGPointMake(location, self.leftLabel.center.y)];
    }];
    
}

-(void)animateForDeletion
{

    NSIndexPath * indexPath = [self currentIndexPath];

    [UIView animateWithDuration:0.2 animations:^{

        [self.leftView setCenter:CGPointMake(-130, self.leftView.center.y)];
        if (self.delegate && [self.delegate respondsToSelector:@selector(willDeleteCellAtIndexPath:)])
        [self.delegate willDeleteCellAtIndexPath:indexPath];
    }];

}

#pragma mark - Font & Background


-(void)backGroundColorsSetUp;
{

    fontMain = [UIFont fontWithName:kStringFont  size:17];
    fontSmall = [UIFont fontWithName:kStringFont size:20];
    
}
-(void)movingControlerSetUp
{
    controllerButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [controllerButton setFrame:CGRectMake(350, 0,60,kFlyButtonSize)];

    [controllerButton setBackgroundImage:[UIImage imageNamed:@"buttonDisc"] forState:UIControlStateNormal ];
    controllerButton.titleLabel.font = [UIFont fontWithName:kStringFont  size:30];
    [controllerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [controllerButton addTarget:self action:@selector(controllerButtonDidPressed) forControlEvents:UIControlEventTouchUpInside];


    [self.contentView addSubview:controllerButton];
    
    
}
#pragma mark - Left View

-(void)leftViewSetUp
{
    _leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 40)];

    [_leftView setBackgroundColor:hexColor(kColorPContext)];
    [_leftView setCenter:CGPointMake(-150, 20)];

    [self addSubview:_leftView];
    [self leftLabelSetUpInView:_leftView];
    [self leftTextSetUpInView:_leftView];
    [self magicButtonSetUpInView:_leftView];
}
-(void)leftLabelSetUpInView:(UIView*)view
{
    int lengt = kFlyButtonMiddle -10;
    _leftLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, lengt, 40)];
    [_leftLabel setText:kEmptyText];
    [_leftLabel setFont:fontMain];
    [_leftLabel setTextColor:[UIColor whiteColor]];
    [_leftLabel setBackgroundColor:view.backgroundColor];
    [_leftLabel setHidden:NO];
    
    [view addSubview:self.leftLabel];
}
-(void)leftTextSetUpInView:(UIView*)view
{
    _leftText = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
    _leftText.placeholder = NSLocalizedString(@"Write name of premise", @"WriteNameOfPremise beacuse it is empty");
    [_leftText setFont:fontMain];
    _leftText.textColor = [UIColor whiteColor];
    [_leftText setBorderStyle:UITextBorderStyleNone];
    [_leftText setBackgroundColor:[UIColor clearColor]];
    [_leftText setHidden:YES];
    _leftText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _leftText.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [view addSubview:_leftText];
    
}
-(void)magicButtonSetUpInView:(UIView*)view
{
    magicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [magicButton setFrame:CGRectMake(kFlyingCenter, 0,kFlyButtonSize,kFlyButtonSize)];
    
//    [magicButton setBackgroundImage:[UIImage imageNamed:@"buttonDisc"] forState:UIControlStateNormal ];
    [magicButton setBackgroundColor:hexColor(kColorPWeak)];
    magicButton.titleLabel.font = [UIFont fontWithName:kStringFont  size:30];
    [magicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [magicButton addTarget:self action:@selector(magicButtonDidPressed) forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:magicButton];
}




#pragma mark - Right View

-(void)rightViewSetUp
{
    _rightView = [[UIView alloc]initWithFrame:CGRectMake(320, 10, 180, 40)];
    [_rightView setBackgroundColor:hexColor(kColorPSuplement)];
   
    [self addSubview:_rightView];
    [self rightLabelSetUpInView:_rightView];
    [self rightButtonAtView:_rightView];

    
}
-(void)rightButtonAtView:(UIView*)view
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [button addTarget:self action:@selector(wantsRandomWord) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];

}
-(void)rightLabelSetUpInView:(UIView*)view
{
   _rightLabel =[[UILabel alloc]initWithFrame:CGRectMake( 10, 0, view.frame.size.width, view.frame.size.height)];
    [_rightLabel setText:NSLocalizedString(@"random", @"Default word for when a new premise is created")];
    [_rightLabel setFont:fontMain];
    [_rightLabel setTextColor:[UIColor whiteColor]];
    [_rightLabel setBackgroundColor:[UIColor clearColor]];
    
    
    [view addSubview:_rightLabel];
    
}



@end
