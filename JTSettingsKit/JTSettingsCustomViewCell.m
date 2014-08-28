//
//  JTSettingsControlCell.m
//  JTSettingsKit
//
//  Created by Joris Timmerman on 31/07/14.
//  Copyright (c) 2014 Joris Timmerman. All rights reserved.
//

#import "JTSettingsCustomViewCell.h"

@implementation JTSettingsCustomViewCell

-(UIView *) controlView {
  return (UIView *) self.selectedValue;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.detailTextLabel.hidden = self.textLabel.hidden = NO;
  }
  return self;
}

-(void) setEnabled:(BOOL)enabled
{
  super.enabled = enabled;
  
  UIView *customView = [self controlView];
  customView.userInteractionEnabled = enabled;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  UIView *customView = [self controlView];
  if([customView superview] != self){
    if([customView superview]){
      [customView removeFromSuperview];
    }

    [self addSubview:customView];
  }
  
  [customView setFrame:rect];
}


@end
