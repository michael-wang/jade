package com.studioirregular.jadeninja.p1;

import android.os.Bundle;
import android.view.Menu;

import com.studioirregular.gaoframework.AbsGameActivity;
import com.studioirregular.gaoframework.GameProducts;

/*
 * Notice: do not use activity request code between: 
 * [Global.FRAMEWORK_ACTIVITY_CODE_START, Global.FRAMEWORK_ACTIVITY_CODE_END].
 */
public class MainActivity extends AbsGameActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
	
	@Override
	protected GameProducts getGameProducts() {
		return new JadeNinjaGameProducts();
	}
	
	@Override
	protected String getPublicKey() {
		return "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA9qbeUprhArKLspjUQ8ySihxTiZAUWFJGQuYXdbLtx7nBevT9TlMiNXvFUiHkYPboHROYackS8NTqt/tbkOruc27v8rnT5n8+hidqjGQt+HKQqgL2mQnfR8oSZ4gHYE2H6QNYMi/F2vKvNSEJtO+tXpIcPfEmkiUpOS1YleabSDZNDPbIJ0/uXMKPrWcMeJ3yQu2wsMEldXsy1LoFgzBeP0PRqSc/d8XoYwX/TxUTk1Xe39QUIJv9+DmMNsDecISq17p+oQszmWma9qUgceCCG/0vHUFKxPiirU/lVcMJniXEEr+bAnm6rmX3gPws59pAfwo25jOSYNnsvM5FXyPRjQIDAQAB";
	}
}
