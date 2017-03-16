const path = require('path');
const I18nPlugin = require('i18n-webpack-plugin');

const languages = {
  "en": require("./src/locales/en.json"),
  "ja": require("./src/locales/ja.json")
};

let config = {
  entry: {
    tutorial: "./src/tutorial/index.tsx",
    contests: "./src/contests/index.tsx",
  },
  output: {
    path: path.join(__dirname, "./app/assets/javascripts/build"),
  },
  resolve: {
    extensions: [".ts", ".tsx", ".js"],
    modules: [
      "node_modules",
      path.resolve("./src"),
    ],
  },
  module: {
    rules: [{
      test: /\.tsx?$/,
      use: [{
        loader: "ts-loader",
      }],
    }],
  },
};

if (process.env.NODE_ENV === "development") {
  Object.assign(config, {
    devtool: "source-map",
  });
}

i18n_configs = Object.keys(languages).map(language => Object.assign({}, config, {
  name: language,
  output: Object.assign({}, config.output, {
    filename: `[name].${language}.js`
  }),
  plugins: [ new I18nPlugin(languages[language]) ],
}));

module.exports = i18n_configs;
