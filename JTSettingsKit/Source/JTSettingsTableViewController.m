//
//  SettingsViewController.m
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

#import "JTSettingsTableViewController.h"
#import "JTSettingsCell.h"
#import "JTSettingsSwitchCell.h"
#import "JTSettingsChoiceCell.h"
#import "JTSettingsCustomViewCell.h"
#import "JTSettingsGroup.h"

#define kCellIdentifierSwitchCell @"SwitchCell"
#define kCellIdentifierChoiceCell @"ChoiceCell"
#define kCellIdentifierCustomCell @"CustomCell"
#define kCellIdentifierDefaultCell @"Cell"

@interface JTSettingsTableViewController ()<JTSettingsCellDelegate>

@end

@implementation JTSettingsTableViewController

- (id)init {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self registerCellTypes];
}

- (void)registerCellTypes {
  [self.tableView registerClass:[JTSettingsSwitchCell class]
         forCellReuseIdentifier:kCellIdentifierSwitchCell];
  [self.tableView registerClass:[JTSettingsChoiceCell class]
         forCellReuseIdentifier:kCellIdentifierChoiceCell];
  [self.tableView registerClass:[JTSettingsCustomViewCell class]
         forCellReuseIdentifier:kCellIdentifierCustomCell];
  [self.tableView registerClass:[JTSettingsCell class]
         forCellReuseIdentifier:kCellIdentifierDefaultCell];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)reload {
  [self.tableView reloadData];
}

- (void)reloadItemAt:(NSUInteger)cellIndex inGroupAt:(NSUInteger)group {
  [self.tableView beginUpdates];
  NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:cellIndex inSection:group];
  [self.tableView reloadRowsAtIndexPaths:@[ cellIndexPath ]
                        withRowAnimation:UITableViewRowAnimationNone];
  [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.delegate numberOfGroups];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.delegate numberOfSettingsInGroupAt:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if ([_delegate respondsToSelector:@selector(titleForGroupAt:)]) {
    return [_delegate titleForGroupAt:section];
  }
  
  return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
  if ([_delegate respondsToSelector:@selector(footerForGroupAt:)]) {
    return [_delegate footerForGroupAt:section];
  }
  
  return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *key = [self.delegate settingKeyForSettingAt:indexPath.row inGroupAt:indexPath.section];
  NSUInteger type = 0;
  
  if ([self.delegate respondsToSelector:@selector(settingTypeForSettingWithKey:inGroupAt:)]) {
    type = [self.delegate settingTypeForSettingWithKey:key inGroupAt:indexPath.section];
  }
  
  NSString *cellIdentifier = [self cellIdentifierForCellWithType:type];
  JTSettingsCell *cell =
  [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
  
  cell.key = key;
  
  NSString *label = key;
  if ([self.delegate respondsToSelector:@selector(settingLabelForSettingWithKey:inGroupAt:)]) {
    label = [self.delegate settingLabelForSettingWithKey:key inGroupAt:indexPath.section];
  }
  cell.label = label;
 
  if ([self.delegate respondsToSelector:@selector(settingEnabledForSettingWithKey:inGroupAt:)]) {
    BOOL enabled = [self.delegate settingEnabledForSettingWithKey:key inGroupAt:indexPath.section];
    cell.enabled = enabled;
  }
  
  id value = nil;
  if ([self.delegate respondsToSelector:@selector(selectedDataForSettingWithKey:inGroupAt:)]) {
    value = [self.delegate selectedDataForSettingWithKey:key inGroupAt:indexPath.section];
  }
  cell.selectedValue = value;
  
  NSString *selectedValueDescription = nil;
  if (value) {
    if ([self.delegate
         respondsToSelector:@selector(selectedDataDescriptionForSettingWithKey:inGroupAt:)]) {
      selectedValueDescription =
      [self.delegate selectedDataDescriptionForSettingWithKey:key inGroupAt:indexPath.section];
    }
  }
  cell.detailTextLabel.text = selectedValueDescription;
  
  if([self.delegate respondsToSelector:@selector(willDrawView:forSettingWithKey:inGroupAt:)]){
    [self.delegate willDrawView:cell forSettingWithKey:key inGroupAt:indexPath.section];
  }
  
  cell.delegate = self;
  
  return cell;
}

- (NSString *)cellIdentifierForCellWithType:(NSUInteger)type {
  switch (type) {
    case JTSettingTypeCustom:
      return kCellIdentifierCustomCell;
      break;
      
    case JTSettingTypeSwitch:
      return kCellIdentifierSwitchCell;
      break;
      
    case JTSettingTypeChoice:
    case JTSettingTypeMultiChoice:
      return kCellIdentifierChoiceCell;
      break;
    default:
      return kCellIdentifierDefaultCell;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (![self.delegate respondsToSelector:@selector(editorForSettingWithKey:inGroupAt:)]) {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    return;
  }
  
  JTSettingsCell *cell = (JTSettingsCell *)[tableView cellForRowAtIndexPath:indexPath];
  UIViewController<JTSettingsEditing> *editor =
  [self.delegate editorForSettingWithKey:cell.key inGroupAt:indexPath.section];
  
  [self pushEditorView:editor];
}

- (void)pushEditorView:(UIViewController<JTSettingsEditing> *)optionsController {
  [self.navigationController pushViewController:optionsController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  BOOL selectable = YES;
  
  NSString *key = [self.delegate settingKeyForSettingAt:indexPath.row inGroupAt:indexPath.section];
  if([self.delegate respondsToSelector:@selector(settingEnabledForSettingWithKey:inGroupAt:)]){
    selectable = [self.delegate settingEnabledForSettingWithKey:key inGroupAt:indexPath.section];
  }
  
  if(selectable){
    if ([self.delegate respondsToSelector:@selector(shouldSelectSettingWithKey:inGroupAt:)]) {
      selectable = [self.delegate shouldSelectSettingWithKey:key inGroupAt:indexPath.section];
    }
  }
  
  return selectable;
}

#pragma mark - cell delegate
- (void)settingsCell:(JTSettingsCell *)cell
valueChangedForSettingWithKey:(NSString *)key
             toValue:(id)value {
  if([cell isKindOfClass:[JTSettingsCustomViewCell class]]){
    return;
  }
  
  if ([self.delegate
       respondsToSelector:@selector(valueChangedForSettingWithKey:toValue:inGroupAt:)]) {
    NSIndexPath *indexPathForCell = [self.tableView indexPathForCell:cell];
    
    [self.delegate valueChangedForSettingWithKey:key
                                         toValue:value
                                       inGroupAt:indexPathForCell.section];
  }
}
@end
