//
//  SelecterCell.m
//  Table
//
//  Created by Renato Casanova on 4/28/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import "SelecterCell.h"
#import "AlertStrings.h"

@interface SelecterCell ()
{
    UIImageView *selectedImage;
    UIView *alphaView;
    UIButton* button;

    
}

@end
@implementation SelecterCell


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.textLabel.font = [UIFont fontWithName:kStringFont size:18];
        [self.textLabel setTextColor:[UIColor whiteColor]];

        [self unImageCheck];
        [self imageCheck];
        [self selectiveButton];

        
    }
    return self;
}
-(void)unImageCheck
{

//    UIImage *img = [UIImage imageNamed:@"checkIcon2"];
//    UIImageView* unSelectedImage = [[UIImageView alloc]initWithImage:img];
//
//    [unSelectedImage setFrame:CGRectMake(280, 7, 30, 30)];
//    [self.contentView addSubview:unSelectedImage];
}
-(void)imageCheck
{
    alphaView = [[UIView alloc]initWithFrame:self.contentView.frame];
    alphaView.backgroundColor = [UIColor whiteColor];
    alphaView.alpha = 0.5;
    [alphaView setHidden:YES];
    [self.contentView addSubview:alphaView];
    UIImage *img = [UIImage imageNamed:@"checkIcon"];
    selectedImage = [[UIImageView alloc]initWithImage:img];
    
    [selectedImage setFrame:CGRectMake(280, 7, 30, 30)];

    [selectedImage setHidden:YES];
    
    [self.contentView addSubview:selectedImage];

}
-(void)selectiveButton
{
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:self.contentView.frame];

    [button addTarget:self action:@selector(changeCurrentSelectedState) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    
}

-(void)changeCurrentSelectedState
{

    UITableView* table = (id)[self superview];
    NSIndexPath* indexPath = [table indexPathForCell:self];
    if (self.selectedCell)
    {
//        self.contentView.backgroundColor = [UIColor redColor];
        [self activateImagesForSelectedState:NO];
        if(self.delegate && [self.delegate respondsToSelector:@selector(didDeselectListCellAtIndexPath:fromTableView:)])
            [self.delegate didDeselectListCellAtIndexPath:indexPath fromTableView:table];
    }

    else
    {
        [self activateImagesForSelectedState:YES];

        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectListCellAtIndexPath:fromTableView:)])
            [self.delegate didSelectListCellAtIndexPath:indexPath fromTableView:table];

    }

}

-(void)activateImagesForSelectedState:(BOOL)selected

{

    [selectedImage setHidden:!selected];
    [alphaView setHidden:!selected];
        self.selectedCell = selected;

    
    
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{

}
-(void)setSelected:(BOOL)selected{

}


@end
