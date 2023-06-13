const ProductService = require('../services/product.service')

const productController = {
    handleCreate: async (req, res, next) => {
        const { name, desc, price } = req.body
        const img = req.files.img.name
        await ProductService.createProduct(name, desc, img, price)
            .then(() => {
                req.files.img.mv('./src/uploads/' + img)
                res.json({ status: true, success: 'Product created Successfully' })
            })
            .catch(next)
    },

    handleRead: async (req, res, next) => {
        await ProductService.readProduct()
            .then(products => res.status(200).json({
                products
            }))
            .catch(next)
    }
}

module.exports = productController
