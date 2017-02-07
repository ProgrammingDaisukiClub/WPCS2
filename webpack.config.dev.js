const path = require('path');

module.exports = {
  entry: {
    tutorial: "./src/tutorial/index.tsx",
  },
  output: {
    path: path.join(__dirname, "public/build"),
    filename: "[name].js",
  },
  devtool: "source-map",
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
