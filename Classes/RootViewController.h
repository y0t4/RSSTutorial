//
//  RootViewController.h
//  SimpleRSSReader
//
//  Created by e095708 on 11/08/28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController <NSXMLParserDelegate> {
	//テーブルに配置するデータを配列で定義
	NSMutableArray *dataArray;
	// URLをセットするボタンと入力ボックスを定義
	UIBarButtonItem *setButton;
	UITextField *urlTextField;
	
	// title要素を格納する配列
	NSMutableArray *titleArray;
	// item要素のチェック
	BOOL itemElementCheck;
	// title要素のチェック
	BOOL titleElementCheck;
	// title要素のテキスト
	NSString *titleText;
	
	//link要素を格納する配列
	NSMutableArray *linkArray;
	//link要素のチェック
	BOOL linkElementCheck;
	//link要素のテキスト
	NSString *linkText;
}

// 変数setButton, urlTextFieldのプロパティを設定
@property(nonatomic,retain) IBOutlet UIBarButtonItem *setButton;
@property(nonatomic,retain) IBOutlet UITextField *urlTextField;

// URLを設置せっとするメソッドを宣言
-(IBAction) setURL;

// データを読み込むメソッドを宣言
-(NSArray *)loadData:(NSString *) urlString;
// キーボードを閉じるメソッドを宣言
-(IBAction) closeKeyboard;

// XMLを読み込み解析するメソッドを宣言
-(NSMutableArray *)loadXML:(NSString *) urlString;

@end
