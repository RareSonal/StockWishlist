import Vue from 'vue';
import App from './App.vue';
import vuetify from './plugins/vuetify';
import router from './router';
import { Amplify } from 'aws-amplify';
import awsExports from './aws-exports';
import '@aws-amplify/ui-vue/styles.css';
import { applyPolyfills, defineCustomElements } from '@aws-amplify/ui-components/loader';

Vue.config.productionTip = false;

// Configure AWS Amplify
Amplify.configure(awsExports);

// Optional: Register Amplify UI components globally if needed
applyPolyfills().then(() => {
  defineCustomElements(window);
});

new Vue({
  vuetify,
  router,
  render: h => h(App)
}).$mount('#app');
