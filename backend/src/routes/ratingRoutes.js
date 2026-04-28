const express = require('express');

const ratingController = require('../controllers/ratingController');
const authenticate = require('../middleware/auth');

const router = express.Router();

router.post('/', authenticate(['access']), ratingController.createRating);
router.get('/event/:eventId', ratingController.listRatingsByEvent);
router.get('/user/:userId', ratingController.listRatingsByUser);
router.put('/:id', authenticate(['access']), ratingController.updateRating);
router.delete('/:id', authenticate(['access']), ratingController.deleteRating);

module.exports = router;