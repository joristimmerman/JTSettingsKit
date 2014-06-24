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

#import "JTSettingsViewController.h"
#import "JTSettingsOptionsViewController.h"

#import "JTSettingsSwitchCell.h"
#import "JTSettingsMultiChoice.h"

#define kCellIdentifierSwitchCell @"SwitchCell"
#define kCellIdentifierMultiValueCell @"MultiValueCell"

enum {
	SettingsTypeSlider,
	SettingsTypeText,
	SettingsTypeChoice
};
typedef NSInteger SettingsType;


@interface JTSettingsViewController () <JTSettingsCellDelegate, JTSettingsOptionsViewControllerDelegate>
{
	NSMutableArray *_settingGroups;
}

@end

@implementation JTSettingsViewController

- (id)init {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		self.autoStoreValuesInUserDefaults = YES;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self registerCellTypes];
}

- (void)registerCellTypes {
	[self.tableView registerClass:[JTSettingsSwitchCell class] forCellReuseIdentifier:kCellIdentifierSwitchCell];
	[self.tableView registerClass:[JTSettingsMultiChoice class] forCellReuseIdentifier:kCellIdentifierMultiValueCell];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)addSettingsGroup:(JTSettingsGroup *)group {
	[self addSettingsGroup:group at:_settingGroups.count];
}

- (void)addSettingsGroup:(JTSettingsGroup *)group at:(NSUInteger)index {
	if (!_settingGroups) {
		_settingGroups = [NSMutableArray array];
	}

	[_settingGroups insertObject:group atIndex:index];
	[self.tableView reloadData];
}

- (void)addSettingOptionOfType:(SettingsOptionType)settingType toGroup:(JTSettingsGroup *)group withLabel:(NSString *)label forKey:(NSString *)key withValue:(id)value options:(NSDictionary *)optionsOrNil {
	[group addOptionForType:settingType label:label forUserDefaultsKey:key withValue:value options:optionsOrNil];
	[self.tableView reloadData];
}

- (void)addSettingOptionOfType:(SettingsOptionType)settingType toGroupAt:(NSUInteger)index withLabel:(NSString *)label forKey:(NSString *)key withValue:(id)value options:(NSDictionary *)optionsOrNil {
	JTSettingsGroup *group = (JTSettingsGroup *)[_settingGroups objectAtIndex:index];
	if (group) {
		[self addSettingOptionOfType:settingType toGroup:group withLabel:label forKey:key withValue:value options:optionsOrNil];
		[self.tableView reloadData];
	}
}

- (void)setTitle:(NSString *)title forGroupAt:(NSUInteger)index {
	JTSettingsGroup *group = (JTSettingsGroup *)[_settingGroups objectAtIndex:index];
	if (group) {
		group.title = title;
	}
}

