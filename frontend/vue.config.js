const { defineConfig } = require('@vue/cli-service');

module.exports = defineConfig({
  transpileDependencies: [
    'vuetify', // Ensure Vuetify is transpiled correctly
  ],
  chainWebpack: config => {
    // Customizing the html plugin to ensure it emits correctly
    config.plugin('html').tap(args => {
      args[0].filename = 'index.html'; // Ensure only one index.html is emitted
      return args;
    });

    // Optional: Configuring the webpack dev server for API proxy during development (can be used to proxy to your backend API)
    config.devServer
      .proxy({
        '/api': {
          target: 'http://localhost:5000', // Set to your backend API URL
          changeOrigin: true,
          secure: false,
          pathRewrite: { '^/api': '' }
        },
      });

    // Optional: Adding an alias for the src folder
    config.resolve.alias.set('@', './src');
  },
  configureWebpack: {
    // Optional: Optimizing build size by splitting vendor code into separate chunks
    optimization: {
      splitChunks: {
        chunks: 'all',
      },
    },
    // Optional: Adding any necessary externals for large libraries to avoid bundling them (for example, externalizing AWS Amplify if using CDN)
    externals: {
      'aws-amplify': 'Amplify',
    },
  },
  publicPath: process.env.NODE_ENV === 'production' ? '/production-sub-path/' : '/',
  pluginOptions: {
    // Optional: Configure Vuetify loader for tree-shaking and automatic Vuetify import resolution
    vuetify: {
      customVariables: ['~/src/styles/variables.scss'],
      treeShake: true,
    },
  },
});
