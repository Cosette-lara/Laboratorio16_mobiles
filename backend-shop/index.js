const express = require('express');
const cors = require('cors');
const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

// --- BASE DE DATOS SIMULADA (En memoria) ---
let products = [
    {
        id: 1,
        title: "Mochila Urban",
        price: 45.99,
        description: "Mochila resistente al agua, ideal para laptops y viajes.",
        category: "accesories",
        // Imagen de mochila real desde Unsplash
        image: "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=600&q=80"
    },
    {
        id: 2,
        title: "Camiseta White Tee",
        price: 15.50,
        description: "Algodón 100% orgánico, corte moderno y fresco.",
        category: "clothing",
        // Imagen de camiseta real
        image: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=600&q=80"
    },
    {
        id: 3,
        title: "Tenis Running",
        price: 89.99,
        description: "Suela de alto impacto para corredores exigentes.",
        category: "footwear",
        // Imagen de zapatillas
        image: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=600&q=80"
    }
];

// GET: Listar
app.get('/products', (req, res) => {
    res.json(products);
});

// POST: Crear
app.post('/products', (req, res) => {
    const newProduct = {
        id: Date.now(), // ID único basado en tiempo
        title: req.body.title,
        price: parseFloat(req.body.price),
        description: req.body.description,
        image: req.body.image,
        category: req.body.category || 'general'
    };
    products.push(newProduct);
    console.log("Creado:", newProduct.title);
    res.status(201).json(newProduct);
});

// PUT: Editar
app.put('/products/:id', (req, res) => {
    const id = parseInt(req.params.id);
    const index = products.findIndex(p => p.id === id);
    if (index !== -1) {
        products[index] = { ...products[index], ...req.body, id: id };
        console.log("Actualizado ID:", id);
        res.json(products[index]);
    } else {
        res.status(404).json({ message: "No encontrado" });
    }
});

// DELETE: Eliminar
app.delete('/products/:id', (req, res) => {
    const id = parseInt(req.params.id);
    products = products.filter(p => p.id !== id);
    console.log("Eliminado ID:", id);
    res.status(200).json({ message: "Eliminado" });
});

app.listen(PORT, () => {
    console.log(`🚀 Servidor corriendo en puerto ${PORT}`);
});