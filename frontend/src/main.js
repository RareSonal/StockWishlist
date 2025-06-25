import Vue from 'vue';
import App from './App.vue';
import vuetify from './plugins/vuetify';
import router from './router';
import { Amplify, Auth } from 'aws-amplify';
import awsExports from './aws-exports';
import { applyPolyfills, defineCustomElements } from '@aws-amplify/ui-components/loader';

Vue.config.productionTip = false;

// ✅ Log the AWS Amplify configuration for debugging
console.log("Amplify config", awsExports);

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

          // ✅ Retrieve tokens
          const idToken = session.getIdToken().getJwtToken();
          const accessToken = session.getAccessToken().getJwtToken();

          // ✅ Decode and log token payloads
          console.log("---- [ID TOKEN PAYLOAD] ----");
          console.log(JSON.parse(atob(idToken.split('.')[1])));

          console.log("---- [ACCESS TOKEN PAYLOAD] ----");
          console.log(JSON.parse(atob(accessToken.split('.')[1])));

          // Use ID token for Authorization header
          return { Authorization: `Bearer ${idToken}` };
        } catch (err) {
          console.warn("[Amplify] No auth session found:", err.message || err);
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
