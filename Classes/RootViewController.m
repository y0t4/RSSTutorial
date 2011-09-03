//
//  RootViewController.m
//  SimpleRSSReader
//
//  Created by e095708 on 11/08/28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController
@synthesize setButton;
@synthesize urlTextField;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	// データの初期値をセット
	//dataArray = [[NSMutableArray arrayWithObjects:@"子",@"丑",@"寅",@"卯",nil] retain];

	// データの初期値をセット
	dataArray = [[NSMutableArray array] retain];
	
	//記事のURLを格納する配列の初期値をセット
	linkArray = [[NSMutableArray array] retain];
}

// URLをセットする
-(void)setURL{
	// 入力ボックスに入力された値を配列に追加
	// [dataArray addObject:urlTextField.text];
	
	//読み込んだデータを配列にセット
	//[dataArray setArray:[self loadData:urlTextField.text]];
	[dataArray setArray:[self loadXML:urlTextField.text]];
	
	// テーブルを最読み込み
	[self.tableView reloadData];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //データ数
	return [dataArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];

    return cell;
}

// データを読み込む
-(NSArray *)loadData:(NSString *)urlString{
	// URLを作成
	NSURL *url = [NSURL URLWithString:urlString];
	// URLからリクエストを作成
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	// リクエストからデータを取得
	NSData *data = [NSURLConnection
					sendSynchronousRequest:request returningResponse:NULL error:NULL];
	// データをutf8文字列に変換
	NSString *stringData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
	
	// 改行で分けて配列に格納
	NSArray *stringDataArray = [stringData componentsSeparatedByString:@"\n"];
	// 配列を返す
	return stringDataArray;
}

// XMLを読み込み解析する
-(NSMutableArray *) loadXML:(NSString *)urlString{
	//変数の初期化
	titleArray = [NSMutableArray array];
	itemElementCheck = NO;
	titleElementCheck = NO;
	titleText = @"";
	linkElementCheck = NO;
	linkText = @"";

	//記事のURLを格納する配列をクリア
	[linkArray removeAllObjects];
	
	//URLを作成
	NSURL *url = [NSURL URLWithString:urlString];
	//URLからパーサーを作成
	NSXMLParser* parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	
	//デリゲートをセット
	[parser setDelegate:self];
	//XMLを解析
	[parser parse];
	//パーサーを解放
	[parser release];
	
	//配列を返す
	return titleArray;
}

//開始タグの処理
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict{
	
	//item要素のチェック
	if ([elementName isEqualToString:@"item"]) {
		itemElementCheck = YES;
	}
	
	//title要素のチェック
	if (itemElementCheck && [elementName isEqualToString:@"title"]) {
		titleElementCheck = YES;
	}else {
		titleElementCheck = NO;
	}
	
	//link要素のチェック
	if (itemElementCheck && [elementName isEqualToString:@"link"]) {
		linkElementCheck = YES;
	}else {
		linkElementCheck = NO;
	}

}

//終了タグの処理
- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName{
	
	//item要素のチェック
	if ([elementName isEqualToString:@"item"]) {
		itemElementCheck = NO;
	}
	
	//title要素のチェック
	if ([elementName isEqualToString:@"title"]) {
		if (titleElementCheck) {
			//配列titleArrayに追加
			[titleArray addObject:titleText];
		}
		//titleElementCheckをNO,titleTextを空にセット
		titleElementCheck = NO;
		titleText = @"";
	}
	
	//link要素のチェック
	if ([elementName isEqualToString:@"link"]) {
		if (linkElementCheck) {
			//配列linkArrayに追加
			[linkArray addObject:linkText];
		}
		//linkElementCheckをNO,linkTextを空にセット
		linkElementCheck = NO;
		linkText = @"";
	}
}

//テキストの取り出し
- (void)parser:(NSXMLParser *)parser 
foundCharacters:(NSString *)string{
	//titleテキストの取り出し
	if (titleElementCheck) {
		titleText = [titleText stringByAppendingString:string];
	}
	
	//linkテキストの取り出し
	if (linkElementCheck) {
		linkText = [linkText stringByAppendingString:string];
	}
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	
	//ブラウザでURLを開く
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[linkArray objectAtIndex:indexPath.row]]];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

// キーボードを閉じる
-(void)closeKeyboard{
	[urlTextField resignFirstResponder];
}

- (void)dealloc {
	[dataArray release];
	[setButton release];
	[urlTextField release];
	[linkArray release];
    [super dealloc];
}


@end

