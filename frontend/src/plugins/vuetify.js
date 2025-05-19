import Vue from 'vue';
import Vuetify from 'vuetify/lib';
import 'vuetify/dist/vuetify.min.css'; // Make sure Vuetify's CSS is imported

Vue.use(Vuetify);

export default new Vuetify({
  theme: {
    themes: {
      light: {
        primary: '#1a73e8', // Blue, your custom primary color
        secondary: '#ff5722', // Red, your custom secondary color
        accent: '#4caf50', // Green, your custom accent color
      },
    },
  },
  icons: {
    iconfont: 'mdi', // Use Material Design Icons
  },
});
