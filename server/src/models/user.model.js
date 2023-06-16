const mongoose = require('mongoose')

const userMiddleware = require('../middlewares/user.middleware')

const Schema = mongoose.Schema

const userSchema = new Schema({
    fullName: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        lowercase: true,
        required: true,
        match: /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/,
        unique: true,
    },
    password: {
        type: String,
        minLength: 6,
        required: true,
    },
    image: String,

})

userSchema.pre('save', userMiddleware.hashPassword)
userSchema.pre('updateOne', userMiddleware.hashPassword)
userSchema.methods.comparePassword = userMiddleware.comparePassword

module.exports = mongoose.model('user', userSchema)
