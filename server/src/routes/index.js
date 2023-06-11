const userRoute = require('./user.route')

const routes = app => {
    userRoute(app)
}

module.exports = routes
