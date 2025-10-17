# CableTechNow Backend - Deployment Guide

## 🚀 Production Deployment Options

### 1. Heroku Deployment (Recommended)

**Step-by-step guide:**

1. **Install Heroku CLI**
   ```bash
   # macOS
   brew tap heroku/brew && brew install heroku
   
   # Windows
   # Download from https://devcenter.heroku.com/articles/heroku-cli
   ```

2. **Login to Heroku**
   ```bash
   heroku login
   ```

3. **Create Heroku App**
   ```bash
   heroku create cabletechnow-api
   ```

4. **Set Environment Variables**
   ```bash
   heroku config:set STRIPE_SECRET_TEST=sk_test_your_actual_key
   heroku config:set STRIPE_WEBHOOK_SECRET=whsec_your_actual_secret
   heroku config:set NODE_ENV=production
   ```

5. **Deploy**
   ```bash
   git push heroku main
   ```

6. **Verify Deployment**
   ```bash
   heroku open
   # Should show: ✅ AssistMeTech Backend is running
   ```

### 2. Railway Deployment

1. **Connect Repository**
   - Go to [Railway](https://railway.app)
   - Connect your GitHub repository
   - Select the backend folder as root

2. **Set Environment Variables**
   - Add `STRIPE_SECRET_TEST`
   - Add `STRIPE_WEBHOOK_SECRET`
   - Add `NODE_ENV=production`

3. **Deploy**
   - Railway will automatically deploy on git push

### 3. Vercel Deployment

1. **Install Vercel CLI**
   ```bash
   npm i -g vercel
   ```

2. **Deploy**
   ```bash
   vercel --prod
   ```

3. **Set Environment Variables**
   - Use Vercel dashboard to add environment variables

### 4. AWS EC2 Deployment

1. **Launch EC2 Instance**
   - Choose Ubuntu 20.04 LTS
   - Configure security groups (port 4000)

2. **Setup Server**
   ```bash
   # Update system
   sudo apt update && sudo apt upgrade -y
   
   # Install Node.js
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs
   
   # Install PM2
   sudo npm install -g pm2
   ```

3. **Deploy Application**
   ```bash
   # Clone repository
   git clone <your-repo-url>
   cd cabletechnow-backend
   
   # Install dependencies
   npm install
   
   # Create .env file
   nano .env
   # Add your environment variables
   
   # Start with PM2
   pm2 start server.js --name "cabletechnow-api"
   pm2 startup
   pm2 save
   ```

### 5. Docker Deployment

1. **Build Docker Image**
   ```bash
   docker build -t cabletechnow-backend .
   ```

2. **Run with Docker Compose**
   ```bash
   docker-compose up -d
   ```

## 🔧 Environment Variables for Production

```env
# Stripe Configuration (Replace with actual values)
STRIPE_SECRET_TEST=sk_test_your_actual_stripe_key
STRIPE_WEBHOOK_SECRET=whsec_your_actual_webhook_secret

# Server Configuration
PORT=4000
NODE_ENV=production
```

## 🔒 Security Checklist

- [ ] Use HTTPS in production
- [ ] Set up proper CORS origins
- [ ] Use environment variables for secrets
- [ ] Enable rate limiting
- [ ] Set up monitoring and logging
- [ ] Configure webhook signature verification
- [ ] Use strong authentication
- [ ] Regular security updates

## 📊 Monitoring & Health Checks

### Health Check Endpoint
```bash
curl https://your-domain.com/
# Should return: ✅ AssistMeTech Backend is running
```

### Webhook Testing
```bash
# Test webhook endpoint
curl -X POST https://your-domain.com/api/webhook \
  -H "Content-Type: application/json" \
  -H "Stripe-Signature: test" \
  -d '{"test": "data"}'
```

## 🚨 Troubleshooting

### Common Issues

1. **Port Already in Use**
   ```bash
   # Kill process on port 4000
   lsof -ti:4000 | xargs kill -9
   ```

2. **Environment Variables Not Loading**
   ```bash
   # Check if .env file exists and has correct format
   cat .env
   ```

3. **Stripe Webhook Errors**
   ```bash
   # Check webhook secret is correctly set
   echo $STRIPE_WEBHOOK_SECRET
   ```

### Logs and Debugging

```bash
# View application logs (PM2)
pm2 logs cabletechnow-api

# View all PM2 processes
pm2 status

# Restart application
pm2 restart cabletechnow-api
```

## 📈 Performance Optimization

1. **Enable compression**
2. **Set up CDN for static assets**
3. **Configure caching headers**
4. **Use connection pooling**
5. **Monitor response times**

## 🔄 CI/CD Pipeline

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Production

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Setup Node.js
      uses: actions/setup-node@v2
      with:
        node-version: '18'
        
    - name: Install dependencies
      run: npm ci
      
    - name: Run tests
      run: npm test
      
    - name: Deploy to Heroku
      uses: akhileshns/heroku-deploy@v3.12.12
      with:
        heroku_api_key: ${{secrets.HEROKU_API_KEY}}
        heroku_app_name: "cabletechnow-api"
        heroku_email: "your-email@example.com"
```

---

**🎉 Your backend is now ready for production deployment!**