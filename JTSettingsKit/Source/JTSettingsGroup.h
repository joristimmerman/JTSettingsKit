//
//  SettingsGroup.h
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
#import "JTSettingsEditing.h"
#import "JTSettingsType.h"

@interface JTSettingsGroup : NSObject

@property NSString *key;
@property NSString *title;
@property NSString *footer;

- (NSUInteger)count;

- (id)init;
- (id)initWithTitle:(NSString *)title;
- (id)initWithKey:(NSString *) key;

- (void)addSettingWithType:(JTSettingType)settingType
                     label:(NSString *)label
        forUserDefaultsKey:(NSString *)userDefaultsKey
                 withValue:(id)value
                   options:(NSDictionary *)optionsOrNil;

- (void)addSettingWithEditor:(Class)editorClass
                       label:(NSString *)label
          forUserDefaultsKey:(NSString *)userDefaultsKey
                   withValue:(id)value
                     options:(NSDictionary *)optionsOrNil;

- (void)addSettingWithLinkedView:(UIView *) linkedView
                           label:(NSString *)label
                         options:(NSDictionary *)optionsOrNil;

- (void)addWebLinkWithURL:(NSURL *) url
                           linkLabel:(NSString *)label;


- (void)addSettingWithControl:(UIView *)control;

- (id)settingValueForSettingWithKey:(NSString *)key;
- (NSString *)settingLabelForSettingWithKey:(NSString *)key;
- (JTSettingType)settingTypeForSettingWithKey:(NSString *)key;
- (Class)editorClassForSettingWithKey:(NSString *)key;
- (NSDictionary *)editorPropertiesForSettingWithKey:(NSString *)key;

- (void)updateSettingValue:(id)value forSettingWithKey:(NSString *)key;
- (void)updateSettingLabel:(NSString *)label forSettingWithKey:(NSString *)key;
- (void)updateSettingType:(JTSettingType)type forSettingWithKey:(NSString *)key;

- (void)setSettingWithKey:(NSString *)key enabled:(BOOL) enabled;
- (BOOL)settingWithKeyIsEnabled:(NSString *)key;

- (NSString *)keyOfSettingAt:(NSUInteger)index;

- (BOOL)hasEditorForSettingWithKey:(NSString *)key;

- (BOOL)hasKey:(NSString *)key;
- (NSUInteger)indexForKey:(NSString *)key;
@end
