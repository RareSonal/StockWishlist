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
        const response = await fetch("https://svy233k6zi.execute-api.us-east-1.amazonaws.com/prod/login", {
          method: "POST",
          headers: {
            "Content-Type": "application/json"
          },
          body: JSON.stringify({
            username: this.email,
            password: this.password
          })
        });

        const data = await response.json();

        if (!response.ok) {
          this.errorMessage = data.error || "Login failed. Please try again.";
          this.loading = false;
          return;
        }

        this.successMessage = "Login successful!";

        // Store tokens (you can also store in Vuex if preferred)
        localStorage.setItem("id_token", data.id_token);
        localStorage.setItem("access_token", data.access_token);
        if (data.refresh_token) {
          localStorage.setItem("refresh_token", data.refresh_token);
        }

        // Navigate to wishlist
        this.$router.push("/wishlist");
      } catch (error) {
        console.error("Login error:", error);
        this.errorMessage = "An unexpected error occurred.";
      } finally {
        this.loading = false;
      }
    }
  }
};
</script>
