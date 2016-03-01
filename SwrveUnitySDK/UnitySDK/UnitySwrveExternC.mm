#import "UnitySwrveHelper.h"
#import "UnitySwrveCommon.h"
#import "UnitySwrveCommonMessageController.h"
#import "SwrvePlotDelegate.h"

extern "C"
{
    char* _swrveiOSGetLanguage()
    {
        return [UnitySwrveHelper GetLanguage];
    }
    
    char* _swrveiOSGetTimeZone()
    {
        return [UnitySwrveHelper GetTimeZone];
    }
    
    char* _swrveiOSGetAppVersion()
    {
        return [UnitySwrveHelper GetAppVersion];
    }
    
    char* _swrveiOSUUID()
    {
        return [UnitySwrveHelper GetUUID];
    }
    
    char* _swrveiOSCarrierName()
    {
        return [UnitySwrveHelper GetCarrierName];
    }
    
    char* _swrveiOSCarrierIsoCountryCode()
    {
        return [UnitySwrveHelper GetCarrierIsoCountryCode];
    }
    
    char* _swrveiOSCarrierCode()
    {
        return [UnitySwrveHelper GetCarrierCode];
    }
    
    char* _swrveiOSLocaleCountry()
    {
        return [UnitySwrveHelper GetLocaleCountry];
    }
    
    char* _swrveiOSIDFV()
    {
        return [UnitySwrveHelper GetIDFV];
    }
    
    void _swrveiOSRegisterForPushNotifications(char* jsonCategorySet)
    {
        return [UnitySwrveHelper RegisterForPushNotifications:[UnitySwrveHelper CStringToNSString:jsonCategorySet]];
    }
    
    void _swrveiOSInitNative(char* jsonConfig)
    {
        [UnitySwrveCommon init:jsonConfig];
    }
    
    const char* _swrveiOSGetConversationResult()
    {
        return [UnitySwrveHelper NSStringCopy:@"[]"];
    }
    
    void _swrveiOSShowConversation(char* conversation)
    {
        [[UnitySwrveCommonMessageController alloc] showConversationFromString:[UnitySwrveHelper CStringToNSString:conversation]];
    }
    
    void _swrveiOSStartPlot()
    {
        [[SwrvePlotDelegate sharedInstance] startPlot];
    }
}