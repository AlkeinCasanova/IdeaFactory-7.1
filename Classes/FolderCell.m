//
//  FolderCell.m
//  Table
//
//  Created by Renato Casanova on 6/7/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import "FolderCell.h"

@implementation FolderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
