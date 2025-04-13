const express = require('express');
const app = express();
const port = 5000;

app.get('/', (req, res) => res.send('Backend is working!'));

app.listen(port, () => console.log(`Test server running on port ${port}`));
