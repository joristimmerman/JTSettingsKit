//
//  SettingsCell.m
//  JTSettingsEditor
//
//  Created by Joris Timmerman on 20/02/14.
//  Copyright (c) 2014 Joris Timmerman. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "JTSettingsCell.h"

@implementation JTSettingsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _enabled = YES;
  }
  return self;
}

- (void)setLabel:(NSString *)label {
  _label = label;
  self.textLabel.text = label;
}

- (void)dispatchValueChanged {
  if ([self.delegate
          respondsToSelector:@selector(settingsCell:valueChangedForSettingWithKey:toValue:)]) {
    [self.delegate settingsCell:self
        valueChangedForSettingWithKey:self.key
                              toValue:self.selectedValue];
  }
}

@end
