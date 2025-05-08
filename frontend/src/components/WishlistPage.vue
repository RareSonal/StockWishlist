<template>
  <div id="app">
    <v-container>
      <v-row justify="space-between" align="center">
        <v-col>
          <h1 class="app-title">Stock Wishlist</h1>
        </v-col>
        <v-col cols="auto">
          <v-btn color="error" @click="logout" outlined>
            Logout
          </v-btn>
        </v-col>
      </v-row>
    </v-container>

    <div v-if="stocks.length" class="stock-list">
      <div class="stocks-grid">
        <div v-for="stock in stocks" :key="stock.id" class="stock-item">
          <div class="stock-details">
            <span class="stock-name">{{ stock.name }}</span>
            <span class="stock-quantity">Quantity: {{ stock.quantity }}</span>
          </div>
          <button @click="addToWishlist(stock.id)" class="btn add-btn">BUY</button>
        </div>
      </div>
    </div>

    <div v-else>
      <p class="no-stocks">No stocks available.</p>
    </div>


  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'WishlistPage',
  data() {
    return {
      stocks: [],
      wishlist: [],
      userId: 1 // Still used for wishlist actions
    };
  },
  mounted() {
    this.fetchStocks();
    this.fetchWishlist();
  },
  methods: {
    async fetchStocks() {
      try {
        const response = await axios.get('http://127.0.0.1:5000/stocks');
        this.stocks = response.data;
      } catch (error) {
        console.error('Error fetching stocks:', error.message);
      }
    },
    async fetchWishlist() {
      try {
        const response = await axios.get('http://127.0.0.1:5000/wishlist');
        this.wishlist = response.data;
      } catch (error) {
        console.error('Error fetching wishlist:', error.message);
      }
    },
    async addToWishlist(stockId) {
      try {
        await axios.post('http://127.0.0.1:5000/wishlist', {
          user_id: this.userId,
          stock_id: stockId
        });
        this.fetchStocks();
        this.fetchWishlist();
      } catch (error) {
        console.error('Error adding to wishlist:', error.message);
      }
    },
    async removeFromWishlist(stockId) {
      try {
        await axios.delete('http://127.0.0.1:5000/wishlist', {
          data: { user_id: this.userId, stock_id: stockId }
        });
        this.fetchStocks();
        this.fetchWishlist();
      } catch (error) {
        console.error('Error removing from wishlist:', error.message);
      }
    },
    logout() {
      sessionStorage.removeItem('isLoggedIn');
      this.$router.push('/login');
    }
  }
};
</script>



<style scoped>
/* Global styles */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Arial', sans-serif;
  background-color: #e0e0e0; /* Set overall background to gray */
  color: #333;
}

h1, h2 {
  font-weight: bold;
  color: #333;
}

h1.app-title {
  font-size: 2.5rem;
  text-align: center;
  margin-top: 40px;
  color: #1a73e8;
}

.section-title {
  font-size: 1.8rem;
  margin-bottom: 15px;
  color: #333;
}

ul {
  list-style-type: none;
  padding-left: 0;
}

button {
  cursor: pointer;
  border: none;
  padding: 8px 20px;
  border-radius: 4px;
  color: white;
  font-weight: bold;
  transition: all 0.3s ease;
}

button:hover {
  transform: scale(1.05);
}

.btn {
  padding: 10px 15px;
}

.add-btn {
  background-color: #4caf50;
}

.add-btn:hover {
  background-color: #45a049;
}

.remove-btn {
  background-color: #f44336;
}

.remove-btn:hover {
  background-color: #e53935;
}

/* Grid layout for the stock list */
.stocks-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); /* Adjusted to make grid items larger */
  gap: 20px;
  padding: 20px;
}

.stock-item, .wishlist-item {
  background-color: white;
  padding: 20px;
  margin-bottom: 10px;
  border-radius: 8px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  position: relative; /* Ensures the button can be positioned at the bottom-right */
}

.stock-item .stock-details {
  font-size: 1.1rem;
  display: flex;
  flex-direction: column;
  margin-bottom: 10px;
}

.stock-item .stock-name {
  font-weight: bold;
}

.stock-quantity {
  color: #888;
  font-size: 1rem; /* Adjusted quantity font size */
}

.wishlist-name {
  font-size: 1.2rem;
  font-weight: bold;
}

.no-stocks {
  text-align: center;
  font-size: 1.3rem;
  color: #555;
}

.stock-list, .wishlist {
  max-width: 1200px;
  margin: 30px auto;
}

.wishlist {
  background-color: #e3f2fd;
  padding: 20px;
  border-radius: 8px;
}

.wishlist-items .wishlist-item {
  background-color: #f1f8e9;
}

/* Position the Add to Wishlist button at the bottom-right */
.stock-item .add-btn {
  position: absolute;
  bottom: 10px;
  right: 10px;
}
</style>