JTSettingsKit (iOS)
===================

Settings kit containing a skeleton to easily integrate settings in an iOS app.
To make life a bit easier, some common settings types are integrated.

Currently available settings types:
- Switch
- Choice list

Usage example:
--------------
This example will create 2 sections with 1 setting each.

```objc
-(void) showSettingsView {
    JTSettingsViewController *settingsController = [[JTSettingsViewController alloc] init];
    settingsController.settingDelegate = self;
    settingsController.title = @"Settings";
    
    // create a group (one is required)
    JTSettingsGroup *generalGroup = [[JTSettingsGroup alloc] initWithTitle:@"General Settings"];
    
    //add a setting to the generalGroup
    [generalGroup addSettingWithType:JTSettingTypeSwitch
                             label:@"On/Off Switch"
                forUserDefaultsKey:@"OnOff"
                         withValue:[NSNumber numberWithBool:YES]
                           options:nil];
    
    // create a new section: Camera
    JTSettingsGroup *cameraGroup = [[JTSettingsGroup alloc] initWithTitle:@"Camera"];
    
    // Add a select setting (selection of 1 item in a list)
    [cameraGroup addSettingWithType:JTSettingTypeChoice
                            label:@"Video resolutions"
               forUserDefaultsKey:@"VideoResolutions"
                        withValue:@"high"
                          options:nil];

    JTSettingsGroup *buttonGroup = [[JTSettingsGroup alloc] initWithTitle:@"Custom"];
    UIButton *aButton = [[UIButton alloc] init];
    [aButton addTarget:self action:@selector(settingBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [aButton setTitle:@"Press me" forState:UIControlStateNormal];
    [aButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [buttonGroup addSettingWithControl:aButton];
  
    [settingsController addSettingsGroup:generalGroup];
    [settingsController addSettingsGroup:cameraGroup];
    [settingsController addSettingsGroup:buttonGroup];
    
    [self presentViewController:settingsController animated:YES completion:nil];
}

- (NSDictionary *)settingsViewController: (JTSettingsViewController *)settingsViewController
           dataForSettingEditorDataForSettingKey:(NSString *)key {
    
    if([key isEqualToString:@"VideoResolutions"]){
        // this setting uses the build in choice list editor. This editor requires key:label data.
        return @{@"high": @"High",
                 @"med": @"Medium",
                 @"low": @"Low"
                 };
    }
    
  return nil;
}

- (void)settingsViewController:(JTSettingsViewController *)settingsViewController
 valueChangedForSettingWithKey:(NSString *)key toValue:(id)value{
    NSLog(@"Setting with key %@ changed to %@", key, value);
    // update your model
}

- (NSString *)descriptionForValue:(id)value forKey:(NSString *)key{
  // return human readable text for an option
    return [NSString stringWithFormat:@"Setting %@", value];
}
```