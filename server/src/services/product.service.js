const productModel = require('../models/product.model')

class ProductService {
    static async createProduct(name, desc, img, price) {
        try {
            const createProduct = new productModel({
                name, desc, img, price
            })
            return await createProduct.save()
        } catch (error) {
            throw error
        }
    }

    static async readProduct() {
        try {
            return await productModel.find()
        } catch (error) {
            throw error
        }
    }
}

module.exports = ProductService
