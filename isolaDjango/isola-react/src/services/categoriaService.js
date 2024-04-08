// services/categoriaService.js

const API_URL = 'http://127.0.0.1:8000/api/menu/categorias/';

export const getCategorias = async () => {
    try {
        const response = await fetch(API_URL);
        if (!response.ok) {
            throw new Error('Error al obtener categorías');
        }
        return await response.json();
    } catch (error) {
        console.error("Error al obtener categorías:", error);
        return [];
    }
};

