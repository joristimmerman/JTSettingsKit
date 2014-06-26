//
//  SettingsViewController.h
//  JTSettingsEditor
//
//  Created by Joris Timmerman on 19/02/14.
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

#import "JTSettingsEditing.h"

@protocol JTSettingsTableViewControllerDelegate;
@interface JTSettingsTableViewController : UITableViewController
@property id<JTSettingsTableViewControllerDelegate> delegate;

-(void) reload;

-(void) reloadCellAt:(NSUInteger) cellIndex inGroupAt:(NSUInteger)group;

@end

@protocol JTSettingsTableViewControllerDelegate <NSObject>

-(NSUInteger) numberOfGroups;

-(NSUInteger) numberOfSettingsInGroupAt:(NSUInteger) index;

-(NSString *) settingKeyForSettingAt:(NSUInteger) index inGroupAt:(NSUInteger) group;

@optional
-(NSString *) titleForGroupAt:(NSUInteger) index;
-(NSString *) footerForGroupAt:(NSUInteger) index;

-(UIViewController<JTSettingsEditing> *) editorForSettingWithKey:(NSString *) key inGroupAt:(NSUInteger) group;

-(BOOL) shouldSelectSettingWithKey:(NSString*) key inGroupAt:(NSUInteger) group;
-(NSString *) settingLabelForSettingWithKey:(NSString*) key inGroupAt:(NSUInteger) group;
-(NSUInteger) settingTypeForSettingWithKey:(NSString*) key inGroupAt:(NSUInteger) group;
-(id) selectedDataForSettingWithKey:(NSString*) key inGroupAt:(NSUInteger) group;
-(NSString *) selectedDataDescriptionForSettingWithKey:(NSString*) key inGroupAt:(NSUInteger) group;

-(void)cellValueChangedForSettingWithKey:(NSString *)key toValue:(id)value inGroupAt:(NSUInteger) group;

@end