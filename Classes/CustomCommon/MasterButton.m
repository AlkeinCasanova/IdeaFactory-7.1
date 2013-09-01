//
//  MasterButton.m
//  Table
//
//  Created by Renato Casanova on 5/27/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import "MasterButton.h"
#import "AlertStrings.h"

@implementation MasterButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentState = masterEdit;
        
    }
    return self;
}
-(void)changeMasterStateTo:(enum masterState)state
{
    switch (state) {
        case masterEdit:
            [self setTitle:NSLocalizedString(@"edit", @"Button title edit") forState:UIControlStateNormal];
            break;
            
        case masterDone:
            [self setTitle:NSLocalizedString(@"done", @"Button title done") forState:UIControlStateNormal];
            
            break;
        case masterSave:
            [self setTitle:NSLocalizedString(@"save", @"Button title save") forState:UIControlStateNormal];
            break;
        case masterHide:

            [self setTitle:NSLocalizedString(@"hide", @"Button title hide") forState:UIControlStateNormal];
            
        default:
            break;
    }
    _lastState =_currentState;
    _currentState = state;
}

@end
