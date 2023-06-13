const userRoute = require('./user.route')
const productRoute = require('./product.route')

const routes = app => {
    userRoute(app)
    productRoute(app)
}

module.exports = routes
