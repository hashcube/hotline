/* global NATIVE */
function pluginSend(evt, params) {
  "use strict";

  NATIVE.plugins.sendEvent("HotlinePlugin", evt,
    JSON.stringify(params || {}));
}

exports = new (Class(function () {
  "use strict";

  this.setUserInfo = function (email, full_name) {
    pluginSend("setUserInfo", {name: full_name, email: email});
  };

  this.setUserEmail = function (email) {
    pluginSend("setUserEmail", {email: email});
  };

  this.setUserFullName = function (full_name) {
    pluginSend("setUserFullName", {name: full_name});
  };

  this.clearUserData = function () {
    pluginSend("clearUserData", {});
  };

  this.addCustomData = function (name, value) {
    pluginSend("addCustomData", {field_name: name, value: value});
  };

  this.showConversations = function () {
    pluginSend("showConversations", {});
  };

  this.showFAQs = function () {
    pluginSend("showFAQs", {});
  };

}))();
