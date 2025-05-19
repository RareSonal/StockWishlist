<template>
  <v-app>
    <amplify-authenticator>
      <router-view />
    </amplify-authenticator>
  </v-app>
</template>

<script>
import '@aws-amplify/ui-vue';

export default {
  name: 'App'
};
</script>

<style>
/* Optional: Style overrides for Amplify Auth UI */
amplify-authenticator {
  display: block;
  margin: auto;
  max-width: 400px;
}
</style>
