//
//  testMessageUIViewController.h
//  testMessageUI
//
//  Created by 藤川 宏之 on 09/04/10.
//  Copyright Hiroyuki-Fujikawa. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <GameKit/GameKit.h>

//@interface testMessageUIViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate, GKPeerPickerControllerDelegate, GKSessionDelegate> {
@interface testMessageUIViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate, GKPeerPickerControllerDelegate, GKSessionDelegate> {
	IBOutlet UIImageView *imageView;
	IBOutlet UILabel *peerLabel;
	UIImage	*cameraImage;
	GKPeerPickerController	*gkController;
	GKSession	*gksession;
	NSString	*connectPeer;
}

@property (nonatomic, retain) UIImage *cameraImage;
@property (nonatomic, retain) GKPeerPickerController *gkController;
@property (nonatomic, retain) GKSession *gksession;
@property (nonatomic, retain) NSString *connectPeer;

- (IBAction) cameraAction;
- (IBAction) mailAction;
- (IBAction) gkAction;
- (IBAction) sendAction;

@end

