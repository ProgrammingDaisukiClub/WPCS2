const webpack = require('webpack');
const path = require('path');

const I18nPlugin = require('i18n-webpack-plugin');
const languages = {
  'en': require('./src/locales/en.json'),
  'ja': require('./src/locales/ja.json')
};

i18n_configs = Object.keys(languages).map(lang => ({
  mode: process.env.NODE_ENV,
  name: lang,
  entry: {
    contests: path.resolve(__dirname, 'src/contests/index.tsx')
  },
  output: {
    path: path.join(__dirname, "app/assets/javascripts/build"),
    filename: `[name].${lang}.js`
  },
  resolve: {
    extensions: [".ts", ".tsx", ".js"],
    modules: [
      "node_modules",
      path.resolve(__dirname, "src")
    ]
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: "ts-loader",
      }
    ]
  },
  plugins: [
    new I18nPlugin(languages[lang], {
      functionName: 't',
    })
  ]
}));

module.exports = i18n_configs;
