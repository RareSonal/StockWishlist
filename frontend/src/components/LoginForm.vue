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
const user = await Auth.signIn(this.email, this.password);
this.successMessage = "Login successful!";
sessionStorage.setItem("isLoggedIn", "true");
this.$router.push("/wishlist");
} catch (error) {
switch (error.code) {
case "UserNotConfirmedException":
this.errorMessage = "User not confirmed. Please check your email.";
break;
case "NotAuthorizedException":
this.errorMessage = "Incorrect email or password.";
break;
default:
this.errorMessage = "Login failed. Please try again.";
}
}
},
},
};
</script>

