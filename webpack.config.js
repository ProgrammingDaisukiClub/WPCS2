const path = require('path');

let config = {
  entry: {
    tutorial: "./src/tutorial/index.tsx",
  },
  output: {
    path: path.join(__dirname, "./app/assets/javascripts/build"),
    filename: "[name].js",
  },
  resolve: {
    extensions: [".ts", ".tsx", ".js"]
  },
  module: {
    rules: [{
      test: /\.tsx?$/,
      use: [{
        loader: "ts-loader"
      }]
    }]
  }
};

if(process.env.NODE_ENV === "development") {
  Object.assign(config, {
    devtool: "source-map",
  });
}

module.exports = config;
