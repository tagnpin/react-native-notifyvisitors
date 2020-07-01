'use strict';

import { NativeModules, NativeEventEmitter, Platform } from 'react-native';
const { RNNotifyvisitors } = NativeModules;
const eventEmitter = new NativeEventEmitter(RNNotifyvisitors);

const callbacks = {};

var lock = true;

const addListener = function(){
    eventEmitter.addListener('event_push_click', (data)=>{
        try{
            if(typeof data == "string"){
                data = JSON.parse(data);
            }
            if(data._callbackName && callbacks.hasOwnProperty(data._callbackName) && typeof callbacks[data._callbackName] == "function"){
                const callbackFunction = callbacks[data._callbackName];
                //delete callbacks[data._callbackName];
                if(data.data != ""){
                    if(lock){
                        callbackFunction((data.data||""));
						lock =false;
                        setTimeout(function(){ 
							lock =true;
                        }, 1000);
                    }
                    
                } 
            }
        }
        catch(e){
            console.log("exception ="+e);
        }
    });
}


addListener();

export default class Notifyvisitors{

	static show(tokens, customObjects, fragmentName){
			try{
				RNNotifyvisitors.show(tokens, customObjects, fragmentName);
			}catch(e){}
	}

	static showNotifications(dismissValue){
		try{
			if(Platform.OS == "ios"){
				dismissValue = dismissValue+"";
			}else{
				dismissValue = parseInt(dismissValue);
			}
			RNNotifyvisitors.showNotifications(dismissValue);
		}catch(e){}
		
	}
	
	static event(eventName, attributes, ltv, scope){
		try{
			RNNotifyvisitors.event(eventName, attributes, ltv, scope);
		}catch(e){}
		
	}
	
	static stopNotifications(){
		try{
			RNNotifyvisitors.stopNotifications();
		}catch(e){}
		
	}

	static stopPushNotifications(bValue){
		try{
			RNNotifyvisitors.stopPushNotifications(bValue);
		}catch(e){}
		
	}
	
	static getNotificationDataListener(callback){
		try{
			if(Platform == "ios"){
			RNNotifyvisitors.getNotificationDataListener("fetchEvent");
			}
			RNNotifyvisitors.getNotificationDataListener(callback);
		}catch(e){}
		 
	} 

    static getNotificationCount(callback){
		try{
			RNNotifyvisitors.getNotificationCount(callback);
		}catch(e){}
		
	}

	static scheduleNotification(nid, tag, time, title, message, url, icon){
		try{
			RNNotifyvisitors.scheduleNotification(nid, tag, time, title, message, url, icon);
		}catch(e){}
		
	}

	static userIdentifier(userID, sJsonObject){
		try{
			RNNotifyvisitors.userIdentifier(userID, sJsonObject);
		}catch(e){}
		
	}

    static stopGeofencePushforDateTime(dateTime, additionalHours){
		try{
			RNNotifyvisitors.stopGeofencePushforDateTime(dateTime, additionalHours);
		}catch(e){}
		
	}

	static getClickInfoCP(callback){
		try{
			if(Platform.OS == "ios"){
				const randomId = Math.round(Math.random()*1000),
			    eventName = "event_push_click-"+randomId;
				callbacks[eventName] = callback;
				RNNotifyvisitors.getClickInfoCP(eventName);
			}else{
                RNNotifyvisitors.getClickInfoCP(callback);
			}
		}catch(e){}

	}

	static scrollViewDidScroll_iOS_only(){
		try{
			RNNotifyvisitors.scrollViewDidScroll_iOS_only();
		}catch(e){}
	}

	static promptForPushNotificationsWithUserResponse(callback) {
        if (!checkIfInitialized()) return;

        if (Platform.OS === 'ios') {
            RNNotifyvisitors.promptForPushNotificationsWithUserResponse(callback);
        } else {
            console.log("This function is not supported on Android");
        }
	}

	static setAutoStartPermission_android_only(){
		try{
			if (Platform.OS === 'ios') {
				console.log("This function is not supported on IOS");
			} else {
				RNNotifyvisitors.setAutoStartPermission();
			}
		}catch(e){}
	}

}