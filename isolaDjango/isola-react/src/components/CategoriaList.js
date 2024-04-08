import React, { useState, useEffect } from 'react';
import { getCategorias } from '../services/categoriaService';
import './CategoriaList.css';

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
        <div className="main-container"> {/* Contenedor principal para todo */}
            <div className="logo-container">LOGO</div>
            <h2 className="categorias-titulo">CATEGORIAS</h2> {/* Título a la izquierda */}
            <div className="categorias-container">
                {categorias.map((categoria, index) => (
                    <div key={categoria.ID_categoria} className="categoria-item">
                        <div className="categoria-nombre">{categoria.Nombre_categoria}</div>
                    </div>
                ))}
            </div>
        </div>
    );
}

export default CategoriaList;
