This page is intended for developers looking to extend existing functionality (like adding more themes or app icons)

### Contents  
- [Setting up the project](#xcode)
- [Adding more themes](#themes)
- [Adding more app icons](#icons)
- [Unlocking Plus options](#plus)

<a name="xcode">

## Setting up the project
Follow these steps to setup BookPlayer with your account:

* Use "Xcode-config/DEVELOPMENT_TEAM.template.xcconfig" as a template for your individual "DEVELOPMENT_TEAM.xcconfig" file. See "Xcode-config/Shared.xcconfig" for details. Duplicate the template, rename it and change the variables using your Team ID and reverse domain.

* The App Group has then been automatically derived in Xcode based on your settings above. Select the project file, select the target `BookPlayer` and go to the `Signing & Capabilities` tab.

Register the App ID as displayed In Identity > Bundle Identifier of your BookPlayer target via <https://developer.apple.com/account/>. Then the App Group. It should have the format `group.$(BP_APP_BUNDLE_ID).files`. See https://www.appcoda.com/app-group-macos-ios-communication/ for step-by-step instructions.

* Similarily, register the derived App ID/Bundle Identifier for the widget (effectively `$(BP_APP_BUNDLE_ID).BookPlayerWidget`), and then the derived App Group. It should have the format `group.$(BP_WIDGET_ID).files`. 

Now select the project file, select the target BookPlayer and go to the Signing & Capabilities tab, here you will:

* Go to the section App Groups, make sure the selected group isn't red, if it is, just deselect it, and select it again (if they disappear, hit the refresh icon in the bottom of the empty list and then it'll show up again). Be careful when selecting again, if you have multiple values, the list entry will jump around and change its position in the list.

Hopefully this is not the case, but you may need to manually [register some of the derived bundle IDs](http://docs.drupalgap.org/7/Compiling_a_Mobile_Application/Publishing_an_App_for_iOS/Registering_a_new_Bundle_ID).

NOTE: This will edit BookPlayer/BookPlayer.entitlements in the background. Please don’t commit these changes to the entitlements files. You can safely revert them using git.

* You may have to toggle "Automatically manage signing" for each target. This will trigger automatic generation of the necessary provisioning files and signing certificates. Without this you will get errors like "An empty identity is not valid when signing a binary for the product type 'Some Type'."

NOTE: Please don’t commit the project file changes triggered by the above.

* Use the same approach you used for App Groups in BookPlayer’s iCloud section, and the App Groups sections for BookPlayerWidget, BookPlayerWatch, BookPlayerWatch Extension.

* You may have to run "Clean Build Folder" in Xcode’s "Products" menu.

* Currently, you still have to manually edit the value for ApplicationGroupIdentifier in "Shared/Constants.swift" to match "group.\$(BP_APP_BUNDLE_ID).files".

And you should be able to run the project now 💪 (if you find any problems, please feel free to open a ticket, or contact us via Discord)

<a name="themes"/>

## Adding more themes
All the colors in the app, are derived from four main colors for the light variant, and four main colors for the dark variant. These colors are categorized as: 

- The primary color: used for titles.
- The secondary color: used for subtitles.
- The accent color: used as the tint for buttons and selected items.
- The background color.

To create a new theme, it's as simple as adding a new entry in the file [Themes.json](https://github.com/TortugaPower/BookPlayer/blob/develop/BookPlayer/Library/Themes/Themes.json), which must provide the following fields:

| Field name | Type | Description |
| --- | --- | --- |
| title | String | The name that you want displayed inside the app |
| lightPrimaryHex | String | (Hex code) Light variant used for primary labels like titles |
| lightSecondaryHex | String | (Hex code) Light variant used for secondary labels like descriptions |
| lightAccentHex | String | (Hex code) Light variant used for actionable items |
| lightSeparatorHex | String | (Hex code) Light variant used for the line separators in tables |
| lightSystemBackgroundHex | String | (Hex code) Light variant used for the background of the library view |
| lightSecondarySystemBackgroundHex | String | (Hex code) Light variant used for the hovering mini player |
| lightTertiarySystemBackgroundHex | String | (Hex code) Light variant used for the progress pie |
| lightSystemGroupedBackgroundHex | String | (Hex code) Light variant used for the background of the settings view |
| lightSystemFillHex | String | (Hex code) Light variant used for the progress pie |
| lightSecondarySystemFillHex | String | (Hex code) Light variant used for the progress pie |
| lightTertiarySystemFillHex | String | (Hex code) Light variant not actually used but needed |
| lightQuaternarySystemFillHex | String | (Hex code) Light variant not actually used but needed |
| darkPrimaryHex | String | (Hex code) Dark variant used for primary labels like titles |
| darkSecondaryHex | String | (Hex code) Dark variant used for secondary labels like descriptions |
| darkAccentHex | String | (Hex code) Dark variant used for actionable items |
| darkSeparatorHex | String | (Hex code) Dark variant for the highlight color |
| darkSystemBackgroundHex | String | (Hex code) Dark variant used for the background of the library view |
| darkSecondarySystemBackgroundHex | String | (Hex code) Dark variant used for the hovering mini player |
| darkTertiarySystemBackgroundHex | String | (Hex code) Dark variant used for the progress pie |
| darkSystemGroupedBackgroundHex | String | (Hex code) Dark variant used for the background of the settings view |
| darkSystemFillHex | String | (Hex code) Dark variant used for the progress pie  |
| darkSecondarySystemFillHex | String | (Hex code) Dark variant used for the progress pie |
| darkTertiarySystemFillHex | String | (Hex code) Dark variant not actually used but needed |
| darkQuaternarySystemFillHex | String | (Hex code) Dark variant not actually used but needed |

<a name="icons"/>

## Adding App Icons
To add a new app icon, you need to:

1. Add a new entry in the file [Icons.json](https://github.com/TortugaPower/BookPlayer/blob/develop/BookPlayer/Library/Icons/Icons.json), which must provide the following fields:

| Field name | Type | Description |
| --- | --- | --- |
| id | String | The id of the icon |
| title | String | The name that you want displayed inside the app |
| imageName | String | The name of the image file |

2. Provide the necessary image assets for the [iPhone folder](https://github.com/TortugaPower/BookPlayer/blob/develop/BookPlayer/Library/Icons/assets/iPhone) and the [iPad folder](https://github.com/TortugaPower/BookPlayer/blob/develop/BookPlayer/Library/Icons/assets/iPad).
  - iPhone sizes: 120x120 (@2x), 180x180 (@3x)
  - iPad sizes: 152x152 (@2x), 167x167 (@3x)

3. Update the [Info.plist](https://github.com/TortugaPower/BookPlayer/blob/develop/BookPlayer/Info.plist) to let the OS know about these options.
  - There are two `CFBundleAlternateIcons` in the list, one for the iPhone icons, and another for the iPad icons
  - Create a new `Dictionary` key for both options. Use the `title` of the new icon as the name of the key
  - For these newly created `Dictionary` keys, add a new `Array` key for each of them. Use `CFBundleIconFiles` as the name of the new `Array` keys.
  - The final step, is to add one element to each of these new `Array` keys. This new element is a `String` type, and should have the `imageName` as its value

<a name="plus"/>

## Unlocking Plus options
The easiest way is to remove the `locked` key from the `json` objects inside the files [Info.plist](https://github.com/TortugaPower/BookPlayer/blob/develop/BookPlayer/Info.plist) and [Icons.json](https://github.com/TortugaPower/BookPlayer/blob/develop/BookPlayer/Library/Icons/Icons.json). When you launch the app, everything should be unlocked.

The other option is to modify the preferences file of the app, it usually is found in the following path inside the app container: `Library/Preferences/com.tortugapower.audiobookplayer.plist`. In this file, add the following entry
```xml
<key>userSettingsDonationMade</key>
<true/>
```
