// services/comidaService.js

const API_BASE_URL = 'http://127.0.0.1:8000/api/menu'; // Ajusta según sea necesario

export const getComidasPorCategoria = async (categoriaId) => {
    try {
        const response = await fetch(`${API_BASE_URL}/comidas/categoria/${categoriaId}/`); // Ajusta la URL según tu backend
        if (!response.ok) {
            throw new Error('Error al obtener comidas');
        }
        return await response.json();
    } catch (error) {
        console.error("Error al obtener comidas por categoría:", error);
        return [];
    }
};

