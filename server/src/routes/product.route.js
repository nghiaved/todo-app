const express = require('express')

const productController = require('../controllers/product.controller')

const router = express.Router()

const productRoute = app => {
    router.post('/create', productController.handleCreate)
    router.get('/read', productController.handleRead)

    return app.use('/api/product', router)
}

module.exports = productRoute
