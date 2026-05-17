const bcrypt = require('bcryptjs');
const db = require('./db');

async function seedAdmin() {
  try {
    const email = 'admin@banksampah.com';
    const password = 'admin123';

    // Hash password dengan bcrypt
    const hashedPassword = await bcrypt.hash(password, 10);
    
    // Insert ke database
    await db.execute(
      'INSERT INTO users (email, password) VALUES (?, ?)',
      [email, hashedPassword]
    );

    console.log('✅ User admin berhasil ditambahkan!');
    console.log(`   Email    : ${email}`);
    console.log(`   Password : ${password}`);
    process.exit(0);
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      console.log('⚠️  User admin sudah ada di database.');
    } else {
      console.error('❌ Gagal menambahkan user:', err.message);
    }
    process.exit(1);
  }
}

seedAdmin();
