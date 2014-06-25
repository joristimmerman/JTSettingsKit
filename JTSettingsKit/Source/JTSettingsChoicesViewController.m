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

#import "JTSettingsChoicesViewController.h"

@interface JTSettingsChoicesViewController ()
{
	NSObject *_defaultValue;
    NSMutableArray *_selectedItems;
}
@end

@implementation JTSettingsChoicesViewController
- (id)init
{
    self = [super init];
    if (self) {
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
	if (self) {
		[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
	}
	return self;
}

- (void)setData:(NSDictionary *)options {
	_data = options;
	[self.tableView reloadData];
}

- (void)setSelectedValue:(id)selectedValue{
    if([selectedValue isKindOfClass:[NSArray class]]){
        _selectedItems = selectedValue;
    }else{
        _selectedItems = [NSMutableArray arrayWithObject:selectedValue];
    }
	[self selectSelectedData];
}

-(id) selectedValue{
    if(_allowMultiSelection){
        return _selectedItems;
    }
    return [_selectedItems firstObject];
}

-(void) setAllowMultiSelection:(BOOL)allowMultiSelection {
    _allowMultiSelection = allowMultiSelection;
    self.tableView.allowsMultipleSelection = allowMultiSelection;
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
	NSUInteger count = [self.data.allKeys count];
	return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	cell.textLabel.text = [self textForCellIndex:indexPath];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [[self.data allKeys] objectAtIndex:indexPath.row];
	if (key) {
        [_selectedItems addObject:key];
        
		if ([self.delegate respondsToSelector:@selector(settingsEditorViewController:selectedValueChangedToValue:)]) {
			[self.delegate settingsEditorViewController:self selectedValueChangedToValue:key];
		}

		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (NSString *)textForCellIndex:(NSIndexPath *)indexPath {
    NSString *key = [[self.data allKeys] objectAtIndex:indexPath.row];
    return key ? [self.data objectForKey:key] : nil;
}

- (void)selectRowWithKey:(NSObject *)key {
	NSInteger index = -1;

    NSUInteger c=0;
    for(NSObject *keyInData in [_data allKeys]){
        if([key isEqual:keyInData]){
            index=c;
            break;
        }
        c++;
    }

	if (index >= 0) {
		NSIndexPath *pathToCell = [NSIndexPath indexPathForRow:index inSection:0];
		[self.tableView selectRowAtIndexPath:pathToCell animated:YES scrollPosition:UITableViewScrollPositionNone];
	}
}

- (void)selectRowsWithKeys:(NSArray *)keys {
    for(id key in keys){
        [self selectRowWithKey:key];
    }
}

- (void)selectSelectedData {
	if (!_selectedItems || _selectedItems.count == 0) {
		return;
	}
    
    [self performSelector:@selector(selectRowsWithKeys:) withObject:_selectedItems afterDelay:0];
}

@end
