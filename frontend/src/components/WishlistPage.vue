<template>
  <v-container>
    <v-row>
      <v-col>
        <h1>Stock Wishlist</h1>
      </v-col>
      <v-col cols="auto">
        <v-btn color="error" outlined @click="logout">Logout</v-btn>
      </v-col>
    </v-row>

    <v-row v-if="stocks.length">
      <v-col
        v-for="stock in stocks"
        :key="stock.id"
        cols="12"
        md="4"
      >
        <v-card>
          <v-card-title>{{ stock.name }}</v-card-title>
          <v-card-subtitle>Quantity: {{ stock.quantity }}</v-card-subtitle>
          <v-card-actions>
            <v-btn 
              color="primary" 
              @click="addToWishlist(stock.id)" 
              :disabled="wishlist.some(w => w.stock_id === stock.id)">
              Add to Wishlist
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>

    <v-alert v-else type="info">No stocks available.</v-alert>
  </v-container>
</template>

<script>
import { API, Auth } from 'aws-amplify';

export default {
  name: 'WishlistPage',
  data() {
    return {
      stocks: [],
      wishlist: [],
    };
  },
  async mounted() {
    await this.fetchStocks();
    await this.fetchWishlist();
  },
  methods: {
    async fetchStocks() {
      try {
        const response = await API.get('backendApi', '/stocks');
        this.stocks = response;
      } catch (error) {
        this.handleAuthError(error, 'fetching stocks');
      }
    },

    async fetchWishlist() {
      try {
        const response = await API.get('backendApi', '/wishlist');
        this.wishlist = response;
      } catch (error) {
        this.handleAuthError(error, 'fetching wishlist');
      }
    },

    async addToWishlist(stockId) {
      try {
        const response = await API.post('backendApi', '/wishlist', {
          body: { stock_id: stockId },
        });

        const updated = response.updated_stock;
        const wishlist = response.updated_wishlist;

        // Update stock list reactively
        const index = this.stocks.findIndex(stock => stock.id === updated.id);
        if (index !== -1) {
          const newStocks = [...this.stocks];
          newStocks[index] = updated;
          this.stocks = newStocks;
        }

        this.wishlist = wishlist;
      } catch (error) {
        this.handleAuthError(error, 'adding to wishlist');
      }
    },

    async logout() {
      await Auth.signOut();
      this.$router.push('/login');
    },

    async handleAuthError(error, action) {
      if (error.response && error.response.status === 401) {
        console.warn(`Unauthorized while ${action}. Signing out...`);
        await Auth.signOut();
        this.$router.push('/login');
      } else {
        console.error(`Error ${action}:`, error);
      }
    },
  },
};
</script>
