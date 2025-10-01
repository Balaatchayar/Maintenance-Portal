const express = require('express');
const router = express.Router();

router.get('/test', (req, res) => {
  res.send('Maintenance route working!');
});

module.exports = router;
