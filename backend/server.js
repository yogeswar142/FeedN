require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');

// Route files
const authRoutes = require('./routes/authRoutes');

const app = express();

// --- Security Middleware Setup --- //

// 1. Set security HTTP headers
app.use(helmet());

// 2. Enable CORS with default settings (configure as needed for production)
app.use(cors());

// 3. Body parser, reading data from body into req.body
app.use(express.json({ limit: '10kb' }));

// 4. Rate limiting: restrict amount of requests from same IP to prevent brute force
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per `window`
  message: 'Too many requests from this IP, please try again in 15 minutes!'
});
// Apply the rate limiting middleware to all requests
app.use('/api', limiter);

// --- MongoDB Connection Setup --- //

mongoose.connect(process.env.MONGODB_URI)
  .then(() => {
    console.log('Successfully connected to MongoDB.');
  })
  .catch((err) => {
    console.log('Error connecting to MongoDB: ', err.message);
  });

// --- API Routes --- //

app.use('/api/auth', authRoutes);

// Test route
app.get('/', (req, res) => {
  res.send('The Living Larder API Access OK.');
});

// Start Express Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
