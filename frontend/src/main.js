import Vue from 'vue';
import App from './App.vue';
import vuetify from './plugins/vuetify';
import router from './router';
import { Amplify, Auth, API } from 'aws-amplify';
import awsExports from './aws-exports';
import '@aws-amplify/ui-vue/styles.css';
import { applyPolyfills, defineCustomElements } from '@aws-amplify/ui-components/loader';

Vue.config.productionTip = false;

// Configure AWS Amplify
Amplify.configure({
  ...awsExports,
  API: {
    ...awsExports.API,
    endpoints: awsExports.API.endpoints.map(endpoint => ({
      ...endpoint,
      custom_header: async () => {
        try {
          const session = await Auth.currentSession();
          const token = session.getIdToken().getJwtToken();
          return { Authorization: `Bearer ${token}` };
        } catch (err) {
          console.warn("No auth session found:", err);
          return {};
        }
      }
    }))
  }
});

// Register Amplify UI components globally
applyPolyfills().then(() => {
  defineCustomElements(window);
});

new Vue({
  vuetify,
  router,
  render: h => h(App)
}).$mount('#app');
