import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { getComidasPorCategoria } from '../services/comidaService';
import './ComidaList.css'; // Asegúrate de tener los estilos adecuados

function ComidaList() {
    let { id } = useParams(); // Obtiene el ID de categoría de los parámetros de la ruta
    const [comidas, setComidas] = useState([]);

    useEffect(() => {
        const fetchData = async () => {
            const result = await getComidasPorCategoria(id);
            setComidas(result);
        };

        fetchData();
    }, [id]); // La dependencia [id] asegura que useEffect se ejecute de nuevo si el ID de categoría cambia

    return (
        <div className="comidas-container">
            <div className="categoria-imagen-container">
                <span>Imagen Categoría</span>
            </div>
            <h2 className="plato-titulo">Platos</h2>
            <div className="comidas-lista">
                {comidas.map(comida => (
                    <div key={comida.ID_comida} className="comida-item">
                        <div className="comida-info">
                            <div className="comida-nombre">{comida.Nombre_comida}</div>
                            <div className="comida-precio">${comida.Precio_comida}</div>
                        </div>
                        <div className="comida-imagen">Imagen</div>
                    </div>
                ))}
            </div>
        </div>
    );
}

export default ComidaList;
