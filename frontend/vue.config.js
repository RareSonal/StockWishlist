const { defineConfig } = require('@vue/cli-service');
const path = require('path');

module.exports = defineConfig({
  transpileDependencies: ['vuetify'],

  publicPath: process.env.NODE_ENV === 'production' ? '/' : '/',

  productionSourceMap: false,

  pluginOptions: {
    vuetify: {
      customVariables: ['~/src/styles/variables.scss'],
      treeShake: true,
    },
  },

  configureWebpack: {
    optimization: {
      splitChunks: {
        chunks: 'all',
      },
    },
    externals: process.env.NODE_ENV === 'production'
      ? {
          'aws-amplify': 'Amplify',
        }
      : {},
  },

  chainWebpack: config => {
    config.plugin('html').tap(args => {
      args[0].filename = 'index.html';
      return args;
    });

    config.resolve.alias.set('@', path.resolve(__dirname, 'src'));

    if (process.env.NODE_ENV === 'development') {
      config.devServer
        .proxy({
          '/api': {
            target: 'http://localhost:5000',
            changeOrigin: true,
            secure: false,
            pathRewrite: { '^/api': '' },
          },
        });
    }
  }
});
