
package com.notifyvisitors.notifyvisitors;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import android.widget.Toast;
import org.json.JSONArray;
import android.util.Log;
import org.json.JSONException;
import org.json.JSONObject;
import com.notifyvisitors.notifyvisitors.NotifyVisitorsApplication;
import android.content.Context;
import android.app.Application;
import com.notifyvisitors.notifyvisitors.NotifyVisitorsApi;
import com.notifyvisitors.notifyvisitors.interfaces.NotificationCountInterface;
import com.notifyvisitors.notifyvisitors.interfaces.NotificationListDetailsCallback;
import android.app.Activity;

public class RNNotifyvisitorsModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;
  private static final String TAG = "NotifyVisitors";

  public RNNotifyvisitorsModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNNotifyvisitors";
  }

  @ReactMethod
  public static void register(Context context) {
    try {
      Log.e(TAG, "register method was called");
      NotifyVisitorsApplication.register((Application) context.getApplicationContext());
    } catch (Exception e) {
      Log.e(TAG, "register error = " + e);
      // e.printStackTrace();
    }
  }

  @ReactMethod
  public void showNotifications(int dismissValue) {
    try {
      Log.e(TAG, "showNotifications method was called");
      NotifyVisitorsApi.getInstance(reactContext).showNotifications(dismissValue);
    } catch (Exception e) {
      Log.e(TAG, "showNotifications method error = " + e);
      // e.printStackTrace();
    }
  }

  @ReactMethod
  public void stopNotifications() {
    try {
      Log.e(TAG, "stopNotifications method was called");
      NotifyVisitorsApi.getInstance(reactContext).stopNotification();
    } catch (Exception e) {
      Log.e(TAG, "stopNotifications method error = " + e);
      // e.printStackTrace();
    }
  }

  @ReactMethod
  public void stopPushNotifications(String str) {
    try {
      boolean bValue;
      Log.e(TAG, "stopPushNotifications method was called");

      if (str != null && str != "") {
        if (str.equalsIgnoreCase("true")) {
          bValue = true;
        } else {
          bValue = false;
        }
        Log.e(TAG, "Final Boolean Value = " + bValue);
        NotifyVisitorsApi.getInstance(reactContext).stopPushNotification(bValue);

      } else {
        Log.e(TAG, "Parameter can not be null or empty");
      }

    } catch (Exception e) {
      Log.e(TAG, "stopPushNotifications method error = " + e);
      // e.printStackTrace();
    }
  }

  @ReactMethod
  public void show(String tokens, String customObjects, String fragmentName) {
    try {
      Log.e(TAG, "show method was called");
      JSONObject jTokens;
      JSONObject jcustomObjects;
      if (tokens != null) {
        jTokens = new JSONObject(tokens);
      } else {
        jTokens = null;
      }

      if (customObjects != null) {
        jcustomObjects = new JSONObject(customObjects);
      } else {
        jcustomObjects = null;
      }

      // Activity activity = (Activity) reactContext;
      // final Activity activity = reactContext.getCurrentActivity();
      Activity activity = reactContext.getCurrentActivity();
      NotifyVisitorsApi.getInstance(activity).show(jTokens, jcustomObjects, fragmentName);
    } catch (Exception e) {
      Log.e(TAG, "show method error = " + e);
      // e.printStackTrace();
    }
  }

  @ReactMethod
  public void event(String eventName, String attributes, String ltv, String scope) {
    try {
      Log.e(TAG, "event method was called");
      JSONObject jAttributes;
      if (attributes != null) {
        jAttributes = new JSONObject(attributes);
      } else {
        jAttributes = null;
      }
      NotifyVisitorsApi.getInstance(reactContext).event(eventName, jAttributes, ltv, scope);
    } catch (Exception e) {
      Log.e(TAG, "event error = " + e);
      // e.printStackTrace();
    }
  }

  @ReactMethod
  public void getNotificationDataListener(final Callback callback) {
    try {
      Log.e(TAG, "getNotificationDataListener method was called");
      NotifyVisitorsApi.getInstance(reactContext).getNotificationDataListener(new NotificationListDetailsCallback() {
        @Override
        public void getNotificationData(JSONArray notificationListResponse) {
          Log.e("NV", "Response = " + notificationListResponse);
          callback.invoke(notificationListResponse.toString());
        }
      }, 0);

    } catch (Exception e) {
      Log.e(TAG, "getNotificationDataListener method error = " + e);
      // e.printStackTrace();
    }
  }

  @ReactMethod
  public void getNotificationCount(final Callback callback) {
    try {
      Log.e(TAG, "getNotificationCount method was called");
      NotifyVisitorsApi.getInstance(reactContext).getNotificationCount(new NotificationCountInterface() {
        @Override
        public void getCount(int count) {
          Log.e("NV", "COUNT = " + count);
          String strI = String.valueOf(count);
          callback.invoke(strI);
        }
      });
    } catch (Exception e) {
      Log.e(TAG, "getNotificationCount method error = " + e);
      // e.printStackTrace();
    }
  }

  @ReactMethod
  public void scheduleNotification(String nid, String tag, String time, String title, String message, String url,
      String icon) {
    try {
      Log.e(TAG, "scheduleNotification method was called");
      NotifyVisitorsApi.getInstance(reactContext).scheduleNotification(nid, tag, time, title, message, url, icon);
    } catch (Exception e) {
      Log.e(TAG, "scheduleNotification method error = " + e);
      // e.printStackTrace();
    }
  }

  @ReactMethod
  public void userIdentifier(String userID, String sJsonObject) {
    try {
      Log.e(TAG, "userIdentifier method was called");
      JSONObject nJsonObject;
      if (sJsonObject != null) {
        nJsonObject = new JSONObject(sJsonObject);
      } else {
        nJsonObject = null;
      }

      NotifyVisitorsApi.getInstance(reactContext).userIdentifier(userID, nJsonObject);
    } catch (Exception e) {
      Log.e(TAG, "userIdentifier method error = " + e);
      // e.printStackTrace();
    }
  }

  @ReactMethod
  public void getClickInfoCP(final Callback callback) {
    try {
      Log.e(TAG, "getClickInfoCP method was called");
      JSONObject jsonObject = NotifyVisitorsApi.getInstance(reactContext).getClickInfoCP();
      if (jsonObject != null) {
        final String str = jsonObject.toString();
        Log.e("getClickInfoCP", str);
        callback.invoke(str);
      }
    } catch (Exception e) {
      Log.e(TAG, "getClickInfoCP error = " + e);
      // e.printStackTrace();
    }
  }

  @ReactMethod
  public void stopGeofencePushforDateTime(String dateTime, String additionalHours) {
    try {
      Log.e(TAG, "stopGeofencePushforDateTime was called");
      int jAdditionalHours = 0;
      boolean lock = true;
      if (dateTime == null || dateTime.length() == 0) {
        Log.e(TAG, "dateTime can not be null or empty");
        lock = false;
      }

      if (additionalHours == null || additionalHours.length() == 0) {
        jAdditionalHours = 0;
      } else {
        jAdditionalHours = Integer.parseInt(additionalHours);
      }

      if (lock) {
        NotifyVisitorsApi.getInstance(reactContext).stopGeofencePushforDateTime(dateTime, jAdditionalHours);
        lock = true;
      }

    } catch (Exception e) {
      Log.e(TAG, "stopGeofencePushforDateTime error = " + e);
    }

  }

  @ReactMethod
  public void setAutoStartPermission() {
    try {
        Log.e(TAG, "setAutoStartPermission method was called");
        Activity activity = getCurrentActivity();
        NotifyVisitorsApi.getInstance(reactContext).setAutoStartPermission(activity);
    } catch (Exception e) {
      Log.e(TAG, "setAutoStartPermission error = " + e);
      // e.printStackTrace();
    }
  }

}