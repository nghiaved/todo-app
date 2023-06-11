const express = require('express')

const userController = require('../controllers/user.controller')

const router = express.Router()

const userRoute = app => {
    router.post('/register', userController.handleResigter)
    router.post('/login', userController.handleLogin)

    return app.use('/api/user', router)
}

module.exports = userRoute
