import React, { useState, useEffect } from 'react';
import { getCategorias } from '../services/categoriaService';
import { Link } from 'react-router-dom';
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
        <div className="main-container">
            <div className="logo-container">LOGO</div>
            <h2 className="categorias-titulo">CATEGORIAS</h2>
            <div className="categorias-container">
                {categorias.map((categoria) => (
                    <Link to={`/categoria/${categoria.ID_categoria}`} key={categoria.ID_categoria} className="categoria-item">
                        <div className="categoria-nombre">{categoria.Nombre_categoria}</div>
                    </Link>
                ))}
            </div>
        </div>
    );
}

export default CategoriaList;
