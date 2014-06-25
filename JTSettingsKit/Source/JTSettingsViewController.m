//
//  JTSettingsContainerViewController.m
//  JTSettingsKit
//
//  Created by Joris Timmerman on 25/06/14.
//  Copyright (c) 2014 Joris Timmerman. All rights reserved.
//

#import "JTSettingsViewController.h"
#import "JTSettingsTableViewController.h"
#import "JTSettingsCell.h"

@interface JTSettingsViewController () <JTSettingsTableViewControllerDelegate,JTSettingsEditorDelegate>{
    
	NSMutableArray *_settingGroups;
    JTSettingsTableViewController *settingsController;
    
}

@end

@implementation JTSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)init
{
    self = [super init];
    if (self) {
        settingsController = [[JTSettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        settingsController.delegate = self;
        _autoStoreValuesInUserDefaults = NO;
        [self addChildViewController:settingsController];        
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addSettingsGroup:(JTSettingsGroup *)group {
	[self addSettingsGroup:group at:_settingGroups.count];
}

- (void)addSettingsGroup:(JTSettingsGroup *)group at:(NSUInteger)index {
	if (!_settingGroups) {
		_settingGroups = [NSMutableArray array];
	}
    
	[_settingGroups insertObject:group atIndex:index];
	[settingsController reload];
}

- (void)addSettingWithType:(JTSettingType)settingType
                   toGroup:(JTSettingsGroup *)group
                 withLabel:(NSString *)label
                    forKey:(NSString *)key
                 withValue:(id)value
                   options:(NSDictionary *)optionsOrNil {
	
    [group addSettingWithType:settingType
                        label:label
           forUserDefaultsKey:key
                    withValue:value
                      options:optionsOrNil];
    
    
	[settingsController reload];
}

#pragma mark - table delegate 

-(NSUInteger) numberOfGroups {
    return _settingGroups.count;
}

-(NSUInteger) numberOfSettingsInGroupAt:(NSUInteger) index {
    JTSettingsGroup *grp = [_settingGroups objectAtIndex:index];
    if(grp){
        return [grp count];
    }
    return 0;
}

-(NSString *) titleForGroupAt:(NSUInteger) index {
    JTSettingsGroup *group = (JTSettingsGroup *)[_settingGroups objectAtIndex:index];
    
	if (group) {
		return [group title];
	}
    return nil;
}

-(NSString *) footerForGroupAt:(NSUInteger) index {
    JTSettingsGroup *group = (JTSettingsGroup *)[_settingGroups objectAtIndex:index];
    
	if (group) {
		return [group footer];
	}
    
    return nil;
}

-(NSString *) settingKeyForSettingAt:(NSUInteger) index inGroupAt:(NSUInteger) groupIndex {
    JTSettingsGroup *group = [self groupAtIndex:groupIndex];
    if(group){
        return [group keyOfSettingAt:index];
    }
    return nil;
}

-(BOOL) shouldSelectSettingWithKey:(NSString*) key inGroupAt:(NSUInteger) groupIndex{
    JTSettingsGroup *group = [self groupAtIndex:groupIndex];
    if(group){
        return [group hasEditorForSettingWithKey:key];
    }
    return NO;
}

-(UIViewController<JTSettingsEditing>*) editorForSettingWithKey:(NSString *)key inGroupAt:(NSUInteger)groupIndex {

    JTSettingsGroup *group = (JTSettingsGroup *)[_settingGroups objectAtIndex:groupIndex];
    
	if (group) {
		UIViewController<JTSettingsEditing> *editor = [group editorForSettingWithKey:key];
        
        if(editor){
            editor.settingsGroup = group;
            editor.settingsKey = key;
            
            NSDictionary *editorData= nil;
            if([self.settingDelegate respondsToSelector:@selector(settingsViewController:dataForSettingEditorDataForSettingKey:)]){
                editorData = [self.settingDelegate settingsViewController:self dataForSettingEditorDataForSettingKey:key];
            }
            editor.data = editorData;
            editor.selectedValue = [group settingValueForSettingWithKey:key];
            
            editor.delegate = self;
            
            return editor;
        }
	}
    
    return nil;
}

-(NSString *) settingLabelForSettingWithKey:(NSString*) key inGroupAt:(NSUInteger) groupIndex {
    JTSettingsGroup *group = [_settingGroups objectAtIndex:groupIndex];
    if(group){
        return [group settingLabelForSettingWithKey:key];
    }
    return nil;
}

-(JTSettingType) settingTypeForSettingWithKey:(NSString*) key inGroupAt:(NSUInteger) groupIndex {
    JTSettingsGroup *group = [_settingGroups objectAtIndex:groupIndex];
    if(group){
        return [group settingTypeForSettingWithKey:key];
    }
    return JTSettingTypeCustom;
}

-(id) selectedDataForSettingWithKey:(NSString*) key inGroupAt:(NSUInteger) groupIndex{
    JTSettingsGroup *group = [_settingGroups objectAtIndex:groupIndex];
    if(group){
        return [group settingValueForSettingWithKey:key];
    }
    return nil;
}

-(NSString *) selectedDataDescriptionForSettingWithKey:(NSString*) key inGroupAt:(NSUInteger) groupIndex {
    JTSettingsGroup *group = [_settingGroups objectAtIndex:groupIndex];
    if(group){
        id value = [group settingValueForSettingWithKey:key];
        if ([self.settingDelegate respondsToSelector:@selector(descriptionForValue:forKey:)]) {
            return [self.settingDelegate descriptionForValue:value forKey:key];
        }
    }
    return nil;
}

- (JTSettingsGroup *)groupAtIndex:(NSUInteger)groupIndex {
	return (JTSettingsGroup *)[_settingGroups objectAtIndex:groupIndex];
}

#pragma mark - SettingsOptionsViewControllerDelegate
- (void)settingsEditorViewController:(UIViewController<JTSettingsEditing> *) viewController selectedValueChangedToValue:(id)value {

    [viewController.settingsGroup updateSettingValue:value
                                   forSettingWithKey:viewController.settingsKey];
    
    if (self.autoStoreValuesInUserDefaults) {
		JTSettingsGroup *group = viewController.settingsGroup;
		JTSettingType settingType = [group settingTypeForSettingWithKey:viewController.settingsKey];
		switch (settingType) {
			case JTSettingTypeSwitch:
				[[NSUserDefaults standardUserDefaults] setBool:[(NSNumber *)value boolValue] forKey:viewController.settingsKey];
				break;
                
			default:
				[[NSUserDefaults standardUserDefaults] setValue:value forKey:viewController.settingsKey];
				break;
		}
        
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
    
    [settingsController reload];    
}

@end
