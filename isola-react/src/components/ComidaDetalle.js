// components/ComidaDetalle.js

import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Swiper, SwiperSlide } from 'swiper/react';
import 'swiper/css';
import 'swiper/css/pagination';
import 'swiper/css/navigation';
import { getComidasPorCategoria } from '../services/comidaService';
import './ComidaDetalle.css';

function ComidaDetalle() {
    const { categoriaId, comidaId } = useParams();
    const navigate = useNavigate();
    const [comidas, setComidas] = useState([]);
    const [initialSlide, setInitialSlide] = useState(0);

    useEffect(() => {
        async function fetchData() {
            const result = await getComidasPorCategoria(categoriaId);
            setComidas(result);
            const foundIndex = result.findIndex(comida => comida.ID_comida.toString() === comidaId);
            if (foundIndex >= 0) {
                setInitialSlide(foundIndex);
            }
        }
        fetchData();
    }, [categoriaId, comidaId]);

    return (
        <Swiper
            key={initialSlide}  // Clave que depende del initialSlide para forzar la reinstalación
            direction="vertical"
            slidesPerView={1}
            spaceBetween={30}
            initialSlide={initialSlide}
            pagination={{ clickable: true }}
            className="comida-detalle-swiper"
            onSlideChange={(swiper) => {
                const currentComida = comidas[swiper.activeIndex];
                if (currentComida) {
                    navigate(`/categoria/${categoriaId}/comida/${currentComida.ID_comida}`, { replace: true });
                }
            }}
        >
            {comidas.map((comida) => (
                <SwiperSlide key={comida.ID_comida} className="comida-detalle-slide">
                    <div className="comida-detalle-video-simulado">
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
