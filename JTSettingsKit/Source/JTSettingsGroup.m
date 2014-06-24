//
//  SettingsGroup.m
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

#import "JTSettingsGroup.h"
#import "JTSettingsGroupSettingDictionary.h"

#pragma mark -Internal class
@interface Setting : NSObject
@property NSUInteger type;
@property NSString *userDefaultsKey;
@property id value;
@property NSString *label;
@property NSDictionary *options;

- (id)initWithType:(NSInteger)type label:(NSString *)label userDefaultsKey:(NSString *)userDefaultsKey andValue:(id)value;

@end

@implementation Setting

- (id)initWithType:(NSInteger)type label:(NSString *)label userDefaultsKey:(NSString *)userDefaultsKey andValue:(id)value {
	self = [self init];
	if (self) {
		self.label = label;
		self.type = type;
		self.userDefaultsKey = userDefaultsKey;
		self.value = value;
	}
	return self;
}

@end

#pragma mark -SettingsGroup class

@interface JTSettingsGroup () {
	JTSettingsGroupSettingDictionary *_options;
}

@end
@implementation JTSettingsGroup

- (id)init {
	self = [super init];
	if (self) {
		_options = [JTSettingsGroupSettingDictionary dictionary];
	}
	return self;
}

- (id)initWithTitle:(NSString *)title {
	self = [self init];
	if (self) {
		self.title = title;
	}
	return self;
}

- (NSUInteger)count {
	if (!_options) {
		return 0;
	}
	return _options.allKeys.count;
}

- (void)addOptionForType:(SettingsOptionType)settingType label:(NSString *)label forUserDefaultsKey:(NSString *)userDefaultsKey withValue:(id)value options:(NSDictionary *)optionsOrNil {
	Setting *setting = [[Setting alloc] initWithType:settingType label:label userDefaultsKey:userDefaultsKey andValue:value];
	setting.options = optionsOrNil;

	[_options setObject:setting forKey:userDefaultsKey];
}

- (id)settingValueForSettingWithKey:(NSString *)key {
	Setting *setting = [_options objectForKey:key];
	return setting.value;
}

- (NSString *)settingLabelForSettingWithKey:(NSString *)key {
	Setting *setting = [_options objectForKey:key];
	return setting.label;
}

- (SettingsOptionType)settingTypeForSettingWithKey:(NSString *)key {
	Setting *setting = [_options objectForKey:key];
	return setting.type;
}

- (void)updateSettingValue:(id)value forSettingWithKey:(NSString *)key {
	Setting *setting = [_options objectForKey:key];
	setting.value = value;
}

- (void)updateSettingLabel:(NSString *)label forSettingWithKey:(NSString *)key {
	Setting *setting = [_options objectForKey:key];
	setting.label = label;
}

- (void)updateSettingType:(SettingsOptionType)type forSettingWithKey:(NSString *)key {
	Setting *setting = [_options objectForKey:key];
	setting.type = type;
}

- (NSString *)keyOfSettingAt:(NSUInteger)index {
	NSString *key = [[_options allKeys] objectAtIndex:index];
	return key;
}

- (BOOL)hasKey:(NSString *)key {
	return ([_options objectForKey:key] != nil);
}

- (NSUInteger)indexForKey:(NSString *)key {
	return [[_options allKeys] indexOfObject:key];
}

@end
