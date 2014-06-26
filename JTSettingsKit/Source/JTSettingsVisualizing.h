//
//  JTSettingsVisualizing.h
//  JTSettingsKit
//
//  Created by Joris Timmerman on 26/06/14.
//  Copyright (c) 2014 Joris Timmerman. All rights reserved.
//
@protocol JTSettingsVisualizerDelegate <NSObject>

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

@protocol JTSettingsVisualizing <NSObject>
@property id<JTSettingsVisualizerDelegate> delegate;

-(void) reload;

-(void) reloadItemAt:(NSUInteger) index inGroupAt:(NSUInteger)group;
@end
