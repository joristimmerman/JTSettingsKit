//
//  JTSettingsType.h
//  JTSettingsKit
//
//  Created by Joris Timmerman on 2/09/14.
//  Copyright (c) 2014 Joris Timmerman. All rights reserved.
//

enum {
  JTSettingTypeCustom = 0,
  JTSettingTypeSwitch = 1,
  JTSettingTypeChoice,
  JTSettingTypeMultiChoice,
	JTSettingTypeCustomEditor,
  JTSettingTypeLinkedView,
  JTSettingTypeWebView
};
typedef NSUInteger JTSettingType;

