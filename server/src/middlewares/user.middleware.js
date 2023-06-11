const bcrypt = require('bcrypt')

exports.hashPassword = async function () {
    try {
        const user = this
        const salt = await bcrypt.genSalt(10)
        const hash = await bcrypt.hash(user.password, salt)
        user.password = hash
    } catch (error) {
        throw error
    }
}

exports.comparePassword = async function (userPassword) {
    try {
        const isMatch = await bcrypt.compare(userPassword, this.password)
        return isMatch
    } catch (error) {
        throw error
    }
}
