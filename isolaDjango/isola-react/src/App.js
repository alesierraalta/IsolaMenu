import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import CategoriaList from './components/CategoriaList';
import ComidaList from './components/ComidaList'; // Asume que tienes un componente para listar las comidas
import './App.css'; // Importa tus estilos globales

function App() {
  return (
    <Router>
      <div className="App">
        <header className="App-header"> {/* Aquí especificas .App-header */}
          {/* Puedes poner contenido adicional aquí, como un logo o un menú de navegación */}
          <Routes> {/* 'Routes' para definir tus rutas */}
            <Route path="/" element={<CategoriaList />} />
            <Route path="/categoria/:id" element={<ComidaList />} />
            {/* Configura más rutas según sea necesario */}
          </Routes>
        </header>
      </div>
    </Router>
  );
}

export default App;
