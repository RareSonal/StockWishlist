const mssql = require('mssql');
require('dotenv').config();

const config = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  server: process.env.DB_SERVER,
  database: process.env.DB_NAME,
  options: {
    encrypt: true,
    trustServerCertificate: true
  }
};

mssql.connect(config).then(pool => {
  console.log('✅ Connected to SQL Server!');
  return pool.request().query('SELECT 1 AS test');
}).then(result => {
  console.log('✅ Test query result:', result.recordset);
  mssql.close();
}).catch(err => {
  console.error('❌ Connection failed:', err.message);
});
