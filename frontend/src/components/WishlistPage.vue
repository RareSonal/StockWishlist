<template>
  <v-container>
    <v-row>
      <v-col>
        <h1>Stock Wishlist</h1>
      </v-col>
      <v-col cols="auto">
        <v-btn color="error" @click="logout" outlined>Logout</v-btn>
      </v-col>
    </v-row>
    <v-row v-if="stocks.length">
      <v-col v-for="stock in stocks" :key="stock.id" cols="12" md="4">
        <v-card>
          <v-card-title>{{ stock.name }}</v-card-title>
          <v-card-subtitle>Quantity: {{ stock.quantity }}</v-card-subtitle>
          <v-card-actions>
            <v-btn @click="addToWishlist(stock.id)" color="primary">Add to Wishlist</v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
    <v-alert v-else>No stocks available.</v-alert>
  </v-container>
</template>

<script>
import { API } from 'aws-amplify';

export default {
  name: 'WishlistPage',
  data() {
    return {
      stocks: [],
      wishlist: []
    };
  },
  mounted() {
    this.fetchStocks();
    this.fetchWishlist();
  },
  methods: {
    async fetchStocks() {
      try {
        const response = await API.get('stocksApi', '/stocks');
        this.stocks = response;
      } catch (error) {
        console.error('Error fetching stocks:', error);
      }
    },
    async fetchWishlist() {
      try {
        const response = await API.get('wishlistApi', '/wishlist');
        this.wishlist = response;
      } catch (error) {
        console.error('Error fetching wishlist:', error);
      }
    },
    async addToWishlist(stockId) {
      try {
        await API.post('wishlistApi', '/wishlist', { body: { stockId } });
        this.fetchWishlist();
      } catch (error) {
        console.error('Error adding to wishlist:', error);
      }
    },
    logout() {
      Auth.signOut();
      this.$router.push('/login');
    }
  }
};
</script>
