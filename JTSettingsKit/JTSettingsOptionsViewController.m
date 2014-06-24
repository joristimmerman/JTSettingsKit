//
//  SettingsOptionsViewController.m
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

#import "JTSettingsOptionsViewController.h"

@interface JTSettingsOptionsViewController ()
{
	NSObject *_defaultValue;
}
@end

@implementation JTSettingsOptionsViewController

- (id)initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
	if (self) {
		[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)setOptions:(NSArray *)options {
	_options = options;
	[self.tableView reloadData];
}

- (void)setSelectedData:(id)selectedData {
	_selectedData = selectedData;
	[self selectSelectedData];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSUInteger count = self.options.count;
	return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	cell.textLabel.text = [self textForCellIndex:indexPath];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	_selectedData = [self.options objectAtIndex:indexPath.row];
	if (_selectedData) {
		if ([self.delegate respondsToSelector:@selector(settingsOptionsViewController:selectedValueChangedToValue:)]) {
			NSArray *keys = [_selectedData allKeys];
			NSObject *key = [keys objectAtIndex:0];
			[self.delegate settingsOptionsViewController:self selectedValueChangedToValue:key];
		}

		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (NSString *)textForCellIndex:(NSIndexPath *)indexPath {
	NSDictionary *dict = [self.options objectAtIndex:indexPath.row];
	NSString *key = [[dict allKeys] objectAtIndex:0];

	return [dict objectForKey:key];
}

- (void)selectRowWithKey:(NSObject *)key {
	NSInteger index = -1;
	for (NSDictionary *dictionary in _options) {
		NSString *dictKey = [[dictionary allKeys] objectAtIndex:0];
		if ([dictKey isEqual:key]) {
			index = [_options indexOfObject:dictionary];
			break;
		}
	}

	if (index >= 0) {
		NSIndexPath *pathToCell = [NSIndexPath indexPathForRow:index inSection:0];
		[self.tableView selectRowAtIndexPath:pathToCell animated:YES scrollPosition:UITableViewScrollPositionNone];
	}
}

- (void)selectSelectedData {
	if (!_selectedData) {
		return;
	}
	[self performSelector:@selector(selectRowWithKey:) withObject:_selectedData afterDelay:0];
}

@end
