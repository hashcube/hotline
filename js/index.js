/* global NATIVE */
function pluginSend(evt, params) {
  "use strict";

  NATIVE.plugins.sendEvent("HotlinePlugin", evt,
    JSON.stringify(params || {}));
}

exports = new (Class(function () {
  "use strict";

  this.setName = function (name) {
    pluginSend("setName", {name: name});
  };

  this.setEmail = function (email) {
    pluginSend("setEmail", {email: email});
  };

  this.setExternalId = function (id) {
    pluginSend("setExternalId", {id: id});
  };

  this.addMetaData = function (name, value) {
    pluginSend("addMetaData", {field_name: name, value: value});
  };

  this.clearUserData = function () {
    pluginSend("clearUserData", {});
  };

  this.showConversations = function () {
    pluginSend("showConversations", {});
  };

  this.showFAQs = function () {
    pluginSend("showFAQs", {});
  };

}))();
