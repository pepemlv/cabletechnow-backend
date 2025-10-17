import express from 'express';
import dotenv from 'dotenv';
import Stripe from 'stripe';
import cors from 'cors';
import bodyParser from 'body-parser';

dotenv.config();

const app = express();
const stripe = new Stripe(process.env.STRIPE_SECRET_TEST);
const PORT = process.env.PORT || 4000;

// Middleware
app.use(cors({
  origin: [
    'https://testpms.com',
    'https://testpms.com/', 
    'http://localhost:5174', 
    'http://localhost:5173', 
    'http://localhost:3000'
  ],
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
  credentials: true,
  preflightContinue: false,
  optionsSuccessStatus: 200
}));

// Handle preflight requests explicitly
app.options('*', cors());

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// --- Health check ---
app.get('/', (req, res) => {
  res.send('✅ CableTechNow Backend is running');
});

// --- Create Payment Intent for Stripe ---
app.post('/api/create-payment-intent', async (req, res) => {
  const { amount, currency = 'USD', description } = req.body;

  if (!amount) {
    return res.status(400).json({ error: 'Amount is required' });
  }

  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(amount * 100), // Convert to cents
      currency: currency.toLowerCase(),
      description: description || 'Service payment via CableTechNow',
      automatic_payment_methods: {
        enabled: true,
      },
    });

    res.status(200).json({
      clientSecret: paymentIntent.client_secret,
      paymentIntentId: paymentIntent.id,
    });
  } catch (error) {
    console.error('❌ Stripe error:', error.message);
    res.status(500).json({ error: 'Failed to create payment intent' });
  }
});

// --- Process Payment ---
app.post('/api/payment', async (req, res) => {
  const { amount, paymentMethodId, description } = req.body;

  if (!amount || !paymentMethodId) {
    return res.status(400).json({ success: false, message: 'Missing required fields' });
  }

  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(amount * 100), // Convert to cents
      currency: 'USD',
      description: description || 'Service payment via CableTechNow',
      payment_method: paymentMethodId,
      confirm: true,
      return_url: 'http://localhost:5177/payment-success',
    });

    res.status(200).json({ 
      success: true, 
      message: 'Payment successful',
      paymentIntent: paymentIntent
    });
  } catch (error) {
    console.error('❌ Stripe payment error:', error.message);
    res.status(500).json({ 
      success: false, 
      message: 'Payment failed',
      error: error.message 
    });
  }
});

// --- Webhook for Stripe events ---
app.post('/api/webhook', express.raw({type: 'application/json'}), (req, res) => {
  const sig = req.headers['stripe-signature'];
  let event;

  try {
    event = stripe.webhooks.constructEvent(req.body, sig, process.env.STRIPE_WEBHOOK_SECRET);
  } catch (err) {
    console.error('❌ Webhook signature verification failed:', err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Handle the event
  switch (event.type) {
    case 'payment_intent.succeeded':
      const paymentIntent = event.data.object;
      console.log('✅ PaymentIntent was successful:', paymentIntent.id);
      // Update your database here
      break;
    case 'payment_method.attached':
      const paymentMethod = event.data.object;
      console.log('✅ PaymentMethod was attached to a Customer:', paymentMethod.id);
      break;
    default:
      console.log(`Unhandled event type ${event.type}`);
  }

  res.json({received: true});
});

app.listen(PORT, () => {
  console.log(`✅ CableTechNow Backend running at http://localhost:${PORT}`);
});