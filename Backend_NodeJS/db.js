const mysql = require("mysql2");
const pool = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "",
  database: "db_kepl_sampah",
});
module.exports = pool.promise();
