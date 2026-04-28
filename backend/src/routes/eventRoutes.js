const express = require('express');

const eventController = require('../controllers/eventController');
const authenticate = require('../middleware/auth');

const router = express.Router();

router.get('/', eventController.listEvents);
router.get('/:id', eventController.getEventById);
router.post('/', authenticate(['access']), eventController.createEvent);
router.put('/:id', authenticate(['access']), eventController.updateEvent);
router.delete('/:id', authenticate(['access']), eventController.deleteEvent);
router.post('/:id/join', authenticate(['access']), eventController.joinEvent);
router.post('/:id/leave', authenticate(['access']), eventController.leaveEvent);
router.get('/:id/participants', eventController.getParticipants);

module.exports = router;