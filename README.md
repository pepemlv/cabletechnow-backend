# CableTechNow Backend API

🚀 **Production-ready backend server** for CableTechNow - Connecting homeowners with cable technicians for instant technical support.

## 🌟 Features

- **Stripe Payment Integration** - Secure payment processing
- **CORS Configuration** - Cross-origin resource sharing setup
- **Webhook Support** - Real-time payment event handling
- **Express.js Server** - Fast and minimal web framework
- **Environment Configuration** - Secure environment variable management

## 🛠️ Tech Stack

- **Node.js** - JavaScript runtime
- **Express.js** - Web application framework
- **Stripe** - Payment processing platform
- **CORS** - Cross-origin resource sharing
- **dotenv** - Environment variable loader

## 📋 Prerequisites

- Node.js (v16 or higher)
- npm or yarn
- Stripe account for payment processing

## 🚀 Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd cabletechnow-backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   ```
   
   Update `.env` with your configuration:
   ```env
   STRIPE_SECRET_TEST=sk_test_...
   STRIPE_WEBHOOK_SECRET=whsec_...
   PORT=4000
   ```

4. **Start the server**
   ```bash
   # Development
   npm run dev
   
   # Production
   npm start
   ```

## 🔧 API Endpoints

### Health Check
```http
GET /
```
Returns server status confirmation.

### Create Payment Intent
```http
POST /api/create-payment-intent
Content-Type: application/json

{
  "amount": 50.00,
  "currency": "USD",
  "description": "Service payment"
}
```

### Process Payment
```http
POST /api/payment
Content-Type: application/json

{
  "amount": 50.00,
  "paymentMethodId": "pm_...",
  "description": "Service payment"
}
```

### Stripe Webhook
```http
POST /api/webhook
Content-Type: application/json
Stripe-Signature: <signature>
```

## 🌍 CORS Configuration

The server is configured to accept requests from:
- `https://testpms.com/`
- `http://localhost:5174`
- `http://localhost:5173`
- `http://localhost:3000`

## 📦 Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `STRIPE_SECRET_TEST` | Stripe secret key for test mode | ✅ |
| `STRIPE_WEBHOOK_SECRET` | Stripe webhook signing secret | ✅ |
| `PORT` | Server port number | ❌ (default: 4000) |

## 🚀 Deployment

### Heroku Deployment

1. **Install Heroku CLI**
2. **Create Heroku app**
   ```bash
   heroku create cabletechnow-api
   ```

3. **Set environment variables**
   ```bash
   heroku config:set STRIPE_SECRET_TEST=your_stripe_key
   heroku config:set STRIPE_WEBHOOK_SECRET=your_webhook_secret
   ```

4. **Deploy**
   ```bash
   git push heroku main
   ```

### Railway Deployment

1. **Connect your GitHub repository to Railway**
2. **Set environment variables in Railway dashboard**
3. **Deploy automatically on git push**

### Vercel Deployment

1. **Install Vercel CLI**
   ```bash
   npm i -g vercel
   ```

2. **Deploy**
   ```bash
   vercel --prod
   ```

## 🔒 Security Features

- Environment variable protection
- CORS policy enforcement
- Stripe webhook signature verification
- Input validation and sanitization

## 📊 Monitoring & Logging

The server includes comprehensive logging for:
- Payment processing events
- Webhook events
- Error tracking
- Server health status

## 🧪 Testing

```bash
# Test server health
curl http://localhost:4000/

# Test payment intent creation
curl -X POST http://localhost:4000/api/create-payment-intent \
  -H "Content-Type: application/json" \
  -d '{"amount": 25.00, "description": "Test payment"}'
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Issues**: Report bugs and feature requests via GitHub Issues
- **Documentation**: Check the [API Documentation](docs/api.md)
- **Contact**: [Your contact information]

## 🔄 Changelog

### v1.0.0
- Initial release
- Stripe payment integration
- Basic webhook support
- CORS configuration
- Health check endpoint

---

**Made with ❤️ for CableTechNow** - Connecting homeowners with technical experts instantly!