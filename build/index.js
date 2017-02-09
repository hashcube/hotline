
var path = require('path'),
  fs = Promise.promisifyAll(require('fs-extra')),
  xmldoc = require('xmldoc'),
  copyFile = Promise.promisify(fs.copy);

exports.onCreateProject = function (api, app, config, cb) {
  var packageName = app.manifest.android.packageName || "",
    androidProjectPath = config.outputPath,
    strings_file = 'hotline_strings.xml',
    conf;

  if (config.target == 'native-android') {
    conf = {
      hotline_file_provider_authority: packageName + ".provider",
    };
    xmlStr = new xmldoc.XmlDocument(fs.readFileSync(path.join(__dirname, '../android/strings.xml'), 'utf-8'));

    for (var i = 0; i < xmlStr.children.length; i++) {
      var currStrDom = xmlStr.children[i],
        attrName = currStrDom.attr.name;

      if (currStrDom.name === 'string' && attrName in conf) {
        console.log(attrName, conf[attrName]);
        currStrDom.val = conf[attrName];
      }
    }

    return fs.outputFileAsync(path.join(androidProjectPath, 'res/values', strings_file), xmlStr.toString(), 'utf-8');
  }

  return Promise.resolve(true);
}
