// components/ComidaDetalle.js

import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { Swiper, SwiperSlide } from 'swiper/react';
import 'swiper/css';
import 'swiper/css/pagination';
import 'swiper/css/navigation';
import { getComidasPorCategoria } from '../services/comidaService';
import './ComidaDetalle.css';

function ComidaDetalle() {
    const { categoriaId } = useParams();
    const [comidas, setComidas] = useState([]);

    useEffect(() => {
        const fetchData = async () => {
            const result = await getComidasPorCategoria(categoriaId);
            setComidas(result);
        };

        fetchData();
    }, [categoriaId]);

    return (
        <Swiper
            direction="vertical"
            slidesPerView={1}
            spaceBetween={30}
            pagination={{ clickable: true }}
            className="comida-detalle-swiper"
        >
            {comidas.map((comida) => (
                <SwiperSlide key={comida.ID_comida} className="comida-detalle-slide">
                    <div className="comida-detalle-video-simulado">
                        <h2>Video platillo</h2> {/* Simulación de video */}
                        <div className="comida-detalle-info">
                            <h2>{comida.Nombre_comida}</h2>
                            <p className="comida-descripcion">{comida.Descripcion_comida}</p>
                            <p>${comida.Precio_comida}</p>
                        </div>
                    </div>
                </SwiperSlide>
            ))}
        </Swiper>
    );
}

export default ComidaDetalle;
