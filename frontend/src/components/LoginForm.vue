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

      <v-btn color="primary" type="submit">Login</v-btn>

      <v-alert v-if="successMessage" type="success" class="mt-3" dense outlined>
        {{ successMessage }}
      </v-alert>

      <v-alert v-if="errorMessage" type="error" class="mt-3" dense outlined>
        {{ errorMessage }}
      </v-alert>
    </v-form>
  </v-container>
</template>

<script>
import axios from "axios";

export default {
  name: "LoginForm",
  data() {
    return {
      email: "",
      password: "",
      successMessage: "",
      errorMessage: "",
    };
  },
  methods: {
  async validateForm() {
    this.successMessage = "";
    this.errorMessage = "";

    if (!this.email || !this.password) {
      this.errorMessage = "Email and Password are required!";
      return;
    }

    try {
      const response = await axios.post("http://127.0.0.1:5000/login", {
        email: this.email,
        password: this.password,
      });

      if (response.data.success) {
        this.successMessage = "Login successful!";
        
        // Store login state in localStorage
        sessionStorage.setItem('isLoggedIn', 'true');

        // Use this.$router.push to navigate to the wishlist page
        this.$router.push("/wishlist");
      } else {
        this.errorMessage = "Invalid credentials.";
      }
    } catch (error) {
      this.errorMessage = "Server error or invalid credentials.";
    }
  },
  
},
};
</script>
