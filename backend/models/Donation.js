const mongoose = require('mongoose');

const donationSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Please provide the food title'],
    trim: true,
  },
  description: {
    type: String,
    required: [true, 'Please provide a description of the food'],
  },
  quantity: {
    type: String,
    required: [true, 'Please provide the quantity of food'],
  },
  location: {
    // GeoJSON Point
    type: {
      type: String,
      enum: ['Point'],
      required: true,
      default: 'Point'
    },
    coordinates: {
      type: [Number], // [longitude, latitude]
      required: true
    },
    address: String
  },
  donorId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  status: {
    type: String,
    enum: ['Available', 'Claimed', 'Delivered'],
    default: 'Available'
  },
  expiringAt: {
    type: Date,
    required: true
  }
}, { timestamps: true });

// Create 2dsphere index for location-based queries 
donationSchema.index({ location: '2dsphere' });

module.exports = mongoose.model('Donation', donationSchema);
