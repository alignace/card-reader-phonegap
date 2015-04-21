package com.alignace.cordova.plugin.card.reader;

public class CardResult {

	String cardNumber;
	int expiryMonth, expiryYear;

	public String getCardNumber() {
		return cardNumber;
	}

	public void setCardNumber(String cardNumber) {
		this.cardNumber = cardNumber;
	}

	public int getExpiryMonth() {
		return expiryMonth;
	}

	public void setExpiryMonth(int expiryMonth) {
		this.expiryMonth = expiryMonth;
	}

	public int getExpiryYear() {
		return expiryYear;
	}

	public void setExpiryYear(int expiryYear) {
		this.expiryYear = expiryYear;
	}

	public String toString() {
		return "Card Number=" + this.cardNumber + " \nExpiry Month="
				+ this.expiryMonth + " \nExpiry year=" + this.expiryYear;
	}

}
