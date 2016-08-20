package com.tealeaf.plugin.plugins;

import com.tealeaf.logger;
import com.tealeaf.plugin.IPlugin;
import com.tealeaf.TeaLeaf;
import com.tealeaf.EventQueue;
import org.json.JSONObject;
import java.util.HashMap;
import java.util.Map;
import android.app.Activity;
import android.content.Intent;
import android.content.Context;
import android.os.Bundle;
import android.content.pm.PackageManager;
import com.freshdesk.hotline.*;

public class HotlinePlugin implements IPlugin {

  private Context appContext;
  private HotlineUser hlUser;

  private final String TAG = "{hotline}";

  public void onCreateApplication(Context applicationContext) {
    appContext = applicationContext;
  }

  public void onCreate(Activity activity, Bundle savedInstanceState) {
    String appID = "";
    String appKey = "";
    PackageManager manager = activity.getBaseContext().getPackageManager();

    try {
      Bundle meta = manager.getApplicationInfo(activity.getApplicationContext().getPackageName(),
        PackageManager.GET_META_DATA).metaData;
      appID = meta.get("HOTLINE_APP_ID").toString();
      appKey = meta.get("HOTLINE_APP_KEY").toString();
    } catch (Exception e) {
      logger.log(TAG + "{exception}", "" + e.getMessage());
    }

    HotlineConfig hlConfig = new HotlineConfig(appID, appKey);
    // TODO: Read these from config
    hlConfig.setVoiceMessagingEnabled(false);
    hlConfig.setCameraCaptureEnabled(false);
    hlConfig.setPictureMessagingEnabled(false);

    Hotline.getInstance(activity).init(hlConfig);
    hlUser = Hotline.getInstance(appContext).getUser();
  }

  public void onResume() {
  }

  public void onRenderResume() {
  }

  public void onStart() {
  }

  public void onFirstRun() {
  }

  public void onPause() {
  }

  public void onRenderPause() {
  }

  public void onStop() {
  }

  public void onDestroy() {
  }

  public void onNewIntent(Intent intent) {
  }

  public void setInstallReferrer(String referrer) {
  }

  public void onActivityResult(Integer request, Integer result, Intent data) {
  }

  public boolean consumeOnBackPressed() {
    return true;
  }

  public void onBackPressed() {
  }

  public void setName (String param) {
    JSONObject reqJson;

    try{
      reqJson = new JSONObject(param);
      hlUser.setName(reqJson.getString("name"));
    } catch (Exception e){
      logger.log(TAG + "{exception}", "" + e.getMessage());
    }
  }

  public void setEmail (String param) {
    JSONObject reqJson;

    try{
      reqJson = new JSONObject(param);
      hlUser.setEmail(reqJson.getString("email"));
    } catch (Exception e){
      logger.log(TAG + "{exception}", "" + e.getMessage());
    }
  }

  public void addMetaData (String param) {
    JSONObject reqJson;
    Map<String, String> userMeta = new HashMap<String, String>();

    try{
      reqJson = new JSONObject(param);
      userMeta.put(reqJson.getString("field_name"), reqJson.getString("value"));
    } catch (Exception e){
      logger.log(TAG + "{exception}", "" + e.getMessage());
    }
    Hotline.getInstance(appContext).updateUserProperties(userMeta);
  }

  public void clearUserData(String param) {
    Hotline.clearUserData(appContext);
  }

  public void showConversations(String params) {
    Hotline.showConversations(appContext);
  }

  public void showFAQs(String params) {
    Hotline.showFAQs(appContext);
  }
}
