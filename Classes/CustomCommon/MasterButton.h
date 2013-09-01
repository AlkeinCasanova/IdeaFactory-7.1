//
//  MasterButton.h
//  Table
//
//  Created by Renato Casanova on 5/27/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import <UIKit/UIKit.h>
enum masterState {

    //BOOL keep for cell is active.
    masterEdit =0,

    masterSave =1,

    //Move without worries

    masterDone =3,

    masterHide = 4,
    
};
@interface MasterButton : UIButton

@property (nonatomic)enum masterState currentState;
@property (nonatomic)enum masterState lastState;
-(void)changeMasterStateTo:(enum masterState)state;
@end
