const mongoose = require('mongoose');

const deliverySchema = new mongoose.Schema({
  donationId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Donation',
    required: true
  },
  volunteerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  status: {
    type: String,
    enum: ['Pending', 'EnRoute', 'Completed', 'Cancelled'],
    default: 'Pending'
  },
  pickupTime: {
    type: Date
  },
  deliveryTime: {
    type: Date
  },
  proofImage: {
    type: String // URL link to image of completion (Optional currently)
  }
}, { timestamps: true });

module.exports = mongoose.model('Delivery', deliverySchema);
