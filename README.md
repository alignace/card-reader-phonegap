# card-reader-phonegap
Cordova plugin for 3.5mm Headphone Jack Mini Magnetic Mobile Card Reader


# Getting started

  Install the Plugin and use the following method "cardReaderStart" to start the card reader:

```javascript
  function cardReaderStart(cardReadSuccess, cardReadFailure){
        console.log("Card reader started!");
        window.plugins.CardRaderPlugin.start(cardReadSuccess, cardReadFailure);
    }
  
  // If OS is Android  
  function cardReadSuccess(response){
		    console.log("Card number:" + response[0].card_number);
		    
		    if(typeof response[0].expiry_month != 'undefined' && response[0].expiry_month!=null){
		        console.log("Expiry month:" + response[0].expiry_month);
		    }

		    if(typeof response[0].expiry_year != 'undefined' && response[0].expiry_year!=null){
		         console.log("Expiry month:" + response[0].expiry_year);
		    }
	}
	
	//If OS is iOS
	function cardReadSuccess(response){
	      console.log("Card number:" + response['card_number']);
		    
		    if(typeof response[0].expiry_month != 'undefined' && response[0].expiry_month!=null){
		        console.log("Expiry month:" + response['expiry_month']);
		    }

		    if(typeof response[0].expiry_year != 'undefined' && response[0].expiry_year!=null){
		         console.log("Expiry month:" + response['expiry_year']);
		    }
	}
	
	function cardReadFailure(){
		    console.log('Please try again!');
	}
	
```
	
	To stop the card reading use following code:

```javascript
  function cardReaderStop(){
      console.log("Trying to stop CardReader!");
      window.plugins.CardRaderPlugin.stop(function(){
            console.log("Card reader stopped!");
      }, function(){
            console.log("Card reader stop failed!");
      });
  }
  
```
