// CategoriaList.js
import React, { useState, useEffect } from 'react';
import { getCategorias } from '../services/categoriaService';
import './CategoriaList.css'; // Asegúrate de que el archivo CSS contiene los estilos que hemos definido

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
        <>
            <div className="logo-container">LOGO</div> {/* Contenedor del Logo */}
            <div className="categorias-container">
                {categorias.map((categoria, index) => (
                    <div key={categoria.ID_categoria} className="categoria-item">
                        <div className="categoria-nombre">{categoria.Nombre_categoria}</div>
                    </div>
                ))}
            </div>
        </>
    );
}


export default CategoriaList;
