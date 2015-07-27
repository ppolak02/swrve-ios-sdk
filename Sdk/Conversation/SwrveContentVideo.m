#import "SwrveContentVideo.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "SwrveSetup.h"
#import "SwrveConversationEvents.h"

#import "UIWebView+YouTubeVimeo.h"

@interface SwrveContentVideo () {
    NSString *_height;
    UIWebView *webview;
    BOOL preventNagiation;
}

@end

@implementation SwrveContentVideo

@synthesize height = _height;
@synthesize interactedWith = _interactedWith;

-(id) initWithTag:(NSString *)tag andDictionary:(NSDictionary *)dict {
    self = [super initWithTag:tag type:kSwrveContentTypeVideo andDictionary:dict];
    _height = [dict objectForKey:@"height"];
    return self;
}

-(BOOL) willRequireLandscape {
    return YES;
}

-(void) stop {
    if (webview.isLoading) {
        [webview stopLoading];
    }
    [webview setDelegate:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
#pragma unused(animated)
    // Stop the running video - this will happen on a page change.
    [webview loadHTMLString:@"about:blank" baseURL:nil];
}

-(void) loadViewWithContainerView:(UIView*)containerView {
    // Enable audio
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // Create _view
    CGFloat vid_height = (_height) ? [_height floatValue] : 180.0;
    CGFloat vid_width = containerView.frame.size.width;
    _view = webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, vid_width, vid_height)];
    [self sizeTheWebView];
    webview.backgroundColor = [UIColor clearColor];
    webview.opaque = NO;
    webview.delegate = self;
    webview.userInteractionEnabled = YES;
    [SwrveContentItem scrollView:webview].scrollEnabled = NO;
    
    NSString *rawValue = self.value;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        // If it is iOS9 we need to force this endpoint to use HTTPs
        rawValue = [rawValue stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    }
    [webview loadYouTubeOrVimeoVideo:@"https://www.youtube.com/embed/LdTm7Vpape0?html5=1&iv_load_policy=3&modestbranding=1&showinfo=0&rel=0"];
    
    UITapGestureRecognizer *gesRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]; // Declare the Gesture.
    gesRecognizer.delegate = self;
    [gesRecognizer setNumberOfTapsRequired:1];
    [webview addGestureRecognizer:gesRecognizer];
    // Notify that the view is ready to be displayed
    [[NSNotificationCenter defaultCenter] postNotificationName:kSwrveNotificationViewReady object:nil];
    // Get notified if the view should change dimensions
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:kSwrveNotifyOrientationChange object:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
#pragma unused(gestureRecognizer, otherGestureRecognizer)
    return YES;
}

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer {
#pragma unused(gestureRecognizer)
    _interactedWith = YES;
}

-(void) sizeTheWebView {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Make the webview full width on iPad
        webview.frame = CGRectMake(0.0, 0.0, _view.frame.size.width, webview.frame.size.height/webview.frame.size.width*_view.frame.size.width);
    } else {
        // Cope with phone rotation
        // Too big or same size?
        if (webview.frame.size.width > 0 && webview.frame.size.width >= _view.frame.size.width) {
            webview.frame = CGRectMake(0.0, 0.0, _view.frame.size.width, webview.frame.size.height/webview.frame.size.width*_view.frame.size.width);
        }
        // Too small?
        if(webview.frame.size.width < _view.frame.size.width) {
            webview.frame = CGRectMake((_view.frame.size.width-webview.frame.size.width)/2, webview.frame.origin.y, webview.frame.size.width, webview.frame.size.height);
        }
    }
    // Adjust the containing view around this too
    _view.frame = CGRectMake(_view.frame.origin.x, _view.frame.origin.y, _view.frame.size.width, webview.frame.size.height);
}

// Respond to device orientation changes by resizing the width of the view
// Subviews of this should be flexible using AutoResizing masks
-(void) deviceOrientationDidChange {
    _view.frame = [self newFrameForOrientationChange];
    [self sizeTheWebView];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
#pragma unused(webView, request, navigationType)
    return !preventNagiation;
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
#pragma unused(webView)
    preventNagiation = YES;
}

// iOS8+
-(void)viewWillTransitionToSize:(CGSize)size
{
    // Mantain full width
    _view.frame = CGRectMake(0, 0, size.width, _view.frame.size.height);
}

- (void)dealloc {
    if (webview.delegate == self) {
        webview.delegate = nil; // Unassign self from being the delegate, in case we get deallocated before the webview!
    }
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kSwrveNotifyOrientationChange object:nil];
}

@end
