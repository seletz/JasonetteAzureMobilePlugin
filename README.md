# JasonetteAzureMobilePlugin

[![CI Status](http://img.shields.io/travis/seletz/JasonetteAzureMobilePlugin.svg?style=flat)](https://travis-ci.org/Stefan Eletzhofer/JasonetteAzureMobilePlugin)
[![Version](https://img.shields.io/cocoapods/v/JasonetteAzureMobilePlugin.svg?style=flat)](http://cocoapods.org/pods/JasonetteAzureMobilePlugin)
[![License](https://img.shields.io/cocoapods/l/JasonetteAzureMobilePlugin.svg?style=flat)](http://cocoapods.org/pods/JasonetteAzureMobilePlugin)
[![Platform](https://img.shields.io/cocoapods/p/JasonetteAzureMobilePlugin.svg?style=flat)](http://cocoapods.org/pods/JasonetteAzureMobilePlugin)

## What is it?

This is an example plug-in for [Jasonette](http://jasonette.com).  This plug-in implements
actions related to [Azure Mobile](https://azure.microsoft.com/de-de/services/app-service/mobile/) which can be invoked using Jason.

### Tables

Query and insert records from Azure Mobile Tables

### Push

Register device token with Azure APNS

## Usage

To use this plug-in in [Jasonette](http://jasonette.com), you need to add this pod and recompile:

```shell
$ cd Jasonette-iOS
$ cd app
$ pod install JasonetteAzureMobilePlugin
```

### Configuration

You need to add a `azure` dictionary to your `settings.plist`.  This dictionary must contain a key `app_url` which
must point to your Azure Mobile App, e.g. somethinbg like `https://mycoolapp.azurewebsites.net`.

Once you did that, you can invoke the plug-in using something like this:

```json
 "$jason": {
    "head": {
      "title": "Jasonette Azure Mobile Demo",
      "actions": {
        "$foreground": {
          "type": "$reload"
        },
        "$load": {
          "type": "$notification.register"
        },
        "$notification.registered": {
          "type": "@AzurePush.registerDeviceToken",
          "options": {
            "device_token": "{{$jason.device_token}}"
          }
        },
        "$notification.remote": {
          "type": "$util.banner",
          "options": {
            "title": "Message",
            "description": "{{JSON.stringify($jason)}}"
          }
        },
        "$pull": {
          "type": "@AzureTables.query",
          "options": {
            "table": "articles",
            "query": "deleted == NO"
          }
        }
      },
      "templates": {
        "body": {
          "header": {
            "title": "Jasonette Azure Mobile Demo",
            "type": "$reload",
            "success": {
              "type": "$util.toast",
              "options": {
                "text": "reload"
              }
            }
          },
          "sections": [
            {
              "items": {
                "{{#each $get.items}}": {
                  "type": "label",
                  "text": "{{title}}",
                  "style": {
                    "color": "#000000",
                    "size": "14",
                    "font": "HelveticaNeue-Bold",
                    "padding": "10",
                    "width": "300",
                    "height": "100"
                  }
                }
              }
            }
          ]
        }
      }
    },
    "body": {
      "header": {
        "title": "Jasonette Azure Mobile Demo"
      },
      "sections": {
        "items": [
          {
            "type": "label",
            "text": "???"
          }
        ]
      }
    }
  }
}
```

## Installation

JasonetteAzureMobilePlugin is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JasonetteAzureMobilePlugin"
```

## Author

Stefan Eletzhofer, se@nexiles.de

## License

JasonetteAzureMobilePlugin is available under the MIT license. See the LICENSE file for more info.
