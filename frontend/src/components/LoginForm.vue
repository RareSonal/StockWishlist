<template>
  <v-container>
    <v-form ref="form" @submit.prevent="validateForm">
      <v-text-field
        v-model="email"
        label="Email"
        required
      ></v-text-field>

      <v-text-field
        v-model="password"
        label="Password"
        type="password"
        required
      ></v-text-field>

      <v-btn color="primary" type="submit" :loading="loading">
        Login
      </v-btn>

      <v-alert
        v-if="successMessage"
        type="success"
        class="mt-3"
        dense
        outlined
      >
        {{ successMessage }}
      </v-alert>

      <v-alert
        v-if="errorMessage"
        type="error"
        class="mt-3"
        dense
        outlined
      >
        {{ errorMessage }}
      </v-alert>
    </v-form>
  </v-container>
</template>

<script>
import { Auth } from 'aws-amplify';

export default {
  name: "LoginForm",
  data() {
    return {
      email: "",
      password: "",
      successMessage: "",
      errorMessage: "",
      loading: false
    };
  },
  methods: {
    async validateForm() {
      this.successMessage = "";
      this.errorMessage = "";
      this.loading = true;

      if (!this.email || !this.password) {
        this.errorMessage = "Email and Password are required!";
        this.loading = false;
        return;
      }

      try {
        await this.trySignIn(this.email, this.password);
        this.successMessage = "Login successful!";
        this.$router.push("/wishlist");
      } catch (error) {
        console.error("Login failed:", error);
        this.errorMessage =
          error.message || "Login failed. Please check your credentials.";
      } finally {
        this.loading = false;
      }
    },

    async trySignIn(email, password) {
      try {
        const user = await Auth.signIn(email, password);
        this.storeTokens(user);
      } catch (err) {
        // First attempt failed – possibly because user migration is needed
        if (
          err.code === "UserNotFoundException" ||
          err.code === "NotAuthorizedException"
        ) {
          console.warn("User may be migrating. Retrying after 1s...");
          await new Promise(resolve => setTimeout(resolve, 1000));

          try {
            const retryUser = await Auth.signIn(email, password);
            this.storeTokens(retryUser);
          } catch (retryError) {
            throw retryError; // Let outer handler display error
          }
        } else {
          throw err; // Immediate throw for non-migration issues
        }
      }
    },

    storeTokens(user) {
      const session = user.signInUserSession;
      localStorage.setItem("id_token", session.idToken.jwtToken);
      localStorage.setItem("access_token", session.accessToken.jwtToken);
      localStorage.setItem("refresh_token", session.refreshToken.token);
    }
  }
};
</script>
