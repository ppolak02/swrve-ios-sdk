#import "SwrveCampaignStatus.h"
@class SwrveMessageController;

/*! Base campaign state. */
@interface SwrveCampaignState : NSObject

@property (atomic)            NSUInteger campaignID;                /*!< Unique identifier. */
@property (atomic)            NSUInteger impressions;               /*!< Amount of times this campaign has been shown for a user. */
@property (atomic)            NSUInteger next;                      /*!< Next message to be shown if set-up as round robin. */
@property (nonatomic)         SwrveCampaignStatus status;           /*!< The status of the Inbox campaign. */

/*! Initialize a fresh campaign status. */
-(id)initWithID:(NSUInteger)ID;

/*! Initialize the campaign status. */
-(id)initWithJSON:(NSDictionary*)data;

/*! Serialized state */
-(NSDictionary*)asDictionary;

@end

/*! Base campaign. */
@interface SwrveBaseCampaign : NSObject

@property (atomic)            NSUInteger ID;                        /*!< Unique identifier. */
@property (nonatomic, retain) NSString* name;                       /*!< Name of the campaign. */
@property (atomic)            NSUInteger maxImpressions;            /*!< Maximum number of impressions per user. */
@property (atomic, retain)    SwrveCampaignState* state;            /*!< Saveable state of the campaing. */
@property (atomic)            NSTimeInterval minDelayBetweenMsgs;   /*!< Minimum interval between different campaigns being shown. */
@property (nonatomic, retain) NSDate* showMsgsAfterLaunch;          /*!< Timestamp to block messages after launch. */
@property (nonatomic, retain) NSDate* showMsgsAfterDelay;           /*!< Timestamp to block messages from appearing too frequently . */
@property (atomic)            bool inbox;                           /*!< Flag indicating if it is an Inbox campaign. */
@property (nonatomic, retain) NSString* subject;                    /*!< Inbox subject of the campaign. */

/*! Initialize the campaign.
 *
 * \param time Used to initialize time-based rules.
 * \data json blob containing the campaign data.
 * \returns Initialized campaign.
 */
-(id)initAtTime:(NSDate*)time fromJSON:(NSDictionary*)data withAssetsQueue:(NSMutableSet*)assetsQueue forController:(SwrveMessageController*)controller;

/*! Check if the campaign supports the given orientation.
 *
 * \returns true if the campaign supports the given orientation.
 */
-(BOOL)supportsOrientation:(UIInterfaceOrientation)orientation;

/*! PRIVATE: Return the serialized state of the campaign */
-(NSDictionary*)stateDictionary;

@end
