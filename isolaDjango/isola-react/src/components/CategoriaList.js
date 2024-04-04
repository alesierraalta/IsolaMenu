// components/CategoriaList.js

import React, { useState, useEffect } from 'react';
import { getCategorias } from '../services/categoriaService';

function CategoriaList() {
    const [categorias, setCategorias] = useState([]);

    useEffect(() => {
        const fetchData = async () => {
            const result = await getCategorias();
            setCategorias(result);
        };

        fetchData();
    }, []);

    return (
        <div>
            <h2>Categorías</h2>
            <ul>
                {categorias.map(categoria => (
                    <li key={categoria.ID_categoria}>{categoria.Nombre_categoria}</li>
                ))}
            </ul>
        </div>
    );
}

export default CategoriaList;