- (void)setFooter:(NSString *)footer forGroupAt:(NSUInteger)index {
	JTSettingsGroup *group = (JTSettingsGroup *)[_settingGroups objectAtIndex:index];
	if (group) {
		group.footer = footer;
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([_settingGroups count] > 0) {
		return [_settingGroups count];
	}

	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	JTSettingsGroup *group = (JTSettingsGroup *)[_settingGroups objectAtIndex:section];

	if (group) {
		return [group count];
	}

	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	JTSettingsGroup *group = (JTSettingsGroup *)[_settingGroups objectAtIndex:section];

	if (group) {
		return [group title];
	}

	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	JTSettingsGroup *group = (JTSettingsGroup *)[_settingGroups objectAtIndex:section];

	if (group) {
		return [group footer];
	}

	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	JTSettingsGroup *group = [self groupAtIndex:indexPath.section];
	NSString *cellIdentifier = [self cellIdentifierForCellAt:indexPath.row inGroup:indexPath.section];

	JTSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

	cell.key =  [group keyOfSettingAt:indexPath.row];
	cell.label =  [group settingLabelForSettingWithKey:cell.key];
	cell.value = [group settingValueForSettingWithKey:cell.key];

	NSLog(@"Cell for key %@, %@", cell.key, cell.value);

	if ([self.delegate respondsToSelector:@selector(descriptionForValue:forKey:)]) {
		cell.detailTextLabel.text = [self.delegate descriptionForValue:cell.value forKey:cell.key];
	}

	cell.delegate = self;

	return cell;
}

- (JTSettingsGroup *)groupAtIndex:(NSUInteger)groupIndex {
	return (JTSettingsGroup *)[_settingGroups objectAtIndex:groupIndex];
}

- (JTSettingsGroup *)groupWithKey:(NSString *)key {
	for (JTSettingsGroup *group in _settingGroups) {
		if ([group hasKey:key]) {
			return group;
		}
	}

	return nil;
}

- (NSString *)cellIdentifierForCellAt:(NSUInteger)cellIndex inGroup:(NSUInteger)groupIndex {
	JTSettingsGroup *group = [self groupAtIndex:groupIndex];

	if (group) {
		NSString *key = [group keyOfSettingAt:cellIndex];
		SettingsOptionType type = [group settingTypeForSettingWithKey:key];
		switch (type) {
			case SettingsOptionTypeSwitch:
				return kCellIdentifierSwitchCell;
				break;

			case SettingsOptionTypeMultiValue:
				return kCellIdentifierMultiValueCell;
				break;
		}
	}

	return @"Cell";
}

- (JTSettingsCell *)cellForSettingsKey:(NSString *)key {
	JTSettingsGroup *group = [self groupWithKey:key];
	NSInteger sectionIndex = [_settingGroups indexOfObject:group];
	NSInteger cellIndex = [group indexForKey:key];

	NSIndexPath *pth  = [NSIndexPath indexPathForRow:cellIndex inSection:sectionIndex];
	return (JTSettingsCell *)[self.tableView cellForRowAtIndexPath:pth];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	JTSettingsGroup *group = [self groupAtIndex:indexPath.section];

	if (group) {
		NSString *key = [group keyOfSettingAt:indexPath.row];
		SettingsOptionType type = [group settingTypeForSettingWithKey:key];

		switch (type) {
			case SettingsOptionTypeMultiValue:
				[tableView deselectRowAtIndexPath:indexPath animated:YES];

				NSArray *options;
				if ([self.delegate respondsToSelector:@selector(settingsViewController:optionsForSettingWithKey:)]) {
					options = [self.delegate settingsViewController:self optionsForSettingWithKey:key];
				}
				id value = [group settingValueForSettingWithKey:key];
				[self pushSelectionViewWithOptions:options forKey:key withValue:value];
				break;
		}
	}
}

#pragma mark - cell delegate
- (void)settingsCell:(JTSettingsCell *)cell valueChangedForSettingWithKey:(NSString *)key toValue:(id)value {
	NSIndexPath *path = [self.tableView indexPathForCell:cell];
	JTSettingsGroup *group = [self groupAtIndex:path.section];

	[group updateSettingValue:value forSettingWithKey:key];

	if ([self.delegate respondsToSelector:@selector(settingsViewController:valueChangedForSettingWithKey:toValue:)]) {
		[self.delegate settingsViewController:self valueChangedForSettingWithKey:key toValue:value];
	}

	if (self.autoStoreValuesInUserDefaults) {
		NSString *key = [group keyOfSettingAt:path.row];
		SettingsOptionType settingType = [group settingTypeForSettingWithKey:key];
		switch (settingType) {
			case SettingsOptionTypeSwitch:
				[[NSUserDefaults standardUserDefaults] setBool:[(NSNumber *)value boolValue] forKey:key];
				break;

			default:
				[[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
				break;
		}


		NSLog(@"Setting %@ saved %@", key, value);
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void)pushSelectionViewWithOptions:(NSArray *)options forKey:(NSString *)key withValue:(id)valueOrNil {
	JTSettingsOptionsViewController *optionsController = [[JTSettingsOptionsViewController alloc] initWithStyle:UITableViewStyleGrouped];
	optionsController.delegate = self;
	optionsController.key = key;
	optionsController.selectedData = valueOrNil;

	NSMutableArray *dictArr = [NSMutableArray array];
	for (id option in options) {
		NSString *descr = [NSString stringWithFormat:@"%@", option];

		if ([self.delegate respondsToSelector:@selector(descriptionForValue:forKey:)]) {
			descr = [self.delegate descriptionForValue:option forKey:key];
		}

		NSDictionary *dict = [NSDictionary dictionaryWithObject:descr forKey:option];
		[dictArr addObject:dict];
	}

	optionsController.options = [NSArray arrayWithArray:dictArr];

	[self.navigationController pushViewController:optionsController animated:YES];
}

#pragma mark - SettingsOptionsViewControllerDelegate
- (void)settingsOptionsViewController:(JTSettingsOptionsViewController *)viewController selectedValueChangedToValue:(id)value {
	NSString *key =  viewController.key;

	JTSettingsCell *cell = [self cellForSettingsKey:key];
	cell.value = value;

	if ([self.delegate respondsToSelector:@selector(descriptionForValue:forKey:)]) {
		cell.detailTextLabel.text = [self.delegate descriptionForValue:value forKey:key];
	}
	else {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", key];
	}

	[cell dispatchValueChanged];
}

@end
