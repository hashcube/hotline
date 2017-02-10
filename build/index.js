
var path = require('path'),
  fs = Promise.promisifyAll(require('fs-extra')),
  xmldoc = require('xmldoc'),
  copyFile = Promise.promisify(fs.copy);

exports.onCreateProject = function (api, app, config, cb) {
  var packageName = app.manifest.android.packageName || "",
    androidProjectPath = config.outputPath,
    strings_file = 'hotline_strings.xml';

  if (config.target == 'native-android') {
    xmlStr = new xmldoc.XmlDocument(fs.readFileSync(path.join(__dirname, '../android/strings.xml'), 'utf-8'));
    xmlStr.children[0].val = packageName + ".provider";
    return fs.outputFileAsync(path.join(androidProjectPath, 'res/values', strings_file), xmlStr.toString(), 'utf-8');
  }

  return Promise.resolve(true);
}
