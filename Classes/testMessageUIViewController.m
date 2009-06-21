//
//  testMessageUIViewController.m
//  testMessageUI
//
//  Created by 藤川 宏之 on 09/04/10.
//  Copyright Hiroyuki-Fujikawa. 2009. All rights reserved.
//

#import "testMessageUIViewController.h"

@implementation testMessageUIViewController
@synthesize cameraImage;
@synthesize gkController;
@synthesize gksession;
@synthesize connectPeer;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	NSLog(@"willShowViewController");
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	NSLog(@"didShowViewController");
}


# pragma mark UIImagePickerControllerDelegate
// for UIImagePicker
- (IBAction) cameraAction {
	NSLog(@"cameraAction");
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	[imagePicker autorelease];
	NSLog(@"sourcetype available:%d", [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]);
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
		imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		imagePicker.allowsImageEditing = NO;
		imagePicker.delegate = self;
		[self presentModalViewController:imagePicker animated:YES];
	}else	{
		NSLog(@"can't present source type");
	}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	NSLog(@"imagePickerControllerDidCancel");
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	NSLog(@"info:%@", info);
	[picker dismissModalViewControllerAnimated:YES];
	self.cameraImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	imageView.image = self.cameraImage;
}

#pragma mark MFMailComposeViewControllerDelegate
// for MFMailComposeView
- (IBAction) mailAction {
	NSLog(@"mailAction");
	if([MFMailComposeViewController canSendMail]){
		MFMailComposeViewController *mfcontroller = [[MFMailComposeViewController alloc] init];
		mfcontroller.mailComposeDelegate = self;
		NSLog(@"delegate:%@", mfcontroller.delegate);
		NSLog(@"MFMailComposeViewController:%d", [MFMailComposeViewController canSendMail]);
		[mfcontroller setSubject: @"test"];
		[mfcontroller setToRecipients:[NSArray arrayWithObjects:@"cqa02303@mac.com", nil]];
		[mfcontroller setMessageBody:@"test mail body" isHTML:NO];
		if(self.cameraImage){
			[mfcontroller addAttachmentData:UIImageJPEGRepresentation(self.cameraImage, 0.9f) mimeType:@"image/jpeg" fileName:@"image.jpg"];
		}
		// [controller addAttachmentData:<#(NSData *)attachment#> mimeType:<#(NSString *)mimeType#> fileName:<#(NSString *)filename#>];
		[self presentModalViewController:mfcontroller animated:YES];
	}
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	NSLog(@"-mailComposeController:didFinishWithResult:%d [%@]", result, error);
	[controller dismissModalViewControllerAnimated:YES];
}


#pragma mark GKPeerPickerControllerDelegate
- (IBAction) gkAction {
	NSLog(@"GKAction");
	GKPeerPickerController *controller = [[GKPeerPickerController alloc] init];
	self.gkController = controller;
	controller.delegate = self;
	// 3G回線は使えないよ
	// GKPeerPickerConnectionTypeOnline : WiFi
	// GKPeerPickerConnectionTypeNearby : BT接続
	controller.connectionTypesMask = GKPeerPickerConnectionTypeOnline | GKPeerPickerConnectionTypeNearby;
	controller.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
	[controller show];
	[controller release];
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectToPeer:(NSString *)peerID {
	NSLog(@"-didConnectToPeer:%@", peerID);
	NSLog(@"-------------------------------------------------------------");
	[self.gkController dismiss];
	self.gkController = nil;
}

- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type {
	NSLog(@"-didSelectConnectionType:%d", type);
	NSLog(@"-------------------------------------------------------------");
}	

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
	NSLog(@"-sessionForConnectionType:%d", type);
	NSLog(@"-------------------------------------------------------------");
	if(!self.gksession){
		self.gksession = [[GKSession alloc] initWithSessionID:@"jp.cooan.movie.ero.testMessageUI" displayName:@"testMessageUI" sessionMode:GKSessionModePeer];
        gksession.delegate = self;
        [gksession setDataReceiveHandler:self withContext:NULL];	// ※１が必要
	}
	return gksession;
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker {
	NSLog(@"-peerPickerControllerDidCancel:%@", picker);
	NSLog(@"-------------------------------------------------------------");
	[self.gkController dismiss];
	self.gkController = nil;
}

// ※１
// データ受け取る
- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
	NSLog(@"-receiveData:%@ fromPeer:%@", data, peer);
	NSLog(@"-------------------------------------------------------------");
}

#pragma mark GKSessionDelegate
- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
	NSLog(@"-connectionWithPeerFailed:%@ withError:%@", peerID, error);
	NSLog(@"-------------------------------------------------------------");
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
	NSLog(@"-didFailWithError:%@", error);
	NSLog(@"-------------------------------------------------------------");
}

// 接続要求を受け入れました
- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
	NSLog(@"-didReceiveConnectionRequestFromPeer:%@", peerID);
	NSLog(@"-------------------------------------------------------------");
	if(self.gkController.visible == YES){
		return;
	}
	NSError *error = nil;
	// 接続要求を受け入れる
	[session acceptConnectionFromPeer:peerID error:&error];
	NSLog(@"->acceptConnectionFromPeer:%@ error:%@", peerID, error);
}

// 相手の状態が変わった。
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
	NSLog(@"-peer:%@ didChangeState:%d", peerID, state);
	NSLog(@"-------------------------------------------------------------");
	switch (state) {
		case GKPeerStateAvailable: break;
		case GKPeerStateUnavailable: break;
		case GKPeerStateConnected:		// 接続完了！
			self.connectPeer = peerID;
			peerLabel.text = peerID;
			[self.gkController dismiss];
			self.gkController = nil;
			break;
		case GKPeerStateDisconnected:	// 切断された！
			break;
		case GKPeerStateConnecting:		// 接続中(接続され中？)
			break;
		default:
			break;
	}
}

#pragma mark <#label#>
- (IBAction) sendAction {
	NSLog(@"-sendAction");
	if(self.gksession.available == YES){
		NSError *error = nil;
		NSString *str = @"test data";
		BOOL ret;
		ret = [self.gksession sendDataToAllPeers:[str dataUsingEncoding:NSUTF8StringEncoding]   withDataMode:GKSendDataUnreliable error:&error];
		NSLog(@"send data ret = %d, %@", ret, error);
		if(self.cameraImage){
			NSArray *peers = [NSArray arrayWithObject:self.connectPeer];
			NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(self.cameraImage, 0.9f)];
			// ret = [self.gksession sendData:data toPeers:peers withDataMode:GKSendDataReliable error:&error];
			ret = [self.gksession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&error];
			NSLog(@"send data ret = %d, %@", ret, error);
		}
	}
}

@end
