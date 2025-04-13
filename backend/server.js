const express = require('express');
const mssql = require('mssql');
const cors = require('cors');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// Set up database connection
const poolPromise = new mssql.ConnectionPool({
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  server: process.env.DB_SERVER,
  database: process.env.DB_NAME,
  options: {
    encrypt: true, // Use encryption if necessary
    trustServerCertificate: true, // For local development
  },
}).connect();

// Fetch all available stocks
app.get('/stocks', async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query('SELECT * FROM Stocks WHERE quantity > 0');
    res.json(result.recordset);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// Add stock to wishlist
app.post('/wishlist', async (req, res) => {
  const { user_id, stock_id } = req.body;

  try {
    const pool = await poolPromise;

    // Check if stock is available (quantity > 0)
    const stockResult = await pool.request()
      .input('stock_id', mssql.Int, stock_id)
      .query('SELECT quantity FROM Stocks WHERE id = @stock_id');
      
    const stock = stockResult.recordset[0];
    
    if (!stock || stock.quantity <= 0) {
      return res.status(400).send('Stock not available.');
    }

    // Add stock to wishlist
    await pool.request()
      .input('user_id', mssql.Int, user_id)
      .input('stock_id', mssql.Int, stock_id)
      .query('INSERT INTO Wishlist (user_id, stock_id) VALUES (@user_id, @stock_id)');
    
    // Update the stock quantity
    await pool.request()
      .input('stock_id', mssql.Int, stock_id)
      .query('UPDATE Stocks SET quantity = quantity - 1 WHERE id = @stock_id');

    res.status(200).send('Stock added to wishlist');
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// Remove stock from wishlist
app.delete('/wishlist', async (req, res) => {
  const { user_id, stock_id } = req.body;

  try {
    const pool = await poolPromise;

    // Remove stock from wishlist
    await pool.request()
      .input('user_id', mssql.Int, user_id)
      .input('stock_id', mssql.Int, stock_id)
      .query('DELETE FROM Wishlist WHERE user_id = @user_id AND stock_id = @stock_id');
    
    // Update the stock quantity
    await pool.request()
      .input('stock_id', mssql.Int, stock_id)
      .query('UPDATE Stocks SET quantity = quantity + 1 WHERE id = @stock_id');

    res.status(200).send('Stock removed from wishlist');
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
