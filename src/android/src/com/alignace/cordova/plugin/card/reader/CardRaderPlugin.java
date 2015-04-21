package com.alignace.cordova.plugin.card.reader;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.square.CardResult;
import com.square.MagRead;
import com.square.MagReadListener;

import android.content.Intent;
import android.os.Message;
import android.util.Log;

public class CardRaderPlugin extends CordovaPlugin {

	public static final String TAG = "CardRaderPlugin";
	public static final String START = "start";
	public static final String STOP = "stop";

	CallbackContext callbackContext;
	private MagRead read = null;

	public static JSONArray mCreditcardNumber = null;

	@Override
	public boolean execute(String action, JSONArray data,
			CallbackContext callbackContext) {
		boolean result = true;
		this.callbackContext = callbackContext;

		Log.v(TAG, "execute: action=" + action);

		if (START.equals(action)) {
			Log.v(TAG, "Start listening");
			read = new MagRead();
			read.addListener(new MagReadListener() {

				@Override
				public void updateBytes(String bytes) {
					try {
						CardResult scanResult = getCardDetails(bytes);
						JSONObject j = new JSONObject();
						j.put("card_number", scanResult.getCardNumber());
						j.put("expiry_month", scanResult.getExpiryMonth());
						j.put("expiry_year", scanResult.getExpiryYear());
						mCreditcardNumber.put(j);
						callbackContext.success(mCreditcardNumber);
					} catch (Exception e) {
						Log.e(TAG, "Error reading Card: " + (e.getMessage());
						callbackContext.error(e.getMessage());
					}
				}
			});
			read.start();
		}else if (STOP.equals(action)) {
			if (read != null){
				read.stop();
			}
			
			callbackContext.succes();
		}else{
			result = false;
		}

		return result;

	}

	private CardResult getCardDetails(String bytes) {
		CardResult result = new CardResult();
		try {
			StringBuffer cardNumber = new StringBuffer();
			int i = 0;

			// Find Card Number
			for (i = 1; i < bytes.length(); i++) {
				if (bytes.charAt(i) != '=') {
					cardNumber.append(bytes.charAt(i));
				} else {
					i++;
					break;
				}
			}

			// Find expiry Year
			StringBuffer expiryYear = new StringBuffer();
			expiryYear.append(bytes.charAt(i));
			expiryYear.append(bytes.charAt(++i));

			// Find expiry Month
			StringBuffer expiryMonth = new StringBuffer();
			expiryMonth.append(bytes.charAt(++i));
			expiryMonth.append(bytes.charAt(++i));

			result.setCardNumber(cardNumber.toString());
			result.setExpiryMonth(Integer.parseInt(expiryMonth.toString()));
			result.setExpiryYear(Integer.parseInt(expiryYear.toString()));
		} catch (Exception e) {
			throw new RuntimeException("Please try again!");
		}

		return result;

	}

}
