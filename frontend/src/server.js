'use strict';
const express = require('express');
const helmet  = require('helmet');
const morgan  = require('morgan');

const app  = express();
const PORT = process.env.PORT || 3000;
const BACKEND_URL = process.env.BACKEND_URL || 'http://backend-svc:5000';

app.use(helmet());
app.use(morgan('combined'));
app.use(express.json());

app.get('/health', (_req, res) => {
  res.status(200).json({ status: 'healthy', service: 'frontend', ts: new Date().toISOString() });
});

app.get('/', (_req, res) => {
  res.status(200).json({ message: 'Frontend running', backend: BACKEND_URL });
});

app.listen(PORT, () => console.log(`[frontend] port ${PORT}`));
module.exports = app;
