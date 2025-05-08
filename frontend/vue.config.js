const { defineConfig } = require('@vue/cli-service');

module.exports = defineConfig({
  transpileDependencies: [
    'vuetify'
  ],
  chainWebpack: config => {
    // Customizing the html plugin to ensure it emits correctly
    config.plugin('html').tap(args => {
      args[0].filename = 'index.html'; // Ensure only one index.html is emitted
      return args;
    });
  }
});
